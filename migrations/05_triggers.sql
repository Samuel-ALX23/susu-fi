-- Trigger to automatically create a credit profile when a new user is added
CREATE OR REPLACE FUNCTION create_credit_profile()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO credit_profiles (user_id)
    VALUES (NEW.user_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_create_credit_profile
AFTER INSERT ON users
FOR EACH ROW
EXECUTE FUNCTION create_credit_profile();

-- Trigger to update last_updated when credit score changes
CREATE OR REPLACE FUNCTION update_credit_profile_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.last_updated = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_credit_profile_timestamp
BEFORE UPDATE ON credit_profiles
FOR EACH ROW
EXECUTE FUNCTION update_credit_profile_timestamp();