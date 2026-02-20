-- Sample Data for ERP Ledger Posting Simulation
-- Demonstrates P2P, L2C, and GR/IR scenarios

------------------------------------------------------------
-- 1. Cost Centers
------------------------------------------------------------

INSERT INTO cost_center_dimension (cost_center_id, cost_center_name, valid_from, valid_to)
VALUES 
('CC100', 'IT Operations', '2024-01-01', '2026-12-31'),
('CC200', 'Finance Operations', '2024-01-01', '2026-12-31');

------------------------------------------------------------
-- 2. Profit Centers
------------------------------------------------------------

INSERT INTO profit_center_dimension (profit_center_id, profit_center_name, segment)
VALUES
('PC100', 'Digital Services', 'Segment A'),
('PC200', 'Advisory Services', 'Segment B');

------------------------------------------------------------
-- 3. Vendor Invoice (P2P Example)
-- Net 1,000 | VAT 190 | Gross 1,190
------------------------------------------------------------

-- GL Entries
INSERT INTO gl_entries 
(doc_id, line_no, posting_date, company_code, account, account_type, dc_indicator, amount, cost_center_id, process, doc_type, description)
VALUES
('DOC_P2P_001', 1, '2025-02-20', '1000', '400000', 'EXP', 'D', 1000.00, 'CC100', 'P2P', 'KR', 'Consulting Expense'),
('DOC_P2P_001', 2, '2025-02-20', '1000', '157000', 'ASSET', 'D', 190.00, NULL, 'P2P', 'KR', 'Input VAT'),
('DOC_P2P_001', 3, '2025-02-20', '1000', '300000', 'LIAB', 'C', 1190.00, NULL, 'P2P', 'KR', 'Vendor Payable');

-- Vendor Subledger
INSERT INTO vendor_subledger
(vendor_id, doc_id, posting_date, due_date, amount_gross)
VALUES
('VEND100', 'DOC_P2P_001', '2025-02-20', '2025-03-20', 1190.00);

------------------------------------------------------------
-- 4. Customer Invoice (L2C Example)
-- Net 2,000 | VAT 380 | Gross 2,380
------------------------------------------------------------

-- GL Entries
INSERT INTO gl_entries 
(doc_id, line_no, posting_date, company_code, account, account_type, dc_indicator, amount, profit_center_id, process, doc_type, description)
VALUES
('DOC_L2C_001', 1, '2025-02-20', '1000', '110000', 'ASSET', 'D', 2380.00, NULL, 'L2C', 'DR', 'Customer Receivable'),
('DOC_L2C_001', 2, '2025-02-20', '1000', '800000', 'REV', 'C', 2000.00, 'PC100', 'L2C', 'DR', 'Consulting Revenue'),
('DOC_L2C_001', 3, '2025-02-20', '1000', '177000', 'LIAB', 'C', 380.00, NULL, 'L2C', 'DR', 'Output VAT');

-- Customer Subledger
INSERT INTO customer_subledger
(customer_id, doc_id, posting_date, due_date, amount_gross)
VALUES
('CUST200', 'DOC_L2C_001', '2025-02-20', '2025-03-20', 2380.00);

------------------------------------------------------------
-- 5. GR/IR Example (P2P Integration)
------------------------------------------------------------

-- Goods Receipt
INSERT INTO gl_entries 
(doc_id, line_no, posting_date, company_code, account, account_type, dc_indicator, amount, process, doc_type, description)
VALUES
('DOC_GRIR_001', 1, '2025-02-20', '1000', '140000', 'ASSET', 'D', 1000.00, 'P2P', 'WE', 'Inventory Receipt'),
('DOC_GRIR_001', 2, '2025-02-20', '1000', '200000', 'CLEAR', 'C', 1000.00, 'P2P', 'WE', 'GR/IR Clearing');

-- Invoice Receipt
INSERT INTO gl_entries 
(doc_id, line_no, posting_date, company_code, account, account_type, dc_indicator, amount, process, doc_type, description)
VALUES
('DOC_GRIR_002', 1, '2025-02-20', '1000', '200000', 'CLEAR', 'D', 1000.00, 'P2P', 'RE', 'GR/IR Clearing'),
('DOC_GRIR_002', 2, '2025-02-20', '1000', '300000', 'LIAB', 'C', 1000.00, 'P2P', 'RE', 'Vendor Payable');
