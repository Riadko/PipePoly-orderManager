const express = require('express');
const router = express.Router();
const pool = require('../config/db');
const PDFDocument = require('pdfkit');
const { authRequired, requirePermissions } = require('../middleware/auth');
const fs = require('fs');
const path = require('path');

const Product = require('../models/productModel');
const ProductBOM = require('../models/productBomModel');
const Inventory = require('../models/inventoryModel');
// inventory_segments removed from simplified workflow
const StockMovement = require('../models/stockMovementModel');
const { getAllOrders, getOrdersByStatus, addOrder, validateOrder, finishOrder } = require('../models/orderModel');

// Multer for multipart handling (files in memory)
const multer = require('multer');
const upload = multer({ storage: multer.memoryStorage() });

// Detect "Pièce spéciale" product name (case-insensitive, accent-insensitive variants)
function isSpecialPieceName(name = '') {
  const s = String(name || '').toLowerCase();
  return s.includes('pièce spéciale') || s.includes('piece speciale');
}

// Ensure attachments table exists (store one file per order item index)
async function ensureOrderItemAttachmentsTable() {
  await pool.query(`
    CREATE TABLE IF NOT EXISTS public.order_item_attachments (
      id SERIAL PRIMARY KEY,
      order_id INTEGER NOT NULL REFERENCES public.orders(id) ON DELETE CASCADE,
      item_index INTEGER NOT NULL,
      filename TEXT,
      mime_type TEXT,
      file_data BYTEA
    )
  `);
}

// Strict date parsing helper: supports 'YYYY-MM-DD' and defaults to noon UTC to avoid TZ shift
function parseDateStrict(val) {
  if (!val) return null;
  if (typeof val === 'string' && /^\d{4}-\d{2}-\d{2}$/.test(val)) {
    return new Date(`${val}T12:00:00Z`);
  }
  const d = new Date(val);
  return isNaN(d.getTime()) ? null : d;
}

