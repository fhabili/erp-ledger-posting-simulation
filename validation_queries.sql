/*
CONTROL PACK INDEX

C1  Document balance integrity (double-entry)
C2  Missing cost center on expense lines
C3  Missing profit center on revenue lines
C4  Duplicate detection (doc/line uniqueness)
C5  Subledger vs GL reconciliation (AP)
C6  Subledger vs GL reconciliation (AR)
C7  GR/IR residual balance
C8  Sanity summary (document-level view)
EXTRA  Outlier monitoring (large single lines)
*/

-- Validation Queries for ERP Ledger Posting Simulation
-- These queries represent typical control checks used in UAT, close, and reconciliation.

------------------------------------------------------------
-- C1: Document balance integrity
-- Expected result: 0 rows (all documents net to 0)
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
-- C2: Missing cost center on expense lines
-- Expected result: 0 rows (all EXP lines have a cost center)
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
-- C3: Missing profit center on revenue lines
-- Expected result: 0 rows (all REV lines have a profit center)
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
-- C4: Duplicate detection (doc/line uniqueness)
-- Expected result: 0 rows (no duplicate doc_id + line_no)
------------------------------------------------------------
SELECT doc_id, line_no, COUNT(*) AS occurrence_count
FROM gl_entries
GROUP BY doc_id, line_no
HAVING COUNT(*) > 1
ORDER BY doc_id, line_no;

------------------------------------------------------------
-- C5: Subledger vs GL reconciliation (AP)
-- Expected result: difference = 0
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
-- C6: Subledger vs GL reconciliation (AR)
-- Expected result: difference = 0
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
-- C7: GR/IR residual balance
-- Expected result: 0 rows (clearing balance nets to 0)
------------------------------------------------------------
SELECT
  account AS grir_account,
  SUM(CASE WHEN dc_indicator = 'D' THEN amount ELSE -amount END) AS grir_net_balance
FROM gl_entries
WHERE account = '200000'
GROUP BY account
HAVING SUM(CASE WHEN dc_indicator = 'D' THEN amount ELSE -amount END) <> 0;

------------------------------------------------------------
-- C8: Sanity summary (document-level view)
-- Expected result: net_balance = 0 for all docs
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
-- EXTRA: Outlier monitoring (large single lines)
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
