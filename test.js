import { supabase } from './supabaseClient.js';
import fs from 'fs';
import path from 'path';

async function runMigrations() {
    try {
        const migrationFiles = [
            '01_initial_schema.sql',
            '02_create_indexes.sql'
        ];

        for (const file of migrationFiles) {
            const filePath = path.join(process.cwd(), 'migrations', file);
            const sql = fs.readFileSync(filePath, 'utf8');

            console.log(`Running migration: ${file}`);
            const { data, error } = await supabase.rpc('execute_sql', { sql });

            if (error) {
                console.error(`❌ Migration failed: ${file}`, error);
                return false;
            }

            console.log(`✅ Migration ${file} completed successfully`);
        }
        return true;
    } catch (error) {
        console.error('❌ Migration failed:', error);
        return false;
    }
}

async function testConnection() {
  /*  // Option 1: Use a real user-defined table name
    const TEST_TABLE = 'your_table_name'; // 🔁 Replace with actual table created in 01_initial_schema.sql

    const { data, error } = await supabase
        .from(TEST_TABLE)
        .select('*')
        .limit(1);

    if (error) {
        console.log('❌ Connection test failed:', error);
    } else {
        console.log('✅ Connection test passed - database is accessible');
    }
*/

    // Option 2: Or use pg_catalog.pg_tables via SQL (Uncomment to use)
    const { data, error } = await supabase.rpc('execute_sql', {
        sql: 'SELECT * FROM pg_catalog.pg_tables LIMIT 1;'
    });

    if (error) {
        console.log('❌ Connection test failed (pg_catalog):', error);
    } else {
        console.log('✅ Connection test passed using pg_catalog.pg_tables');
    }

}

async function main() {
    const migrationsSuccess = await runMigrations();
    if (migrationsSuccess) {
        await testConnection();
    }
}

main();
