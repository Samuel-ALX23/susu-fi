# SusuApp Database Schema Documentation

## Overview

This repository contains the comprehensive database schema for SusuApp, a blockchain-powered community finance platform. The schema supports:
- Group savings (Susu/Ajo/Chama) functionality
- Peer-to-peer lending
- Credit scoring and reputation systems
- Pension vaults and rewards

## Schema Features

### Core Components

1. **User Management**
   - Wallet-based authentication
   - Profile and verification system
   - Security features (2FA, recovery codes)

2. **Savings Groups**
   - Flexible group configurations
   - Multiple contribution frequencies
   - Role-based access control

3. **Financial Transactions**
   - Contribution tracking
   - Payout management
   - Loan products and applications
   - Repayment processing

4. **Credit System**
   - Dynamic scoring algorithms
   - Reputation event tracking
   - Risk categorization

5. **Ancillary Services**
   - Notification system
   - Audit logging
   - Performance optimization

## Technical Specifications

- **Database**: PostgreSQL 13+
- **Extensions**:
  - `pgcrypto` for UUID generation
  - `uuid-ossp` (alternative UUID option)
- **Designed for**: Supabase compatibility
- **Indexes**: 20+ performance-optimized indexes

## Installation & Setup

### Prerequisites

- Node.js 16+
- PostgreSQL database (or Supabase project)
- Supabase account (for cloud deployment)

### Initial Setup

1. Clone this repository
   ```bash
   git clone https://github.com/your-repo/susuapp-database.git
   cd susuapp-database
   ```

2. Install dependencies
   ```bash
   npm install
   ```

3. Configure environment variables
   ```bash
   cp .env.example .env
   ```
   Edit `.env` with your database credentials.

### Running Migrations

Execute the schema setup:
```bash
node migrations/run.js
```

## Schema Diagram

```
┌─────────────┐       ┌───────────────┐       ┌──────────────┐
│    Users    │───────│ Group Members │───────│ Savings      │
└─────────────┘       └───────────────┘       │   Groups     │
       │                       │               └──────────────┘
       │                       │                      │
       ▼                       ▼                      ▼
┌─────────────┐       ┌───────────────┐       ┌──────────────┐
│ User        │       │ Contributions │       │ Loan         │
│ Security    │       └───────────────┘       │ Products     │
└─────────────┘               │               └──────────────┘
       ▲                      │                      │
       │                      ▼                      ▼
┌─────────────┐       ┌───────────────┐       ┌──────────────┐
│ Credit      │       │   Payouts     │       │ Loan         │
│ Scores      │       └───────────────┘       │ Applications │
└─────────────┘                                      │
       ▲                                             ▼
       │                                     ┌──────────────┐
       └─────────────────────────────────────│ Loan         │
                                             │ Repayments  │
                                             └──────────────┘
```

## Usage Examples

### Create a New Savings Group
```sql
INSERT INTO savings_groups (
    name, 
    description,
    group_type_id,
    created_by,
    contribution_amount,
    contribution_frequency,
    cycle_duration_months
) VALUES (
    'Tech Savings Group',
    'Monthly savings for tech professionals',
    'a1b2c3d4-e5f6-7890-g1h2-i3j4k5l6m7n8',
    100.00,
    'monthly',
    12
);
```

### Record a Contribution
```sql
INSERT INTO contributions (
    group_id,
    member_id,
    amount,
    transaction_hash,
    payment_method
) VALUES (
    'b2c3d4e5-f6g7-8901-h2i3-j4k5l6m7n8o9',
    'c3d4e5f6-g7h8-9012-i3j4-k5l6m7n8o9p0',
    100.00,
    '0x123abc...',
    'crypto'
);
```

## Maintenance

### Backup
```bash
pg_dump -h your-host -U your-user -d your-db > susuapp_backup.sql
```

### Restore
```bash
psql -h your-host -U your-user -d your-db < susuapp_backup.sql
```

## License

Nexabyte License

## Support

For schema-related issues, please open an issue in this repository. For product support, contact support@susuapp.com.