-- Enable pgcrypto extension for gen_random_uuid()
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Users table
CREATE TABLE IF NOT EXISTS users (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wallet_address TEXT NOT NULL UNIQUE,
    name TEXT,
    email TEXT,
    joined_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- SavingsGroups table
CREATE TABLE IF NOT EXISTS savings_groups (
    group_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    group_name TEXT NOT NULL,
    created_by UUID REFERENCES users(user_id) NOT NULL,
    group_type TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- GroupMembers junction table
CREATE TABLE IF NOT EXISTS group_members (
    member_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(user_id) NOT NULL,
    group_id UUID REFERENCES savings_groups(group_id) NOT NULL,
    joined_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    UNIQUE(user_id, group_id)
);

-- Contributions table
CREATE TABLE IF NOT EXISTS contributions (
    contribution_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(user_id) NOT NULL,
    group_id UUID REFERENCES savings_groups(group_id) NOT NULL,
    amount DECIMAL(19,4) NOT NULL,
    transaction_hash TEXT NOT NULL,
    contributed_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- PayoutRotations table
CREATE TABLE IF NOT EXISTS payout_rotations (
    payout_rotation_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    group_id UUID REFERENCES savings_groups(group_id) NOT NULL,
    member_id UUID REFERENCES group_members(member_id) NOT NULL,
    payout_amount DECIMAL(19,4) NOT NULL,
    payout_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- CreditProfiles table
CREATE TABLE IF NOT EXISTS credit_profiles (
    credit_profile_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(user_id) UNIQUE NOT NULL,
    reputation_score DECIMAL(5,2) NOT NULL DEFAULT 0,
    last_updated TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- LoanRequests table
CREATE TABLE IF NOT EXISTS loan_requests (
    loan_request_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(user_id) NOT NULL,
    group_id UUID REFERENCES savings_groups(group_id) NOT NULL,
    amount DECIMAL(19,4) NOT NULL,
    interest_rate DECIMAL(5,2) NOT NULL,
    request_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    status TEXT NOT NULL DEFAULT 'pending'
);

-- LoanRepayments table
CREATE TABLE IF NOT EXISTS loan_repayments (
    repayment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    loan_request_id UUID REFERENCES loan_requests(loan_request_id) NOT NULL,
    user_id UUID REFERENCES users(user_id) NOT NULL,
    amount DECIMAL(19,4) NOT NULL,
    repayment_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- ApeCoinRewards table
CREATE TABLE IF NOT EXISTS ape_coin_rewards (
    reward_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(user_id) NOT NULL,
    amount DECIMAL(19,4) NOT NULL,
    reward_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_users_wallet ON users(wallet_address);
CREATE INDEX IF NOT EXISTS idx_group_members_user ON group_members(user_id);
CREATE INDEX IF NOT EXISTS idx_group_members_group ON group_members(group_id);
CREATE INDEX IF NOT EXISTS idx_contributions_user ON contributions(user_id);
CREATE INDEX IF NOT EXISTS idx_contributions_group ON contributions(group_id);
CREATE INDEX IF NOT EXISTS idx_loan_requests_user ON loan_requests(user_id);
CREATE INDEX IF NOT EXISTS idx_loan_requests_group ON loan_requests(group_id);
CREATE INDEX IF NOT EXISTS idx_loan_repayments_loan ON loan_repayments(loan_request_id);
CREATE INDEX IF NOT EXISTS idx_ape_coin_rewards_user ON ape_coin_rewards(user_id);
