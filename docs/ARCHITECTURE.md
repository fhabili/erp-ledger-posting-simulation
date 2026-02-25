# Architecture Overview

## Goal
Simulate ERP finance ledger mechanics (Universal Journal style) with reporting + control validation.

## Components
### 1) Master data (structure)
- Chart of Accounts (CoA): classifies GL accounts for statement logic
- Cost / Profit objects: dimensions for managerial reporting

### 2) Transaction layer (posting logic)
- Ledger line items representing postings (GL + subledger integration)
- Double-entry integrity at document level

### 3) Reporting layer (aggregation)
- Trial balance (sum by account)
- P&L / Balance Sheet based on CoA classification
- Margin-style logic (revenue vs COGS)

### 4) Control layer (validation queries)
- Document balance check (must net to zero)
- Subledger vs GL reconciliation-style checks
- Mapping completeness / missing dimensions
- Duplicate / anomaly detection
