-- ERP Ledger Posting Simulation
-- Minimal schema to model GL postings, subledgers, cost objects, and GR/IR behavior.

-- Drop order (safe reruns)
DROP TABLE IF EXISTS gl_entries;
DROP TABLE IF EXISTS vendor_subledger;
DROP TABLE IF EXISTS customer_subledger;
DROP TABLE IF EXISTS cost_center_dimension;
DROP TABLE IF EXISTS profit_center_dimension;

-- Cost center reference (cost object)
CREATE TABLE cost_center_dimension (
  cost_center_id     VARCHAR(20) PRIMARY KEY,
  cost_center_name   VARCHAR(100) NOT NULL,
  valid_from         DATE NOT NULL,
  valid_to           DATE NOT NULL
);

-- Profit center reference (cost object)
CREATE TABLE profit_center_dimension (
  profit_center_id   VARCHAR(20) PRIMARY KEY,
  profit_center_name VARCHAR(100) NOT NULL,
  segment            VARCHAR(50)
);

-- General Ledger line items (simplified Universal Journal style)
CREATE TABLE gl_entries (
  entry_id           BIGSERIAL PRIMARY KEY,
  doc_id             VARCHAR(30) NOT NULL,
  line_no            INT NOT NULL,
  posting_date       DATE NOT NULL,
  company_code       VARCHAR(10) NOT NULL,

  ledger             VARCHAR(10) NOT NULL DEFAULT '0L',  -- leading ledger
  account            VARCHAR(20) NOT NULL,               -- GL account
  account_type       VARCHAR(10) NOT NULL,               -- ASSET/LIAB/REV/EXP/CLEAR

  dc_indicator       CHAR(1) NOT NULL CHECK (dc_indicator IN ('D','C')),
  amount             NUMERIC(18,2) NOT NULL CHECK (amount >= 0),

  currency           VARCHAR(5) NOT NULL DEFAULT 'EUR',

  -- Cost objects / dimensions (optional, typically on P&L lines)
  cost_center_id     VARCHAR(20),
  profit_center_id   VARCHAR(20),

  -- Process context
  process            VARCHAR(10) NOT NULL,               -- P2P / L2C / R2R
  doc_type           VARCHAR(10) NOT NULL,               -- KR (vendor), DR (customer), etc.
  description        VARCHAR(255),

  CONSTRAINT uq_doc_line UNIQUE (doc_id, line_no),
  CONSTRAINT fk_cc FOREIGN KEY (cost_center_id) REFERENCES cost_center_dimension(cost_center_id),
  CONSTRAINT fk_pc FOREIGN KEY (profit_center_id) REFERENCES profit_center_dimension(profit_center_id)
);

-- Vendor subledger (Accounts Payable open items)
CREATE TABLE vendor_subledger (
  ap_item_id         BIGSERIAL PRIMARY KEY,
  vendor_id          VARCHAR(30) NOT NULL,
  doc_id             VARCHAR(30) NOT NULL,
  posting_date       DATE NOT NULL,
  due_date           DATE,
  amount_gross       NUMERIC(18,2) NOT NULL CHECK (amount_gross >= 0),
  currency           VARCHAR(5) NOT NULL DEFAULT 'EUR',
  status             VARCHAR(10) NOT NULL DEFAULT 'OPEN'  -- OPEN/CLEARED
);

-- Customer subledger (Accounts Receivable open items)
CREATE TABLE customer_subledger (
  ar_item_id         BIGSERIAL PRIMARY KEY,
  customer_id        VARCHAR(30) NOT NULL,
  doc_id             VARCHAR(30) NOT NULL,
  posting_date       DATE NOT NULL,
  due_date           DATE,
  amount_gross       NUMERIC(18,2) NOT NULL CHECK (amount_gross >= 0),
  currency           VARCHAR(5) NOT NULL DEFAULT 'EUR',
  status             VARCHAR(10) NOT NULL DEFAULT 'OPEN'  -- OPEN/CLEARED
);
