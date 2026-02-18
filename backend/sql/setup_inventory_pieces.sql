-- Insert inventory items for each piece/dimension with provided quantities.
-- Each line is a separate inventory row: name = "<Piece> D <dimension>", total_quantity = provided Q, unit = 'mm' or 'm' depending on your tracking.

BEGIN;

-- We'll store unit as 'mm' since you gave quantities per piece consumed

-- Y
INSERT INTO inventory (name, description, total_quantity, unit) VALUES ('Y D63', 'Y piece diameter 63', 833, 'mm');
INSERT INTO inventory (name, description, total_quantity, unit) VALUES ('Y D75', 'Y piece diameter 75', 836, 'mm');
INSERT INTO inventory (name, description, total_quantity, unit) VALUES ('Y D90', 'Y piece diameter 90', 839, 'mm');
INSERT INTO inventory (name, description, total_quantity, unit) VALUES ('Y D110', 'Y piece diameter 110', 943, 'mm');
INSERT INTO inventory (name, description, total_quantity, unit) VALUES ('Y D125', 'Y piece diameter 125', 966, 'mm');

-- Coude 11.25
INSERT INTO inventory (name, description, total_quantity, unit) VALUES ('Coude 11.25 D63', 'Coude 11.25 diameter 63', 206, 'mm');
INSERT INTO inventory (name, description, total_quantity, unit) VALUES ('Coude 11.25 D75', 'Coude 11.25 diameter 75', 208, 'mm');
INSERT INTO inventory (name, description, total_quantity, unit) VALUES ('Coude 11.25 D90', 'Coude 11.25 diameter 90', 249, 'mm');
INSERT INTO inventory (name, description, total_quantity, unit) VALUES ('Coude 11.25 D110', 'Coude 11.25 diameter 110', 251, 'mm');
INSERT INTO inventory (name, description, total_quantity, unit) VALUES ('Coude 11.25 D125', 'Coude 11.25 diameter 125', 293, 'mm');

-- Coude 22.5
INSERT INTO inventory (name, description, total_quantity, unit) VALUES ('Coude 22.5 D63', 'Coude 22.5 diameter 63', 213, 'mm');
INSERT INTO inventory (name, description, total_quantity, unit) VALUES ('Coude 22.5 D75', 'Coude 22.5 diameter 75', 215, 'mm');
INSERT INTO inventory (name, description, total_quantity, unit) VALUES ('Coude 22.5 D90', 'Coude 22.5 diameter 90', 258, 'mm');
INSERT INTO inventory (name, description, total_quantity, unit) VALUES ('Coude 22.5 D110', 'Coude 22.5 diameter 110', 262, 'mm');
INSERT INTO inventory (name, description, total_quantity, unit) VALUES ('Coude 22.5 D125', 'Coude 22.5 diameter 125', 305, 'mm');

-- Coude 45
INSERT INTO inventory (name, description, total_quantity, unit) VALUES ('Coude 45 D63', 'Coude 45 diameter 63', 305, 'mm');
INSERT INTO inventory (name, description, total_quantity, unit) VALUES ('Coude 45 D75', 'Coude 45 diameter 75', 310, 'mm');
INSERT INTO inventory (name, description, total_quantity, unit) VALUES ('Coude 45 D90', 'Coude 45 diameter 90', 376, 'mm');
INSERT INTO inventory (name, description, total_quantity, unit) VALUES ('Coude 45 D110', 'Coude 45 diameter 110', 384, 'mm');
INSERT INTO inventory (name, description, total_quantity, unit) VALUES ('Coude 45 D125', 'Coude 45 diameter 125', 430, 'mm');

-- Coude 90
INSERT INTO inventory (name, description, total_quantity, unit) VALUES ('Coude 90 D63', 'Coude 90 diameter 63', 411, 'mm');
INSERT INTO inventory (name, description, total_quantity, unit) VALUES ('Coude 90 D75', 'Coude 90 diameter 75', 420, 'mm');
INSERT INTO inventory (name, description, total_quantity, unit) VALUES ('Coude 90 D90', 'Coude 90 diameter 90', 512, 'mm');
INSERT INTO inventory (name, description, total_quantity, unit) VALUES ('Coude 90 D110', 'Coude 90 diameter 110', 528, 'mm');
INSERT INTO inventory (name, description, total_quantity, unit) VALUES ('Coude 90 D125', 'Coude 90 diameter 125', 580, 'mm');

-- Te egal
INSERT INTO inventory (name, description, total_quantity, unit) VALUES ('Te egal D63', 'Te egal diameter 63', 395, 'mm');
INSERT INTO inventory (name, description, total_quantity, unit) VALUES ('Te egal D75', 'Te egal diameter 75', 413, 'mm');
INSERT INTO inventory (name, description, total_quantity, unit) VALUES ('Te egal D90', 'Te egal diameter 90', 465, 'mm');
INSERT INTO inventory (name, description, total_quantity, unit) VALUES ('Te egal D110', 'Te egal diameter 110', 585, 'mm');
INSERT INTO inventory (name, description, total_quantity, unit) VALUES ('Te egal D125', 'Te egal diameter 125', 638, 'mm');

-- Croix
INSERT INTO inventory (name, description, total_quantity, unit) VALUES ('Croix D63', 'Croix diameter 63', 526, 'mm');
INSERT INTO inventory (name, description, total_quantity, unit) VALUES ('Croix D75', 'Croix diameter 75', 550, 'mm');
INSERT INTO inventory (name, description, total_quantity, unit) VALUES ('Croix D90', 'Croix diameter 90', 620, 'mm');
INSERT INTO inventory (name, description, total_quantity, unit) VALUES ('Croix D110', 'Croix diameter 110', 780, 'mm');
INSERT INTO inventory (name, description, total_quantity, unit) VALUES ('Croix D125', 'Croix diameter 125', 850, 'mm');

COMMIT;
