// Setup type definitions for built-in Supabase Runtime APIs
/// <reference types="https://esm.sh/@supabase/functions-js/src/edge-runtime.d.ts" />

import { createClient } from '@supabase/supabase-js';
import { Database } from '../_lib/database.ts';
import { corsHeaders, handleCors, addCorsHeaders } from '../_lib/cors.ts';

const model = new Supabase.ai.Session('gte-small');

const supabaseUrl = Deno.env.get('SUPABASE_URL');
const supabaseAnonKey = Deno.env.get('SUPABASE_ANON_KEY');

Deno.serve(async (req) => {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    return handleCors();
  }
  
  // Set CORS headers for all responses
  const headers = new Headers({
    'Content-Type': 'application/json',
    ...corsHeaders
  });
  
  if (!supabaseUrl || !supabaseAnonKey) {
    return new Response(
      JSON.stringify({
        error: 'Missing environment variables.',
      }),
      {
        status: 500,
        headers
      }
    );
  }

  const authorization = req.headers.get('Authorization');

  if (!authorization) {
    return new Response(
      JSON.stringify({ error: `No authorization header passed` }),
      {
        status: 500,
        headers
      }
    );
  }

  const supabase = createClient<Database>(supabaseUrl, supabaseAnonKey, {
    global: {
      headers: {
        authorization,
      },
    },
    auth: {
      persistSession: false,
    },
  });

  const { ids, table, contentColumn, embeddingColumn } = await req.json();

  const { data: rows, error: selectError } = await supabase
    .from(table)
    .select(`id, ${contentColumn}` as '*')
    .in('id', ids)
    .is(embeddingColumn, null);

  if (selectError) {
    return new Response(JSON.stringify({ error: selectError }), {
      status: 500,
      headers
    });
  }

  for (const row of rows) {
    const { id, [contentColumn]: content } = row;

    if (!content) {
      console.error(`No content available in column '${contentColumn}'`);
      continue;
    }

    const output = (await model.run(content, {
      mean_pool: true,
      normalize: true,
    })) as number[];

    const embedding = JSON.stringify(output);

    const { error } = await supabase
      .from(table)
      .update({
        [embeddingColumn]: embedding,
      })
      .eq('id', id);

    if (error) {
      console.error(
        `Failed to save embedding on '${table}' table with id ${id}`
      );
    }

    console.log(
      `Generated embedding ${JSON.stringify({
        table,
        id,
        contentColumn,
        embeddingColumn,
      })}`
    );
  }
  
  return new Response(null, {
    status: 204,
    headers
  });
});
