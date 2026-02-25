# Control Pack (Close / UAT Style)

This pack groups validation queries that simulate close/UAT controls in ERP finance.

## C1 — Document balance integrity
**Purpose:** every posted document must net to zero (double-entry).  
**Failure means:** missing line, wrong sign, incomplete posting.

## C2 — Subledger vs GL alignment (conceptual)
**Purpose:** detect inconsistencies between AR/AP subledger totals and GL control accounts.  
**Failure means:** posting logic gap, timing mismatch, mapping issue.

## C3 — GR/IR clearing integrity (conceptual)
**Purpose:** GR/IR should clear when invoice is posted.  
**Failure means:** mismatched quantities/prices, missing invoice, process break.

## C4 — Master data completeness
**Purpose:** every posting has required dimensions (profit/cost center, etc.).  
**Failure means:** broken derivation rule, missing master data, mapping gap.

## C5 — Duplicate / anomaly detection
**Purpose:** prevent duplicate lines and detect unusual spikes.  
**Failure means:** ETL duplication, upstream interface issue, bad rerun logic.
