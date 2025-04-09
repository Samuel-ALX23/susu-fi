import { createClient } from '@supabase/supabase-js';

const config = {
  url: 'https://plxvyfdbezvthgfjpbnk.supabase.co',
  key: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBseHZ5ZmRiZXp2dGhnZmpwYm5rIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0NDE4OTUyOCwiZXhwIjoyMDU5NzY1NTI4fQ.Qxt-c-GntjDVIrt60wiioh_PQwBakPCM9bowKCTB8hQ' // MUST be service_role key
};

export const supabase = createClient(config.url, config.key, {
  db: { schema: 'public' },
  auth: { persistSession: false }
});

// Export config for use in other files
export const supabaseConfig = config;