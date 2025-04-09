-- Enable Row Level Security on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE savings_groups ENABLE ROW LEVEL SECURITY;
ALTER TABLE group_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE contributions ENABLE ROW LEVEL SECURITY;
ALTER TABLE payout_rotations ENABLE ROW LEVEL SECURITY;
ALTER TABLE credit_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE loan_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE loan_repayments ENABLE ROW LEVEL SECURITY;
ALTER TABLE ape_coin_rewards ENABLE ROW LEVEL SECURITY;

-- Create policies for users table
CREATE POLICY "Users can view their own data" ON users
    FOR SELECT USING (auth.uid()::text = wallet_address);

CREATE POLICY "Users can update their own data" ON users
    FOR UPDATE USING (auth.uid()::text = wallet_address);

-- Create policies for group members
CREATE POLICY "Group members can view their groups" ON group_members
    FOR SELECT USING (
        user_id IN (SELECT user_id FROM users WHERE wallet_address = auth.uid()::text)
    );

-- Add more policies as needed for your application