// Helper: build a company-styled order PDF and return buffer + filename
async function buildOrderPdfBuffer(order, items) {
    // try to fetch client info (address) before PDF stream creation
    let clientInfo = null;
    try {
        const cRes = await pool.query('SELECT address, city, postal_code, country FROM clients WHERE company = $1 LIMIT 1', [order.client_name || order.client || '']);
        if (cRes && cRes.rows && cRes.rows[0]) clientInfo = cRes.rows[0];
    } catch (e) {
        clientInfo = null;
    }

    // NEW: compute tube usage (sum of 'out' movements where inventory name contains 'tube')
    let tubeUsageTotal = null;
    try {
        const usageSql = `
          SELECT SUM(sm.quantity) AS total
          FROM stock_movements sm
          JOIN inventory i ON i.id = sm.inventory_id
          WHERE sm.order_id = $1
            AND sm.movement_type = 'out'
            AND LOWER(i.name) LIKE '%tube%'
        `;
        const uRes = await pool.query(usageSql, [order.id]);
        tubeUsageTotal = uRes.rows[0] && uRes.rows[0].total ? Number(uRes.rows[0].total) : 0;
    } catch (e) {
        tubeUsageTotal = null; // if schema difference, just omit
    }

    // Collect per-tube usage rows (grouped) for later display
    let tubeUsageRows = [];
    try {
        const perTubeSql = `
          SELECT i.name, COALESCE(i.unit, sm.unit) AS unit, SUM(sm.quantity) AS qty
          FROM stock_movements sm
          JOIN inventory i ON i.id = sm.inventory_id
          WHERE sm.order_id = $1
            AND sm.movement_type = 'out'
            AND LOWER(i.name) LIKE '%tube%'
          GROUP BY i.name, COALESCE(i.unit, sm.unit)
          ORDER BY i.name
        `;
        const perTubeRes = await pool.query(perTubeSql, [order.id]);
        tubeUsageRows = perTubeRes.rows || [];
    } catch (e) {
        tubeUsageRows = [];
    }

    // Load attachments saved per item index (if any)
    let attRows = [];
    try {
      const aRes = await pool.query(
        'SELECT item_index, filename, mime_type, file_data FROM order_item_attachments WHERE order_id = $1 ORDER BY item_index',
        [order.id]
      );
      attRows = aRes.rows || [];
    } catch (e) {
      attRows = [];
    }
    const attachmentsByIndex = new Map();
    attRows.forEach(r => { attachmentsByIndex.set(Number(r.item_index), r); });

    return new Promise((resolve, reject) => {
        try {
            const doc = new PDFDocument({ size: 'A4', margin: 40 });
            const chunks = [];
            doc.on('data', c => chunks.push(c));

            // replace the 'end' handler to post-process with pdf-lib
            doc.on('end', async () => {
              try {
                const baseBuffer = Buffer.concat(chunks);
                const safeOrderNumber = String(order.order_number || order.id).replace(/\s+/g, '_');

                // Default final buffer is the base PDFKit output
                let finalBuffer = baseBuffer;

                // If we have attachments, try to merge/attach with pdf-lib
                const hasAttachments = Array.isArray(attRows) && attRows.length > 0;
                if (hasAttachments) {
                  let PDFDocument;
                  try { ({ PDFDocument } = require('pdf-lib')); } catch { PDFDocument = null; }
                  if (PDFDocument) {
                    const outDoc = await PDFDocument.load(baseBuffer);

                    for (const a of attRows) {
                      try {
                        const name = a.filename || 'piece-jointe';
                        const mime = String(a.mime_type || '').toLowerCase();
                        const data = a.file_data ? (Buffer.isBuffer(a.file_data) ? a.file_data : Buffer.from(a.file_data)) : null;
                        if (!data) continue;

                        if (mime === 'application/pdf' || mime.endsWith('/pdf')) {
                          // Append the pages of the attached PDF at the end of our document
                          const src = await PDFDocument.load(data);
                          const pages = await outDoc.copyPages(src, src.getPageIndices());
                          pages.forEach(p => outDoc.addPage(p));
                        } else {
                          // Embed any other file as an attachment within the PDF
                          await outDoc.attach(data, name, { mimeType: mime || 'application/octet-stream', description: 'Pièce jointe' });
                        }
                      } catch (mergeErr) {
                        // Skip faulty attachment but keep the rest
                        console.warn('Attachment skipped:', mergeErr.message);
                      }
                    }

                    const outBytes = await outDoc.save();
                    finalBuffer = Buffer.from(outBytes);
                  } else {
                    console.warn('pdf-lib not installed; attachments kept only as image annex (if any). Run: npm i pdf-lib');
                  }
                }

                resolve({ buffer: finalBuffer, filename: `BC_${safeOrderNumber}.pdf` });
              } catch (postErr) {
                // Fallback: return the base PDF even if post-processing failed
                console.warn('Attachment merge failed, returning base PDF:', postErr.message);
                const baseBuffer = Buffer.concat(chunks);
                const safeOrderNumber = String(order.order_number || order.id).replace(/\s+/g, '_');
                resolve({ buffer: baseBuffer, filename: `BC_${safeOrderNumber}.pdf` });
              }
            });

            doc.on('error', reject);

            // --- Header (company block top-left and top-right) ---
            // Left: company banner/title (use logo image if present)
            try {
                const logoPath = path.resolve(__dirname, '..', '..', 'frontend', 'public', 'logoBlack.png');
                if (fs.existsSync(logoPath)) {
                    // place logo at top-left, fit to width
                    doc.image(logoPath, 50, 30, { width: 110 });
                } else {
                    doc.fontSize(14).font('Helvetica-Bold').text('PIPE POLY', 50, 40);
                }
            } catch (e) {
                // fallback to text
                doc.fontSize(14).font('Helvetica-Bold').text('PIPE POLY', 50, 40);
            }
            doc.fontSize(9).font('Helvetica').text('Technologies de soudage & Fabrication de raccords en PEHD', 50, 88);

            // Right: contact block
            doc.fontSize(9).text('Pipe Poly Sarl', 380, 40, { align: 'right' });
            doc.text('Tél: 0560 91 18 33', 380, 54, { align: 'right' });
            doc.text('0560 93 81 60', 380, 68, { align: 'right' });
            doc.text('Fax : 023 92 06 14', 380, 82, { align: 'right' });
            doc.text('contact@pipepoly.com', 380, 94, { align: 'right' });
            doc.text('www.pipepoly.com', 380, 106, { align: 'right' });

            // Title and order ref on the left under header
            doc.moveDown(1);
            doc.fontSize(16).font('Helvetica-Bold').text('Commande Client', 50, 110);
            doc.fontSize(10).font('Helvetica').text(`Ref: ${order.order_number || order.id}`, 50, 132);

            // Client block (center-left)
            const clientTop = 160;
            doc.lineWidth(0.8).rect(50, clientTop, 500, 70).stroke();
            doc.fontSize(11).font('Helvetica-Bold').text((order.client_name || '').toUpperCase(), 58, clientTop + 6);
            if (clientInfo) {
                const addressParts = [clientInfo.address, clientInfo.city, clientInfo.postal_code, clientInfo.country].filter(Boolean);
                const addressLine = addressParts.join(', ');
                doc.fontSize(9).font('Helvetica').text(addressLine, 58, clientTop + 26, { width: 420 });
                if (order.remarks) doc.fontSize(9).font('Helvetica').text(order.remarks, 58, clientTop + 44, { width: 420 });
            } else {
                if (order.remarks) doc.fontSize(9).font('Helvetica').text(order.remarks, 58, clientTop + 26, { width: 420 });
            }

            // Company registration block small lines (mimic sample)
            doc.fontSize(8).text('RC :', 58, clientTop + 50);
            doc.text('AI :', 140, clientTop + 50);
            doc.text('NIS :', 220, clientTop + 50);

            // Dates block (right) - nudged slightly left to match visual sample
            const datesX = 360; // moved a bit left from 380
            doc.fontSize(10).text(`Date: ${order.order_date ? new Date(order.order_date).toLocaleDateString('fr-FR') : ''}`, datesX, clientTop + 8, { align: 'right' });
            doc.text(`Delivery: ${order.delivery_date ? new Date(order.delivery_date).toLocaleDateString('fr-FR') : ''}`, datesX, clientTop + 26, { align: 'right' });

            // Table header
            const tableTop = 250;

            // Normalize items: prefer JSON from orders.items (includes pn/flanged/flange_type/remarks)
            const src = Array.isArray(order?.items) && order.items.length ? order.items
                      : Array.isArray(items) ? items
                      : [];
            const list = src.map(it => ({
                product: it.product || it.designation || '',
                quantity: Number(it.quantity || 0),
                code: it.code || '',
                pn: it.pn || 'PN16',
                flanged: !!it.flanged,
                flange_type: it.flange_type || (it.flanged ? 'acier' : '—'),
                remarks: (it.remarks || '').toString().trim()
            }));

            // FIX: define table coordinates before first use
            const tableLeft = 50;
            const tableWidth = 500;

            // Columns width sum must be 500
            const wNo = 28, wCode = 80, wDesc = 200, wPN = 44, wBrid = 50, wType = 70, wQty = 28;
            const xNo   = tableLeft;
            const xCode = xNo   + wNo;
            const xDesc = xCode + wCode;
            const xPN   = xDesc + wDesc;
            const xBrid = xPN   + wPN;
            const xType = xBrid + wBrid;
            const xQty  = xType + wType;

            // Measure dynamic row heights (designation may wrap + optional remarks)
            const measureRowHeight = (row) => {
                // product line height at fs=10
                doc.font('Helvetica').fontSize(10);
                const productH = doc.heightOfString(row.product || '', { width: wDesc - 12, align: 'left' }) || 10;
                // remarks line height at fs=8 (optional)
                let remarksH = 0;
                if (row.remarks) {
                    doc.font('Helvetica').fontSize(8);
                    remarksH = doc.heightOfString(`(${row.remarks})`, { width: wDesc - 12, align: 'left' }) || 8;
                }
                // small top padding + content + small bottom padding; minimum 20
                return Math.max(20, 4 + productH + (row.remarks ? remarksH : 0) + 2);
            };
            const rowHeights = list.map(measureRowHeight);
            const rowsTotal = rowHeights.reduce((s, h) => s + h, 0);
            const tableHeight = Math.max(80, 24 /* header */ + 6 /* gap to first row */ + rowsTotal);

            // Draw outer box
            doc.lineWidth(1).rect(tableLeft, tableTop, tableWidth, tableHeight).stroke();

            // Header row background
            doc.rect(tableLeft, tableTop, tableWidth, 24).fillOpacity(0.03).fillAndStroke('#000000', '#000000');
            doc.fillOpacity(1);

            // Header labels
            doc.fillColor('#000000').fontSize(10).font('Helvetica-Bold');
            doc.text('N°', xNo + 6,   tableTop + 6);
            doc.text('CODE', xCode + 6, tableTop + 6);
            doc.text('DÉSIGNATION', xDesc + 6, tableTop + 6);
            doc.text('PN', xPN + 6,   tableTop + 6);
            doc.text('BRIDÉ', xBrid + 6, tableTop + 6);
            doc.text('TYPE BRIDE', xType + 6, tableTop + 6);
            doc.text('QTÉ', xQty + 2, tableTop + 6, { width: wQty - 4, align: 'center' });

            // Vertical separators (span full table height)
            doc.moveTo(xCode, tableTop).lineTo(xCode, tableTop + tableHeight).stroke();
            doc.moveTo(xDesc, tableTop).lineTo(xDesc, tableTop + tableHeight).stroke();
            doc.moveTo(xPN,   tableTop).lineTo(xPN,   tableTop + tableHeight).stroke();
            doc.moveTo(xBrid, tableTop).lineTo(xBrid, tableTop + tableHeight).stroke();
            doc.moveTo(xType, tableTop).lineTo(xType, tableTop + tableHeight).stroke();
            doc.moveTo(xQty,  tableTop).lineTo(xQty,  tableTop + tableHeight).stroke();

            // Rows
            let y = tableTop + 24 + 6; // below header
            list.forEach((it, idx) => {
                const rowH = rowHeights[idx];
                const textY = y + 4;

                // N°
                doc.font('Helvetica').fontSize(10).fillColor('#000000');
                doc.text(String(idx + 1), xNo + 6, textY, { width: wNo - 12 });

                // CODE
                if (it.code) {
                    doc.text(String(it.code), xCode + 6, textY, { width: wCode - 12 });
                }

                // DÉSIGNATION + optional remarks in smaller font under product
                doc.font('Helvetica').fontSize(10).fillColor('#000000');
                const productH = doc.heightOfString(it.product || '', { width: wDesc - 12 }) || 10;
                doc.text(it.product || '', xDesc + 6, textY, { width: wDesc - 12 });
                if (it.remarks) {
                    doc.font('Helvetica').fontSize(8).fillColor('#444444');
                    doc.text(`(${it.remarks})`, xDesc + 6, textY + productH, { width: wDesc - 12 });
                    // reset for next fields
                    doc.font('Helvetica').fontSize(10).fillColor('#000000');
                }

                // PN
                doc.text(String(it.pn || ''), xPN + 6, textY, { width: wPN - 12 });

                // BRIDÉ
                doc.text(it.flanged ? 'Oui' : 'Non', xBrid + 6, textY, { width: wBrid - 12 });

                // TYPE BRIDE
                doc.text(String(it.flange_type || '—'), xType + 6, textY, { width: wType - 12 });

                // QTÉ (center)
                doc.text(String(it.quantity || ''), xQty + 2, textY, { width: wQty - 4, align: 'center' });

                // Page break safety (account for footer area)
                y += rowH;
                const bottomLimit = doc.page.height - (doc.page.margins.bottom || 40) - 100;
                if (y > bottomLimit) {
                    doc.addPage();
                    // redraw table header on new page (simple approach)
                    // Outer box for continuation page (same columns)
                    const remHeight = (list.slice(idx + 1).reduce((s, _, k) => s + rowHeights[idx + 1 + k], 0)) + 24 + 6;
                    doc.lineWidth(1).rect(tableLeft, tableTop, tableWidth, Math.max(80, remHeight)).stroke();
                    // Header background + labels again
                    doc.rect(tableLeft, tableTop, tableWidth, 24).fillOpacity(0.03).fillAndStroke('#000000', '#000000');
                    doc.fillOpacity(1);
                    doc.fillColor('#000000').fontSize(10).font('Helvetica-Bold');
                    doc.text('N°', xNo + 6,   tableTop + 6);
                    doc.text('CODE', xCode + 6, tableTop + 6);
                    doc.text('DÉSIGNATION', xDesc + 6, tableTop + 6);
                    doc.text('PN', xPN + 6,   tableTop + 6);
                    doc.text('BRIDÉ', xBrid + 6, tableTop + 6);
                    doc.text('TYPE BRIDE', xType + 6, tableTop + 6);
                    doc.text('QTÉ', xQty + 2, tableTop + 6, { width: wQty - 4, align: 'center' });
                    // Column lines
                    doc.moveTo(xCode, tableTop).lineTo(xCode, doc.page.height - (doc.page.margins.bottom || 40) - 100).stroke();
                    doc.moveTo(xDesc, tableTop).lineTo(xDesc, doc.page.height - (doc.page.margins.bottom || 40) - 100).stroke();
                    doc.moveTo(xPN,   tableTop).lineTo(xPN,   doc.page.height - (doc.page.margins.bottom || 40) - 100).stroke();
                    doc.moveTo(xBrid, tableTop).lineTo(xBrid, doc.page.height - (doc.page.margins.bottom || 40) - 100).stroke();
                    doc.moveTo(xType, tableTop).lineTo(xType, doc.page.height - (doc.page.margins.bottom || 40) - 100).stroke();
                    doc.moveTo(xQty,  tableTop).lineTo(xQty,  doc.page.height - (doc.page.margins.bottom || 40) - 100).stroke();
                    // reset y for next rows on new page
                    y = tableTop + 24 + 6;
                }
            });

            // Signature block (use dynamic table height)
            
            const footerTop = tableTop + tableHeight + 20;
            doc.fontSize(10).text('Accusé de Réception', tableLeft, footerTop);
            doc.text('Nom : ____________________', tableLeft, footerTop + 18);
            doc.text('Signature Client: ____________________', tableLeft, footerTop + 36);
            doc.text('Pipe Poly Dépôt', 380, footerTop + 36, { align: 'right' });

            // --- NEW PRODUCTION / FINITION DETAILS SECTION (directly under signatures) ---
            const pageBottomBase = () => doc.page.height - (doc.page.margins.bottom || 40);
            const footerBaseY = pageBottomBase() - 36; // where legal / banking footer starts
            let sectionY = footerTop + 60; // space after signatures

            // Estimate required height:
            const perTubeRowsHeight = tubeUsageRows.length ? (16 /* header */ + tubeUsageRows.length * 12 + 10) : 0;
            const remarksBoxHeight = 70;
            const metaHeight = 14 * 2 + 18; // Worker + Machine + heading spacing
            const required = 20 + metaHeight + perTubeRowsHeight + remarksBoxHeight + 10;

            // If not enough space before footer area, add a new page
            if (sectionY + required > footerBaseY - 10) {
                doc.addPage();
                sectionY = doc.y + 10;
            }

            // Heading
            doc.fontSize(11).font('Helvetica-Bold').text('Production / Finition', tableLeft, sectionY);
            sectionY += 18;
            doc.fontSize(9).font('Helvetica');
            doc.text(`Ouvrier : ${order.worker || ''}`, tableLeft, sectionY);
            sectionY += 14;
            doc.text(`Machine : ${order.machine || ''}`, tableLeft, sectionY);
            sectionY += 18;

            // Per-tube usage table (each tube – NOT the sum)
            if (tubeUsageRows.length) {
                doc.font('Helvetica-Bold').text('Consommation Tube (détail) :', tableLeft, sectionY);
                sectionY += 14;
                const colX1 = tableLeft;
                const colX2 = tableLeft + 300;
                const colX3 = tableLeft + 380;
                doc.text('Tube', colX1, sectionY);
                doc.text('Quantité', colX2, sectionY);
                doc.text('Unité', colX3, sectionY);
                sectionY += 12;
                doc.font('Helvetica');
                tubeUsageRows.forEach(r => {
                    // page break safety
                    if (sectionY > footerBaseY - 90) {
                        doc.addPage();
                        sectionY = doc.y + 10;
                        doc.font('Helvetica-Bold').text('Consommation Tube (suite) :', tableLeft, sectionY);
                        sectionY += 14;
                        doc.font('Helvetica-Bold');
                        doc.text('Tube', colX1, sectionY);
                        doc.text('Quantité', colX2, sectionY);
                        doc.text('Unité', colX3, sectionY);
                        sectionY += 12;
                        doc.font('Helvetica');
                    }
                    doc.text(r.name || '', colX1, sectionY, { width: 290 });
                    doc.text(String(r.qty || 0), colX2, sectionY);
                    doc.text(r.unit || '', colX3, sectionY);
                    sectionY += 12;
                });
                sectionY += 6;
            }

            // Remarks rectangle
            doc.font('Helvetica-Bold').text('Remarques :', tableLeft, sectionY);
            const boxY = sectionY + 6;
            const boxH = 70;
            // Page break safety for remarks box
            if (boxY + boxH > footerBaseY - 10) {
                doc.addPage();
                sectionY = doc.y + 10;
                doc.font('Helvetica-Bold').text('Remarques :', tableLeft, sectionY);
                sectionY += 6;
            }
            doc.rect(tableLeft, sectionY + 0, tableWidth, boxH).stroke();
            if (order.finish_remarks) {
                doc.font('Helvetica').fontSize(9).text(order.finish_remarks, tableLeft + 6, sectionY + 6, {
                    width: tableWidth - 12,
                    height: boxH - 12
                });
            }
            // Move cursor past box
            sectionY += boxH + 10;

            // Footer (legal + bank info) AFTER the production section
            const drawFooter = () => {
                const left = doc.page.margins.left || 40;
                const right = doc.page.width - (doc.page.margins.right || 40);
                const usableWidth = right - left;
                const base = doc.page.height - (doc.page.margins.bottom || 40) - 36;
                doc.fontSize(8).font('Helvetica').text(
                    'RC - N°: 00B0014452-02/09 • AI - N°: 09190324312 • NIF - N°: 00001600144522209002 • NIS - N°: 000116150534362',
                    left,
                    base,
                    { width: usableWidth, align: 'center' }
                );
                doc.fontSize(8).text(
                    'Comptes bancaires N° RIB : BNA El Harrach : 00 100 616 0300 313 645 / 58 • BNA Oued Smar : 00 100 634 0300 000 521 / 55',
                    left,
                    base + 14,
                    { width: usableWidth, align: 'center' }
                );
            };
            drawFooter();
            doc.on('pageAdded', drawFooter);

            // ANNEXES: “Pièce spéciale” attachments on the next page
            try {
              // collect only items that are "pièce spéciale" and have an attachment
              const specialWithAtt = list
                .map((it, idx) => ({ it, idx, att: attachmentsByIndex.get(idx) }))
                .filter(x => {
                  const name = (x.it.product || '').toLowerCase();
                  const isSpecial = name.includes('pièce spéciale') || name.includes('piece speciale');
                  return isSpecial && x.att && x.att.file_data;
                });

              if (specialWithAtt.length) {
                // start Annexes on new page
                doc.addPage();
                // Title
                doc.font('Helvetica-Bold').fontSize(14).fillColor('#000').text('Annexes — Pièce spéciale', 50, 40);
                doc.font('Helvetica').fontSize(9).fillColor('#333').text(`Commande: ${order.order_number || order.id}`, 50, 58);

                // layout constants
                const marginL = doc.page.margins.left || 40;
                const marginR = doc.page.margins.right || 40;
                const usableW = doc.page.width - marginL - marginR;
                const topStart = 80;
                let y = topStart;

                // For each attachment: if image/*, render it; else, render a file card (name + type)
                for (let i = 0; i < specialWithAtt.length; i++) {
                  const { it, idx, att } = specialWithAtt[i];
                  const isImage = (att.mime_type || '').toLowerCase().startsWith('image/');
                  const caption = `${it.product} — Qté: ${it.quantity} — ${it.pn}${it.flanged ? `, bridé ${it.flange_type}` : ''} (${att.filename || 'pièce jointe'})`;

                  // ensure space, else new page
                  const neededH = isImage ? 360 + 38 : 84; // rough blocks
                  const bottomLimit = doc.page.height - (doc.page.margins.bottom || 40) - 40;
                  if (y + neededH > bottomLimit) {
                    doc.addPage();
                    doc.font('Helvetica-Bold').fontSize(14).fillColor('#000').text('Annexes — Pièce spéciale (suite)', 50, 40);
                    y = topStart;
                  }

                  if (isImage) {
                    // Render image centered with fit; reserve ~360px height
                    const imgBuf = Buffer.from(att.file_data);
                    try {
                      doc.image(imgBuf, marginL, y, { fit: [usableW, 360], align: 'center', valign: 'center' });
                    } catch (e) {
                      // if image fails (corrupt), fallback to file card
                      doc.rect(marginL, y, usableW, 60).strokeColor('#999').stroke();
                      doc.font('Helvetica').fontSize(10).fillColor('#000').text(att.filename || 'pièce jointe (image non lisible)', marginL + 8, y + 8, { width: usableW - 16 });
                      y += 70;
                    }
                    // caption
                    doc.font('Helvetica').fontSize(9).fillColor('#444').text(caption, marginL, y + 368, { width: usableW });
                    y += 368 + 24;
                  } else {
                    // File card box
                    doc.rect(marginL, y, usableW, 60).strokeColor('#999').stroke();
                    doc.font('Helvetica-Bold').fontSize(10).fillColor('#000').text(att.filename || 'pièce jointe', marginL + 8, y + 8, { width: usableW - 16 });
                    doc.font('Helvetica').fontSize(9).fillColor('#444').text(`Type: ${att.mime_type || 'inconnu'}`, marginL + 8, y + 26);
                    doc.font('Helvetica').fontSize(9).fillColor('#444').text(caption, marginL + 8, y + 40, { width: usableW - 16 });
                    y += 74;
                  }
                }
              }
            } catch (annexErr) {
              // swallow annex errors to not block PDF
              console.warn('Annex page skipped:', annexErr.message);
            }

            doc.end();
        } catch (err) { reject(err); }
    });
}

