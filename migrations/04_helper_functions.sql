-- Function to get user credit score
CREATE OR REPLACE FUNCTION get_user_credit_score(user_wallet TEXT)
RETURNS DECIMAL AS $$
DECLARE
    score DECIMAL;
BEGIN
    SELECT reputation_score INTO score
    FROM credit_profiles
    JOIN users ON credit_profiles.user_id = users.user_id
    WHERE users.wallet_address = user_wallet;
    
    RETURN score;
END;
$$ LANGUAGE plpgsql;

-- Function to calculate group contribution totals
CREATE OR REPLACE FUNCTION get_group_contributions(group_uuid UUID)
RETURNS TABLE(user_wallet TEXT, total_contributions DECIMAL) AS $$
BEGIN
    RETURN QUERY
    SELECT u.wallet_address, SUM(c.amount)::DECIMAL
    FROM contributions c
    JOIN users u ON c.user_id = u.user_id
    WHERE c.group_id = group_uuid
    GROUP BY u.wallet_address;
END;
$$ LANGUAGE plpgsql;