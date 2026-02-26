# ERP Ledger Posting Simulation

## Overview

This repository simulates core ERP ledger posting logic, cost object derivation, and validation controls using SQL.

The objective is to demonstrate structured understanding of:

- Double-entry accounting logic within ERP systems
- Subledger to General Ledger integration
- Cost center and profit center derivation
- GR/IR clearing mechanics
- Control-based validation frameworks

This project reflects finance-domain Business Systems thinking rather than software engineering implementation.

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

Modern ERP systems (e.g., SAP) store financial postings in structured ledger tables. Every transaction must:

- Balance (debit = credit)
- Post to correct GL accounts
- Derive correct cost objects (cost center / profit center)
- Maintain reconciliation between subledger and general ledger

Errors typically fall into:

- Classification errors (wrong GL account)
- Derivation errors (wrong cost object)
- Configuration errors (account determination issues)
- Valuation mismatches (price/quantity differences)

This simulation models those structural controls.

---

## Simulated Data Model

The following core tables are modeled:

- `gl_entries` — journal entries at ledger level
- `vendor_subledger` — accounts payable postings
- `customer_subledger` — accounts receivable postings
- `cost_center_dimension` — cost object reference table

The structure reflects simplified ERP financial architecture.

---

## Validation Controls

The project includes SQL queries to detect:

- Unbalanced journal entries
- Missing cost center assignments
- GR/IR residual balances
- Subledger vs GL mismatches
- Incorrect profit center derivation

These represent typical validation tasks during:

- UAT (User Acceptance Testing)
- Period close controls
- Reconciliation reviews
- Hypercare stabilization

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
- Ledger architecture awareness
- Control-driven validation logic
- SQL-based financial data verification

It is intended for Business Systems Analyst and ERP Finance role positioning.

---

## Planned Enhancements

- Add sample dataset inserts
- Add reconciliation scenario simulations
- Expand cost object derivation examples
- Extend validation queries for margin analysis checks
