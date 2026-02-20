-- Validation Queries for ERP Ledger Posting Simulation
-- These queries represent typical control checks used in UAT, close, and reconciliation.

------------------------------------------------------------
-- 1) Check: Unbalanced documents (debit != credit)
------------------------------------------------------------
SELECT
  doc_id,
  SUM(CASE WHEN dc_indicator = 'D' THEN amount ELSE 0 END) AS total_debits,
  SUM(CASE WHEN dc_indicator = 'C' THEN amount ELSE 0 END) AS total_credits,
  SUM(CASE WHEN dc_indicator = 'D' THEN amount ELSE -amount END) AS net_balance
FROM gl_entries
GROUP BY doc_id
HAVING SUM(CASE WHEN dc_indicator = 'D' THEN amount ELSE -amount END) <> 0
ORDER BY doc_id;

------------------------------------------------------------
-- 2) Check: Missing cost center on expense lines
-- (Typical rule: P&L expense lines require cost center)
------------------------------------------------------------
SELECT
  doc_id,
  line_no,
  account,
  amount,
  description
FROM gl_entries
WHERE account_type = 'EXP'
  AND (cost_center_id IS NULL OR cost_center_id = '')
ORDER BY doc_id, line_no;

------------------------------------------------------------
-- 3) Check: Missing profit center on revenue lines
-- (Typical rule: Revenue lines should carry profit center)
------------------------------------------------------------
SELECT
  doc_id,
  line_no,
  account,
  amount,
  description
FROM gl_entries
WHERE account_type = 'REV'
  AND (profit_center_id IS NULL OR profit_center_id = '')
ORDER BY doc_id, line_no;

------------------------------------------------------------
-- 4) Check: Subledger vs GL reconciliation (AP)
-- Compare Vendor Subledger open items vs AP control account in GL
-- (Simplified: AP control account = 300000, credits increase AP)
------------------------------------------------------------
WITH ap_gl AS (
  SELECT
    SUM(CASE WHEN dc_indicator = 'C' THEN amount ELSE -amount END) AS ap_gl_balance
  FROM gl_entries
  WHERE account = '300000'
),
ap_sl AS (
  SELECT
    SUM(amount_gross) AS ap_subledger_open
  FROM vendor_subledger
  WHERE status = 'OPEN'
)
SELECT
  ap_gl.ap_gl_balance,
  ap_sl.ap_subledger_open,
  (ap_gl.ap_gl_balance - ap_sl.ap_subledger_open) AS difference
FROM ap_gl, ap_sl;

------------------------------------------------------------
-- 5) Check: Subledger vs GL reconciliation (AR)
-- AR control account in GL = 110000 (debits increase AR)
------------------------------------------------------------
WITH ar_gl AS (
  SELECT
    SUM(CASE WHEN dc_indicator = 'D' THEN amount ELSE -amount END) AS ar_gl_balance
  FROM gl_entries
  WHERE account = '110000'
),
ar_sl AS (
  SELECT
    SUM(amount_gross) AS ar_subledger_open
  FROM customer_subledger
  WHERE status = 'OPEN'
)
SELECT
  ar_gl.ar_gl_balance,
  ar_sl.ar_subledger_open,
  (ar_gl.ar_gl_balance - ar_sl.ar_subledger_open) AS difference
FROM ar_gl, ar_sl;

------------------------------------------------------------
-- 6) Check: GR/IR residual balance
-- GR/IR clearing account = 200000
-- Residual != 0 indicates mismatch between GR and IR
------------------------------------------------------------
SELECT
  account AS grir_account,
  SUM(CASE WHEN dc_indicator = 'D' THEN amount ELSE -amount END) AS grir_net_balance
FROM gl_entries
WHERE account = '200000'
GROUP BY account
HAVING SUM(CASE WHEN dc_indicator = 'D' THEN amount ELSE -amount END) <> 0;

------------------------------------------------------------
-- 7) Control-style summary: Document-level validations in one view
------------------------------------------------------------
SELECT
  doc_id,
  MIN(posting_date) AS posting_date,
  MIN(company_code) AS company_code,
  SUM(CASE WHEN dc_indicator = 'D' THEN amount ELSE 0 END) AS debits,
  SUM(CASE WHEN dc_indicator = 'C' THEN amount ELSE 0 END) AS credits,
  SUM(CASE WHEN dc_indicator = 'D' THEN amount ELSE -amount END) AS net_balance,
  COUNT(*) AS line_count
FROM gl_entries
GROUP BY doc_id
ORDER BY posting_date, doc_id;

------------------------------------------------------------
-- 8) Optional: Find suspicious postings (very large single lines)
-- Helps demonstrate monitoring mindset
------------------------------------------------------------
SELECT
  doc_id,
  line_no,
  account,
  account_type,
  dc_indicator,
  amount,
  description
FROM gl_entries
WHERE amount >= 5000
ORDER BY amount DESC;
