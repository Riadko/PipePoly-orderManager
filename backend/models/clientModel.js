const pool = require('../config/db');

const Client = {
  async getAll() {
    const { rows } = await pool.query('SELECT * FROM clients ORDER BY id DESC');
    return rows;
  },
  async getById(id) {
    const { rows } = await pool.query('SELECT * FROM clients WHERE id = $1', [id]);
    return rows[0];
  },
  async create(data) {
    const { email, phone, phone2, address, city, postal_code, country, company, vat_number, notes } = data;
    const { rows } = await pool.query(
      `INSERT INTO clients (email, phone, phone2, address, city, postal_code, country, company, vat_number, notes)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10) RETURNING *`,
      [email, phone, phone2, address, city, postal_code, country, company, vat_number, notes]
    );
    return rows[0];
  },
  async update(id, data) {
    const { email, phone, phone2, address, city, postal_code, country, company, vat_number, notes } = data;
    const { rows } = await pool.query(
      `UPDATE clients SET email=$1, phone=$2, phone2=$3, address=$4, city=$5, postal_code=$6, country=$7, company=$8, vat_number=$9, notes=$10, updated_at=NOW() WHERE id=$11 RETURNING *`,
      [email, phone, phone2, address, city, postal_code, country, company, vat_number, notes, id]
    );
    return rows[0];
  },
  async delete(id) {
    await pool.query('DELETE FROM clients WHERE id = $1', [id]);
    return true;
  }
};

module.exports = Client;