// Helper: compute next order number for prefix CC.P00204
async function getNextOrderNumber(prefix = 'CC.P00204') {
    // find max numeric suffix for existing orders with that prefix
    try {
        const sql = `SELECT MAX((regexp_replace(order_number, '^.*\\/',''))::int) AS maxnum FROM orders WHERE order_number LIKE $1 AND regexp_replace(order_number, '^.*\\/','') ~ '^[0-9]+$'`;
        const { rows } = await pool.query(sql, [prefix + '/%']);
        const maxnum = rows && rows[0] && rows[0].maxnum ? Number(rows[0].maxnum) : 0;
        const next = maxnum + 1;
        return { next, order_number: `${prefix}/${next}` };
    } catch (err) {
        console.error('Error computing next order number', err);
        return { next: 1, order_number: `${prefix}/1` };
    }
}

// Inventory endpoints
// GET /orders/inventory -> list inventory items with current total_quantity
router.get('/inventory', authRequired, requirePermissions(['inventory.read']), async (req, res) => {
    try {
        const items = await Inventory.getAll();
        res.json(items);
    } catch (err) {
        console.error('Error fetching inventory:', err);
        res.status(500).json({ error: err.message });
    }
});

// GET /orders/inventory/:id/movements?from=YYYY-MM-DD&to=YYYY-MM-DD
router.get('/inventory/:id/movements', authRequired, requirePermissions(['inventory.read']), async (req, res) => {
    const { id } = req.params;
    const { from, to } = req.query;
    try {
        // First attempt: select stock_movements using created_at (newer schemas)
        let sql = 'SELECT id, inventory_id, segment_id, order_id, movement_type, quantity, unit, reason, created_at FROM stock_movements WHERE inventory_id = $1';
        const params = [id];
        if (from) {
            params.push(from);
            sql += ` AND created_at >= $${params.length}`;
        }
        if (to) {
            params.push(to);
            sql += ` AND created_at <= $${params.length}`;
        }
        sql += ' ORDER BY created_at ASC';

        const { rows } = await pool.query(sql, params);
        res.json(rows);
    } catch (err) {
        // If column created_at doesn't exist in older schemas, fallback to query without it
        if (err && err.message && err.message.toLowerCase().includes('created_at')) {
            try {
                let sql2 = 'SELECT id, inventory_id, segment_id, order_id, movement_type, quantity, unit, reason, NULL::timestamp AS created_at FROM stock_movements WHERE inventory_id = $1 ORDER BY id ASC';
                const { rows } = await pool.query(sql2, [id]);
                return res.json(rows);
            } catch (err2) {
                console.error('Error fetching inventory movements (fallback):', err2);
                return res.status(500).json({ error: err2.message });
            }
        }
        console.error('Error fetching inventory movements:', err);
        res.status(500).json({ error: err.message });
    }
});

