import { supabaseConfig } from './supabaseClient.js';
import fs from 'fs';
import path from 'path';

const { url, key } = supabaseConfig;

// Helper function to check if a relation exists
async function relationExists(relationName, relationType = 'table') {
  try {
    const checkSql = `
      SELECT 1 FROM pg_catalog.pg_class c
      JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
      WHERE c.relname = '${relationName}'
      AND c.relkind = '${relationType === 'table' ? 'r' : 'i'}'
      AND n.nspname = 'public'
    `;

    const response = await fetch(`${url}/rest/v1/rpc/execute_sql`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        apikey: key,
        Authorization: `Bearer ${key}`
      },
      body: JSON.stringify({ sql: checkSql })
    });

    if (!response.ok) return false;
    const result = await response.json();
    return result.length > 0;
  } catch (e) {
    console.error(`❌ Relation check failed: ${e.message}`);
    return false;
  }
}

async function executeSql(sql, relationName, relationType = 'table') {
  try {
    // Skip if the relation already exists
    if (relationName && await relationExists(relationName, relationType)) {
      console.log(`⏩ Relation ${relationName} already exists - skipping`);
      return { skipped: true };
    }

    const response = await fetch(`${url}/rest/v1/rpc/execute_sql`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        apikey: key,
        Authorization: `Bearer ${key}`
      },
      body: JSON.stringify({ sql })
    });

    if (!response.ok) {
      const errorText = await response.text();
      throw new Error(`Error ${response.status}: ${errorText}`);
    }

    return await response.json();
  } catch (e) {
    // Handle "already exists" errors gracefully
    if (e.message.includes('already exists') || e.message.includes('42P07')) {
      console.log(`⏩ Relation already exists - skipping`);
      return { skipped: true };
    }
    console.error(`❌ SQL execution failed: ${e.message}`);
    throw e;
  }
}

async function runMigration(filePath) {
  try {
    if (!fs.existsSync(filePath)) {
      throw new Error(`File not found: ${filePath}`);
    }

    const sql = fs.readFileSync(filePath, 'utf8');
    console.log(`📘 Running migration: ${path.basename(filePath)} (${sql.length} chars)`);

    // Extract table/index names from SQL for idempotency checks
    const tableMatch = sql.match(/CREATE TABLE (?:IF NOT EXISTS )?([a-z_]+)/i);
    const indexMatch = sql.match(/CREATE (?:UNIQUE )?INDEX (?:IF NOT EXISTS )?([a-z_]+)/i);
    
    const result = await executeSql(
      sql,
      tableMatch ? tableMatch[1] : indexMatch ? indexMatch[1] : null,
      indexMatch ? 'index' : 'table'
    );

    if (result?.skipped) {
      console.log(`⏩ Skipped: ${path.basename(filePath)}`);
    } else {
      console.log(`✅ Success: ${path.basename(filePath)}`);
    }
    return result;
  } catch (error) {
    console.error(`❌ Migration failed: ${path.basename(filePath)}`);
    console.error(error);
    throw error;
  }
}

async function runAllMigrations() {
  try {
    const migrationsDir = path.join(process.cwd(), 'susuapp-database', 'supabase', 'migrations');
    const migrationFiles = fs.readdirSync(migrationsDir)
      .filter(file => file.endsWith('.sql'))
      .sort(); // Ensure alphabetical order

    console.log(`🔍 Found ${migrationFiles.length} migration files`);

    for (const fileName of migrationFiles) {
      const fullPath = path.join(migrationsDir, fileName);
      await runMigration(fullPath);
    }

    console.log('🎉 All migrations completed successfully!');
    return true;
  } catch (error) {
    console.error('🔥 Migrations failed.');
    process.exit(1);
    return false;
  }
}

// Run migrations
runAllMigrations()
  .then(success => {
    if (success) {
      console.log('✨ Database is ready!');
    } else {
      console.log('❌ Database migration failed');
    }
  });