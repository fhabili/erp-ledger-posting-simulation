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

## 4) Control layer (validation queries)
- Document balance check (must net to zero)
- Subledger vs GL reconciliation-style checks
- Mapping completeness / missing dimensions
- Duplicate / anomaly detection

## Architecture Diagram

```mermaid
flowchart LR
  subgraph Master_Data
    COA["Chart of Accounts"]
    MD["Profit / Cost Objects"]
  end

  subgraph Transaction_Layer
    LEDGER["Universal Journal (Ledger Line Items)"]
  end

  subgraph Reporting_Layer
    TB["Trial Balance"]
    PL["P&L Statement"]
    BS["Balance Sheet"]
    MARGIN["Margin by Dimension"]
  end

  subgraph Control_Layer
    C1["Document Balance Check"]
    C2["Subledger vs GL Checks"]
    C3["GR/IR Clearing Validation"]
    C4["Master Data Completeness"]
    C5["Duplicate / Anomaly Detection"]
  end

  COA --> LEDGER
  MD --> LEDGER
  LEDGER --> TB
  LEDGER --> PL
  LEDGER --> BS
  LEDGER --> MARGIN
  LEDGER --> C1
  LEDGER --> C2
  LEDGER --> C3
  LEDGER --> C4
  LEDGER --> C5