// Change order status to production, deduct inventory, and trace movements
router.put('/:id/production', authRequired, requirePermissions(['orders.update']), async (req, res) => {
    const { id } = req.params;
    try {
        const orderResult = await pool.query('SELECT * FROM orders WHERE id = $1', [id]);
        const order = orderResult.rows[0];
        if (!order) return res.status(404).json({ error: 'Order not found' });

        // Load order items
        const oiRes = await pool.query('SELECT * FROM order_items WHERE order_id = $1', [order.id]);
        const orderItems = oiRes.rows;
        if (!orderItems.length) return res.status(400).json({ error: 'No items found for this order' });

        // For each item, find product, BOM and deduct inventory
        for (const it of orderItems) {
            // Skip inventory deduction for "Pièce spéciale"
            if (isSpecialPieceName(it.product)) {
                continue;
            }
            const prodRows = await pool.query('SELECT * FROM products WHERE name = $1', [it.product]);
            const prod = prodRows.rows[0];
            if (!prod) return res.status(404).json({ error: `Product not found in catalog: ${it.product}` });

            const bomItems = await ProductBOM.getByProductId(prod.id);
            if (!bomItems.length) return res.status(400).json({ error: `No BOM defined for ${it.product}` });

            for (const bom of bomItems) {
                const totalNeeded = Number(bom.quantity) * Number(it.quantity);
                const inv = await Inventory.getById(bom.inventory_item_id);
                if (!inv) return res.status(404).json({ error: 'Inventory item not found' });
                if (Number(inv.total_quantity) < totalNeeded) return res.status(400).json({ error: `Stock insuffisant pour ${inv.name}` });

                const newTotal = Number(inv.total_quantity) - totalNeeded;
                await Inventory.updateQuantity(bom.inventory_item_id, newTotal);

                // record a single movement
                await StockMovement.create({
                    inventory_id: bom.inventory_item_id,
                    segment_id: null,
                    order_id: order.id,
                    movement_type: 'out',
                    quantity: totalNeeded,
                    unit: bom.unit,
                    reason: `Commande #${order.order_number} production`
                });
            }
        }

        // Ici, on ne touche pas au champ status (urgent/normal/can wait),
        // le workflow Kanban reste géré par les booléens validated et finished.

        res.json({ message: 'Stock déduit, commande en production.' });
    } catch (err) {
        console.error('Erreur production:', err);
        res.status(500).json({ error: err.message });
    }
});

