# ERP Ledger Posting Simulation

## Overview

This repository simulates the transaction architecture layer of an ERP finance system using SQL. It models how business transactions flow into structured General Ledger postings, how AP/AR subledgers reconcile with control accounts, how cost objects are derived, and how validation controls protect ledger integrity before close and reporting.

The objective is to demonstrate structured understanding of:

- ERP-style double-entry posting logic
- Subledger to General Ledger integration
- Cost center and profit center derivation
- GR/IR clearing mechanics
- Control-based validation frameworks

This project reflects finance systems and business systems analysis thinking rather than software engineering product development.

---

## Quick Start (PostgreSQL)

1) Create tables  
- Run: `schema.sql`

2) Load sample transactions  
- Run: `sample_data.sql`

3) Run validation / reconciliation controls  
- Run: `validation_queries.sql`

## Documentation
- Architecture: `docs/ARCHITECTURE.md`
- Control Pack: `docs/CONTROL_PACK.md`
  
---

## Business Context

Modern ERP systems such as SAP store financial transactions in structured ledger tables. Operational events such as supplier invoices, customer invoices, and goods movements must be translated into balanced accounting entries, enriched with the correct dimensions, and reconciled between subledgers and the General Ledger.

Common control failures include:

- classification errors such as posting to the wrong GL account
- derivation errors such as missing cost center or profit center
- reconciliation mismatches between subledger and GL
- GR/IR residual balances caused by incomplete procurement flows
- duplicate or anomalous postings caused by upstream or rerun issues

This simulation models those structural controls at the transaction layer of finance systems architecture.

---

## Simulated Data Model

The following core tables are modeled:

- `gl_entries` — journal entries at ledger level
- `vendor_subledger` — accounts payable open items
- `customer_subledger` — accounts receivable open items
- `cost_center_dimension` — cost object reference table
- `profit_center_dimension` — profit center reference table

The structure reflects a simplified ERP financial architecture.

---

## Validation Controls

The project includes SQL queries to detect:

- unbalanced journal entries
- missing cost center assignments
- missing profit center assignments
- duplicate document lines
- subledger vs GL mismatches
- GR/IR residual balances
- unusual posting outliers

These represent typical validation tasks during:

- UAT (User Acceptance Testing)
- reconciliation reviews
- hypercare stabilization
- period-end validation

---

## Example Use Cases

- Vendor invoice with VAT (P2P process)
- Customer invoice with revenue posting (L2C process)
- Goods receipt and invoice receipt (GR/IR clearing)
- Period-end validation checks

---

## Purpose

This repository serves as a portfolio artifact demonstrating:

- ERP finance systems understanding
- ledger architecture awareness
- control-driven validation logic
- SQL-based financial data verification

It is intended for Finance Systems, Business Systems Analyst, and ERP Finance role positioning.

---

## Planned Enhancements

- add parallel ledger examples (IFRS vs local GAAP)
- extend scenarios for multi-company-code reporting
- expand account determination and mapping error scenarios
- add margin and profitability validation examples
