-- SECURITY WARNING:
-- This function should only be used in trusted internal tools
-- and NEVER exposed to clients directly.

CREATE OR REPLACE FUNCTION execute_sql(sql TEXT)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
BEGIN
  EXECUTE sql;
  RETURN 'Executed successfully';
EXCEPTION
  WHEN OTHERS THEN
    RETURN format('Error: %s', SQLERRM);
END;
$$;