// Function to send an email via Formspree
async function sendOrderEmail(order) {
    const fetch = (await import('node-fetch')).default; // Dynamic import for ESM compatibility

    try {
        const response = await fetch("https://formspree.io/f/xkgopopb", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
                subject: `New Order, Number: ${order.order_number}`,
                message: `
                A new order has been placed.

                Order Number : ${order.order_number}
                Client : ${order.client_name}
                Product : ${order.product}
                Quantity : ${order.quantity}
                Order Date : ${order.order_date}
                Delivery Date : ${order.delivery_date}
                Status : ${order.status}
                Remarks : ${order.remarks}
                `,
            }),
        });

        if (response.ok) {
            console.log("✅ Order email sent via Formspree!");
        } else {
            console.error("❌ Formspree Error:", await response.text());
        }
    } catch (error) {
        console.error("❌ Email Sending Failed:", error.message);
    }
}

// Get all orders
router.get('/', authRequired, requirePermissions(['orders.read']), async (req, res) => {
    try {
        const orders = await getAllOrders();
        res.json(orders);
    } catch (error) {
        res.status(500).send(error.message);
    }
});

// GET /orders/next-number
router.get('/next-number', authRequired, requirePermissions(['orders.read']), async (req, res) => {
    try {
        const prefix = req.query.prefix || 'CC.P00204';
        const info = await getNextOrderNumber(prefix);
        res.json(info);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Get orders by status
router.get('/pending', authRequired, requirePermissions(['orders.read']), async (req, res) => {
    try {
        const orders = await getOrdersByStatus(false, false);
        res.json(orders);
    } catch (error) {
        res.status(500).send(error.message);
    }
});

router.get('/validated', authRequired, requirePermissions(['orders.read']), async (req, res) => {
    try {
        const orders = await getOrdersByStatus(true, false);
        res.json(orders);
    } catch (error) {
        res.status(500).send(error.message);
    }
});

router.get('/finished', authRequired, requirePermissions(['orders.read']), async (req, res) => {
    try {
        const orders = await getOrdersByStatus(true, true);
        res.json(orders);
    } catch (error) {
        res.status(500).send(error.message);
    }
});

// Return products list (used by frontend for product dropdown)
router.get('/products', authRequired, requirePermissions(['products.read']), async (req, res) => {
    try {
        const products = await Product.getAll();
        res.json(products);
    } catch (err) {
        console.error('Error fetching products:', err);
        res.status(500).json({ error: err.message });
    }
});

// Get items for an order
router.get('/:id/items', authRequired, requirePermissions(['orders.read']), async (req, res) => {
    const { id } = req.params;
    try {
        const itemsRes = await pool.query('SELECT * FROM order_items WHERE order_id = $1', [id]);
        res.json(itemsRes.rows);
    } catch (err) {
        console.error('Error fetching order items:', err);
        res.status(500).json({ error: err.message });
    }
});

// Add new order and send email
router.post('/', authRequired, requirePermissions(['orders.create']), upload.any(), async (req, res) => {
  try {
    // Accept JSON and multipart. In multipart, items is JSON string and files are available via req.files.
    let { order_number, client_name, product, quantity, items, order_date, delivery_date, status, remarks } = req.body || {};
    if (typeof items === 'string') {
      try { items = JSON.parse(items); } catch { items = []; }
    }
    if (!items || !Array.isArray(items) || items.length === 0) {
      items = [{ product: product, quantity: quantity }];
    }

    // Parse and validate dates, default delivery_date to order_date if missing/invalid
    const localOrderDate = parseDateStrict(order_date);
    const parsedDelivery = parseDateStrict(delivery_date);
    const localDeliveryDate = parsedDelivery || localOrderDate;
    if (!localOrderDate || !localDeliveryDate) {
      return res.status(400).json({ error: 'Invalid date format for order_date or delivery_date' });
    }

    // Compute next order number if missing
     if (!order_number || String(order_number).trim() === '') {
       const nextInfo = await getNextOrderNumber();
       order_number = nextInfo.order_number;
     }

     // Insert the order into the database
     const itemsJson = JSON.stringify(items);
     const result = await pool.query(
       "INSERT INTO orders (order_number, client_name, product, quantity, order_date, delivery_date, status, remarks, items) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING *",
       [order_number, client_name, items[0].product, items.reduce((s,i)=>s+Number(i.quantity||0),0), localOrderDate, localDeliveryDate, status, remarks, itemsJson]
     );

     const newOrder = result.rows[0];

     // Insert order_items
     for (const it of items) {
       await pool.query('INSERT INTO order_items (order_id, product, quantity) VALUES ($1,$2,$3)', [newOrder.id, it.product, it.quantity]);
     }

    // If files are attached (Pièce spéciale), persist them per item index
    if (Array.isArray(req.files) && req.files.length > 0) {
      await ensureOrderItemAttachmentsTable();
      for (const f of req.files) {
        const m = f.fieldname && f.fieldname.match(/^file_(\d+)$/);
        if (!m) continue;
        const itemIndex = Number(m[1]);
        await pool.query(
          'INSERT INTO order_item_attachments (order_id, item_index, filename, mime_type, file_data) VALUES ($1,$2,$3,$4,$5)',
          [newOrder.id, itemIndex, f.originalname || null, f.mimetype || null, f.buffer || null]
        );
      }
    }

     // Generate PDF for the new order and save into DB (pdf_data bytea and filename)
     try {
       const itemsToList = Array.isArray(newOrder.items) ? newOrder.items : [];
       const { buffer, filename } = await buildOrderPdfBuffer(newOrder, itemsToList);
       await pool.query('UPDATE orders SET pdf_data = $1, pdf_filename = $2 WHERE id = $3', [buffer, filename, newOrder.id]);
       newOrder.pdf_filename = filename;
     } catch (pdfErr) {
       console.error('Failed to generate PDF for new order', pdfErr);
     }

     // Refresh order with items
     const itemsRes = await pool.query('SELECT * FROM order_items WHERE order_id = $1', [newOrder.id]);
     newOrder.items = itemsRes.rows;

     // Send the confirmation email (including items summary)
     await sendOrderEmail({ ...newOrder, items });

     res.status(201).json(newOrder);
  } catch (error) {
    console.error("Error adding order:", error.message);
    res.status(500).send(error.message);
  }
});

// Update an order (modify order metadata and items)
router.put('/:id', authRequired, requirePermissions(['orders.update']), upload.any(), async (req, res) => {
  const { id } = req.params;
  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    let { order_number, client_name, items, order_date, delivery_date, status, remarks } = req.body || {};
    if (typeof items === 'string') {
      try { items = JSON.parse(items); } catch { items = []; }
    }

    // Basic validation
    if (!Array.isArray(items) || items.length === 0) {
      return res.status(400).json({ error: 'Items array required' });
    }

    // Normalize dates if provided as strings (default dd to od)
    const od = parseDateStrict(order_date);
    const dd = parseDateStrict(delivery_date) || od;

    const totalQuantity = items.reduce((s, it) => s + Number(it.quantity || 0), 0);

    // Update orders table and items JSON column
    const itemsJson = JSON.stringify(items);
    await client.query(
      'UPDATE orders SET order_number = $1, client_name = $2, product = $3, quantity = $4, order_date = $5, delivery_date = $6, status = $7, remarks = $8, items = $9 WHERE id = $10',
      [order_number, client_name, items[0].product, totalQuantity, od, dd, status, remarks, itemsJson, id]
    );

    // Replace order_items for this order
    await client.query('DELETE FROM order_items WHERE order_id = $1', [id]);
    for (const it of items) {
      await client.query('INSERT INTO order_items (order_id, product, quantity) VALUES ($1,$2,$3)', [id, it.product, it.quantity]);
    }

    // If there are files in this update, replace attachments (simple strategy)
    if (Array.isArray(req.files) && req.files.length > 0) {
      await ensureOrderItemAttachmentsTable();
      await client.query('DELETE FROM order_item_attachments WHERE order_id = $1', [id]);
      for (const f of req.files) {
        const m = f.fieldname && f.fieldname.match(/^file_(\d+)$/);
        if (!m) continue;
        const itemIndex = Number(m[1]);
        await client.query(
          'INSERT INTO order_item_attachments (order_id, item_index, filename, mime_type, file_data) VALUES ($1,$2,$3,$4,$5)',
          [id, itemIndex, f.originalname || null, f.mimetype || null, f.buffer || null]
        );
      }
    }

    // Return updated order with items
    const itemsRes = await client.query('SELECT * FROM order_items WHERE order_id = $1', [id]);
    const orderRes = await client.query('SELECT * FROM orders WHERE id = $1', [id]);
    await client.query('COMMIT');
    const updated = orderRes.rows[0];
    const itemsRows = itemsRes.rows;

    // regenerate PDF for updated order: prefer orders.items JSON inside 'updated'
    try {
      const { buffer, filename } = await buildOrderPdfBuffer(updated, itemsRows);
      await pool.query('UPDATE orders SET pdf_data = $1, pdf_filename = $2 WHERE id = $3', [buffer, filename, id]);
    } catch (e) {
      console.error('Failed to regenerate PDF after order update', e);
    }

    // respond with rows as items (API compatibility)
    updated.items = itemsRows;
    res.json(updated);
  } catch (err) {
    await client.query('ROLLBACK');
    console.error('Error updating order:', err);
    res.status(500).json({ error: err.message });
  } finally {
    client.release();
  }
});

// Validate Order (Move to "validated" status and deduct inventory)
router.put("/:id/validate", authRequired, requirePermissions(['orders.validate']), upload.single('photo'), async (req, res) => {
    const { id } = req.params;
    // pick up optional fields for this validation step
    const { worker, machine, delivery_date } = req.body || {};
    const providedDD = parseDateStrict(delivery_date);
    const photoBuffer = req.file && req.file.buffer ? req.file.buffer : null;

    const client = await pool.connect();
    try {
        await client.query('BEGIN');

        // 1. Vérifier la commande
        const orderResult = await client.query('SELECT * FROM orders WHERE id = $1 FOR UPDATE', [id]);
        const order = orderResult.rows[0];
        if (!order) {
            await client.query('ROLLBACK');
            return res.status(404).json({ error: 'Order not found' });
        }

        // 2. Load order items (support multiple products per order)
        const oiRes = await client.query('SELECT * FROM order_items WHERE order_id = $1', [order.id]);
        const orderItems = oiRes.rows;
        if (!orderItems.length) {
            await client.query('ROLLBACK');
            return res.status(400).json({ error: 'No items found for this order' });
        }

        // 3. For each item, ensure BOM exists and inventory is sufficient
        const allBomChecks = [];
        for (const it of orderItems) {
            // Skip BOM check for "Pièce spéciale"
            if (isSpecialPieceName(it.product)) {
                allBomChecks.push({ prodRow: null, bomItems: [] });
                continue;
            }
            const prodRows = await client.query('SELECT * FROM products WHERE name = $1', [it.product]);
            const prodRow = prodRows.rows[0];
            if (!prodRow) {
                await client.query('ROLLBACK');
                return res.status(404).json({ error: `Product not found in catalog: ${it.product}` });
            }
            const bomRes = await client.query('SELECT * FROM product_bom WHERE product_id = $1', [prodRow.id]);
            const bomItems = bomRes.rows;
            if (!bomItems.length) {
                await client.query('ROLLBACK');
                return res.status(400).json({ error: `No BOM defined for product ${it.product}` });
            }

            // check availability for this item's BOM
            for (const bom of bomItems) {
                const totalNeeded = Number(bom.quantity) * Number(it.quantity);
                const invRes = await client.query('SELECT * FROM inventory WHERE id = $1 FOR UPDATE', [bom.inventory_item_id]);
                const inv = invRes.rows[0];
                if (!inv) {
                    await client.query('ROLLBACK');
                    return res.status(404).json({ error: 'Inventory item not found' });
                }
                const invTotal = Number(inv.total_quantity) || 0;
                if (invTotal < totalNeeded) {
                    await client.query('ROLLBACK');
                    return res.status(400).json({ error: `Stock insuffisant pour ${inv.name}` });
                }
            }
            allBomChecks.push({ prodRow, bomItems });
        }

        // 4. Deduct inventory for each item's BOM
        for (let idx = 0; idx < orderItems.length; idx++) {
            const it = orderItems[idx];
            if (isSpecialPieceName(it.product)) {
                continue; // no stock deduction
            }
            const bomItems = allBomChecks[idx].bomItems;
            for (const bom of bomItems) {
                const totalNeeded = Number(bom.quantity) * Number(it.quantity);
                const invRes2 = await client.query('SELECT * FROM inventory WHERE id = $1 FOR UPDATE', [bom.inventory_item_id]);
                const inv2 = invRes2.rows[0];
                const newTotal = Number(inv2.total_quantity) - totalNeeded;
                await client.query('UPDATE inventory SET total_quantity = $1 WHERE id = $2', [newTotal, bom.inventory_item_id]);
                await client.query(
                    'INSERT INTO stock_movements (inventory_id, segment_id, order_id, movement_type, quantity, unit, reason) VALUES ($1,$2,$3,$4,$5,$6,$7)',
                    [bom.inventory_item_id, null, order.id, 'out', totalNeeded, bom.unit, `Commande #${order.order_number} validation/production`]
                );
            }
        }

        // 5. Validate the order and optionally update delivery_date
        const validatedDate = new Date();
        const setParts = ['validated = true', 'validated_date = $1'];
        const params = [validatedDate];
        if (providedDD) {
            setParts.push(`delivery_date = $${params.length + 1}`);
            params.push(providedDD);
        }
        const sql = `UPDATE orders SET ${setParts.join(', ')} WHERE id = $${params.length + 1} RETURNING *`;
        params.push(id);
        const updateRes = await client.query(sql, params);

        await client.query('COMMIT');

        let updatedOrder = updateRes.rows[0];

        // Try to update optional fields (worker, machine, report_photo) AFTER commit; ignore if columns don't exist
        try {
            const extParts = [];
            const extParams = [];
            let i = 1;
            if (worker !== undefined) { extParts.push(`worker = $${i++}`); extParams.push(worker); }
            if (machine !== undefined) { extParts.push(`machine = $${i++}`); extParams.push(machine); }
            if (photoBuffer) { extParts.push(`report_photo = $${i++}`); extParams.push(photoBuffer); }
            if (extParts.length) {
                const extSql = `UPDATE orders SET ${extParts.join(', ')} WHERE id = $${i} RETURNING *`;
                extParams.push(id);
                const extRes = await pool.query(extSql, extParams);
                updatedOrder = extRes.rows[0] || updatedOrder;
            }
        } catch (optErr) {
            console.warn('validate: optional fields update skipped (columns may not exist):', optErr.message);
        }

        // Regenerate PDF to reflect any new delivery date (errors here do not block success)
        try {
            const itemsRes = await pool.query('SELECT * FROM order_items WHERE order_id = $1', [id]);
            const { buffer, filename } = await buildOrderPdfBuffer(updatedOrder, itemsRes.rows || []);
            await pool.query('UPDATE orders SET pdf_data = $1, pdf_filename = $2 WHERE id = $3', [buffer, filename, id]);
            updatedOrder.pdf_filename = filename;
        } catch (pdfErr) {
            console.error('Failed to regenerate PDF after validation:', pdfErr);
        }

        res.json(updatedOrder);
    } catch (err) {
        await client.query('ROLLBACK');
        console.error('Error in validating order (transaction):', err);
        res.status(500).json({ error: err.message });
    } finally {
        client.release();
    }
});

// Finish order
router.put('/:id/finish', authRequired, requirePermissions(['orders.finish']), async (req, res) => {
    try {
        const { id } = req.params;
        const finishedDate = new Date(); // Get current date for finished date

        const result = await pool.query(
            "UPDATE orders SET finished = true, finished_date = $1 WHERE id = $2 RETURNING *",
            [finishedDate, id]
        );

        res.json(result.rows[0]); // Send the updated order back
    } catch (error) {
        console.error("Error adding order:", error.response?.data || error.message);
        res.status(500).json({ error: error.message });
    }
});

// Finish with report: optional photo; accept optional used_quantity to adjust tube usage
router.post('/:id/finish-report', authRequired, requirePermissions(['orders.finish']), upload.single('photo'), async (req, res) => {
    const { id } = req.params;
    const photo = req.file && req.file.buffer ? req.file.buffer : null;
    // NEW: allow worker, machine, finish_remarks updates at finish stage
    const { worker, machine, finish_remarks } = req.body || {};

    const client = await pool.connect();
    try {
        await client.query('BEGIN');

        // Load order for order_number (used in movement reason)
        const orderRes = await client.query('SELECT id, order_number FROM orders WHERE id = $1 FOR UPDATE', [id]);
        const order = orderRes.rows[0];
        if (!order) {
            await client.query('ROLLBACK');
            return res.status(404).json({ error: 'Order not found' });
        }

        // Compute current tube usage for this order (sum of 'out' movements on tube inventory)
        const usageSql = `
            SELECT sm.inventory_id,
                   i.name,
                   COALESCE(i.unit, sm.unit) AS unit,
                   SUM(sm.quantity) AS qty
            FROM stock_movements sm
            JOIN inventory i ON i.id = sm.inventory_id
            WHERE sm.order_id = $1
              AND sm.movement_type = 'out'
              AND LOWER(i.name) LIKE '%tube%'
            GROUP BY sm.inventory_id, i.name, COALESCE(i.unit, sm.unit)
            ORDER BY i.name
        `;
        const usageRes = await client.query(usageSql, [id]);
        const usageRows = usageRes.rows || [];
        const originalUsed = usageRows.reduce((s, r) => s + Number(r.qty || 0), 0);

        // Optional: user-entered used quantity
        const usedEnteredRaw = req.body && req.body.used_quantity !== undefined ? String(req.body.used_quantity) : null;
        const usedEntered = usedEnteredRaw !== null && usedEnteredRaw !== '' ? Number(usedEnteredRaw) : null;

        // Optional: detailed per-inventory overrides sent as JSON string (multipart field)
        // expects an array of { inventory_id: number, used_entered: number }
        let usedDetails = null;
        if (req.body && req.body.used_details) {
            try {
                usedDetails = JSON.parse(req.body.used_details);
                if (!Array.isArray(usedDetails)) usedDetails = null;
            } catch {
                usedDetails = null;
            }
        }

        // If detailed overrides provided, adjust each item independently
        if (Array.isArray(usedDetails) && usedDetails.length > 0) {
            for (const d of usedDetails) {
                const invId = Number(d.inventory_id);
                const row = usageRows.find(r => Number(r.inventory_id) === invId);
                // Only adjust existing tube usages for this order
                if (!row) continue;
                const originalForItem = Number(row.qty || 0);
                const enteredForItem = Number(d.used_entered);
                if (Number.isNaN(enteredForItem)) continue;
                const diffItem = enteredForItem - originalForItem;
                if (diffItem === 0) continue;

                const invRes = await client.query('SELECT id, total_quantity, name FROM inventory WHERE id = $1 FOR UPDATE', [invId]);
                const inv = invRes.rows[0];
                if (!inv) {
                    await client.query('ROLLBACK');
                    return res.status(404).json({ error: `Inventory item not found for adjustment (id=${invId})` });
                }

                const movementType = diffItem > 0 ? 'out' : 'in';
                const newTotal = Number(inv.total_quantity) + (diffItem > 0 ? -diffItem : Math.abs(diffItem));
                await client.query('UPDATE inventory SET total_quantity = $1 WHERE id = $2', [newTotal, inv.id]);
                await client.query(
                    'INSERT INTO stock_movements (inventory_id, segment_id, order_id, movement_type, quantity, unit, reason) VALUES ($1,$2,$3,$4,$5,$6,$7)',
                    [inv.id, null, order.id, movementType, Math.abs(diffItem), row.unit || null, `Ajustement fin de commande #${order.order_number}`]
                );
            }
        } else {
            // Legacy: If a single used quantity is provided, adjust proportionally across all tube usages
            const usedEnteredRaw = req.body && req.body.used_quantity !== undefined ? String(req.body.used_quantity) : null;
            const usedEntered = usedEnteredRaw !== null && usedEnteredRaw !== '' ? Number(usedEnteredRaw) : null;

            if (usedEntered !== null && !Number.isNaN(usedEntered)) {
                const diff = usedEntered - originalUsed; // positive => deduct more; negative => add back
                if (Math.abs(diff) > 0) {
                    if (originalUsed <= 0 && usageRows.length === 0) {
                        await client.query('ROLLBACK');
                        return res.status(400).json({ error: 'No existing tube usage to adjust for this order' });
                    }

                    const parts = usageRows.map(r => ({
                        inventory_id: r.inventory_id,
                        unit: r.unit,
                        proportion: originalUsed > 0 ? (Number(r.qty || 0) / originalUsed) : 0
                    }));

                    let remaining = diff;
                    for (let i = 0; i < parts.length; i++) {
                        const isLast = i === parts.length - 1;
                        const amount = isLast ? remaining : (diff * parts[i].proportion);

                        const invRes = await client.query('SELECT id, total_quantity, name FROM inventory WHERE id = $1 FOR UPDATE', [parts[i].inventory_id]);
                        const inv = invRes.rows[0];
                        if (!inv) {
                            await client.query('ROLLBACK');
                            return res.status(404).json({ error: `Inventory item not found for adjustment (id=${parts[i].inventory_id})` });
                        }

                        const qtyAdj = Number(amount);
                        if (qtyAdj !== 0) {
                            const movementType = qtyAdj > 0 ? 'out' : 'in';
                            const newTotal = Number(inv.total_quantity) + (qtyAdj > 0 ? -qtyAdj : Math.abs(qtyAdj));
                            await client.query('UPDATE inventory SET total_quantity = $1 WHERE id = $2', [newTotal, inv.id]);
                            await client.query(
                                'INSERT INTO stock_movements (inventory_id, segment_id, order_id, movement_type, quantity, unit, reason) VALUES ($1,$2,$3,$4,$5,$6,$7)',
                                [
                                    inv.id,
                                    null,
                                    order.id,
                                    movementType,
                                    Math.abs(qtyAdj),
                                    parts[i].unit || null,
                                    `Ajustement fin de commande #${order.order_number}`
                                ]
                            );
                        }

                        remaining -= amount;
                    }
                }
            }
        }

        // Mark as finished and store optional photo (do NOT touch worker/machine here directly)
        const setCols = ['finished = true', 'finished_date = $1'];
        const params = [new Date()];
        if (photo) { setCols.push(`report_photo = $${params.length + 1}`); params.push(photo); }
        const updSql = `UPDATE orders SET ${setCols.join(', ')} WHERE id = $${params.length + 1} RETURNING *`;
        params.push(id);
        const upd = await client.query(updSql, params);

        await client.query('COMMIT');

        // NEW: second (non-transactional) attempt to update worker/machine/finish_remarks (ignore if columns absent)
        if (worker !== undefined || machine !== undefined || finish_remarks !== undefined) {
            try {
                const metaParts = [];
                const metaParams = [];
                let i = 1;
                if (worker !== undefined) { metaParts.push(`worker = $${i++}`); metaParams.push(worker); }
                if (machine !== undefined) { metaParts.push(`machine = $${i++}`); metaParams.push(machine); }
                if (finish_remarks !== undefined) { metaParts.push(`finish_remarks = $${i++}`); metaParams.push(finish_remarks); }
                if (metaParts.length) {
                    metaParams.push(id);
                    await pool.query(`UPDATE orders SET ${metaParts.join(', ')} WHERE id = $${i}`, metaParams);
                }
            } catch (metaErr) {
                console.warn('finish-report: optional metadata update skipped:', metaErr.message);
            }
        }

        // Return usage details to UI
        return res.json({
            order: upd.rows[0],
            usage: {
                used_original: originalUsed,
                used_entered: usedEntered,
                used_diff: (usedEntered !== null && !Number.isNaN(usedEntered)) ? (usedEntered - originalUsed) : 0
            }
        });
    } catch (err) {
        await client.query('ROLLBACK');
        console.error('Error in finish-report:', err);
        return res.status(500).json({ error: 'Failed to finish order with report' });
    } finally {
        client.release();
    }
});

// Delete an order (and its stock movements)
router.delete('/:id', authRequired, requirePermissions(['orders.delete']), async (req, res) => {
    const { id } = req.params;
    const client = await pool.connect();
    try {
        await client.query('BEGIN');
        await client.query('DELETE FROM stock_movements WHERE order_id = $1', [id]);
        const delRes = await client.query('DELETE FROM orders WHERE id = $1 RETURNING *', [id]);
        if (delRes.rowCount === 0) {
            await client.query('ROLLBACK');
            return res.status(404).json({ error: 'Order not found' });
        }
        await client.query('COMMIT');
        res.json({ message: 'Order deleted', order: delRes.rows[0] });
    } catch (err) {
        await client.query('ROLLBACK');
        console.error('Error deleting order:', err);
        res.status(500).json({ error: err.message });
    } finally {
        client.release();
    }
});

// Generate and save PDF for an order
router.post('/:id/generate-pdf', authRequired, requirePermissions(['orders.download']), async (req, res) => {
    const { id } = req.params;
    try {
        const orderResult = await pool.query('SELECT * FROM orders WHERE id = $1', [id]);
        const order = orderResult.rows[0];
        if (!order) return res.status(404).json({ error: 'Order not found' });

        const itemsResult = await pool.query('SELECT * FROM order_items WHERE order_id = $1', [id]);
        const items = itemsResult.rows;

        const { buffer, filename } = await buildOrderPdfBuffer(order, items);
        await pool.query('UPDATE orders SET pdf_data = $1, pdf_filename = $2 WHERE id = $3', [buffer, filename, id]);
        res.json({ message: 'PDF generated and saved to DB.', filename });
    } catch (e) {
        console.error('Error generating PDF:', e);
        res.status(500).json({ error: 'Failed to generate PDF.' });
    }
});

// Download PDF
router.get('/:id/download-pdf', authRequired, requirePermissions(['orders.download']), async (req, res) => {
    const { id } = req.params;
    try {
        const result = await pool.query('SELECT pdf_data, pdf_filename, order_number FROM orders WHERE id = $1', [id]);
        const row = result.rows[0];
        if (!row) return res.status(404).json({ error: 'Order not found.' });
        if (!row.pdf_data) return res.status(404).json({ error: 'PDF not found for this order.' });

        res.setHeader('Access-Control-Expose-Headers', 'Content-Disposition, X-Filename');
        res.setHeader('Content-Type', 'application/pdf');
        const filename = row.pdf_filename || `BC_${row.order_number || id}.pdf`;
        const encoded = encodeURIComponent(filename);
        res.setHeader('Content-Disposition', `attachment; filename="${filename}"; filename*=UTF-8''${encoded}`);
        res.setHeader('X-Filename', filename);
        return res.send(row.pdf_data);
    } catch (err) {
        console.error('Error downloading PDF:', err);
        res.status(500).json({ error: 'Failed to download PDF.' });
    }
});

// Usage summary for an order: aggregates stock movements (out) and totals "tube" usage
router.get('/:id/usage', authRequired, requirePermissions(['orders.read']), async (req, res) => {
    const { id } = req.params;
    try {
        const sql = `
            SELECT
              sm.inventory_id,
              i.name,
              COALESCE(i.unit, sm.unit) AS unit,
              SUM(sm.quantity) AS quantity
            FROM stock_movements sm
            JOIN inventory i ON i.id = sm.inventory_id
            WHERE sm.order_id = $1 AND sm.movement_type = 'out'
            GROUP BY sm.inventory_id, i.name, COALESCE(i.unit, sm.unit)
            ORDER BY i.name
        `;
        const { rows } = await pool.query(sql, [id]);
        const tubeTotal = rows
          .filter(r => (r.name || '').toLowerCase().includes('tube'))
          .reduce((s, r) => s + Number(r.quantity || 0), 0);
        res.json({ by_inventory: rows, tube_total: tubeTotal });
    } catch (err) {
        console.error('Error fetching order usage:', err);
        res.status(500).json({ error: err.message });
    }
});

module.exports = router;