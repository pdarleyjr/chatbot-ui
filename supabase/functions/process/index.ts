import { createClient } from '@supabase/supabase-js';
import { Database } from '../_lib/database.ts';
import { processMarkdown } from '../_lib/markdown-parser.ts';
import { corsHeaders, handleCors, addCorsHeaders } from '../_lib/cors.ts';

const supabaseUrl = Deno.env.get('SUPABASE_URL');
const supabaseAnonKey = Deno.env.get('SUPABASE_ANON_KEY');

Deno.serve(async (req) => {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    return handleCors();
  }
  if (!supabaseUrl || !supabaseAnonKey) {
    return addCorsHeaders(
      new Response(
        JSON.stringify({
          error: 'Missing environment variables.',
        }),
        {
          status: 500,
          headers: { 'Content-Type': 'application/json' },
        }
      )
    );
  }

  const authorization = req.headers.get('Authorization');

  if (!authorization) {
    return addCorsHeaders(
      new Response(
        JSON.stringify({ error: `No authorization header passed` }),
        {
          status: 500,
          headers: { 'Content-Type': 'application/json' },
        }
      )
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

  const { document_id } = await req.json();

  const { data: document } = await supabase
    .from('documents_with_storage_path')
    .select()
    .eq('id', document_id)
    .single();

  if (!document?.storage_object_path) {
    return addCorsHeaders(
      new Response(
        JSON.stringify({ error: 'Failed to find uploaded document' }),
        {
          status: 500,
          headers: { 'Content-Type': 'application/json' },
        }
      )
    );
  }

  const { data: file } = await supabase.storage
    .from('files')
    .download(document.storage_object_path);

  if (!file) {
    return addCorsHeaders(
      new Response(
        JSON.stringify({ error: 'Failed to download storage object' }),
        {
          status: 500,
          headers: { 'Content-Type': 'application/json' },
        }
      )
    );
  }

  const fileContents = await file.text();
  const processedMd = processMarkdown(fileContents);

  const { error } = await supabase.from('document_sections').insert(
    processedMd.sections.map(({ content }) => ({
      document_id,
      content,
    }))
  );

  if (error) {
    console.error(error);
    return addCorsHeaders(
      new Response(
        JSON.stringify({ error: 'Failed to save document sections' }),
        {
          status: 500,
          headers: { 'Content-Type': 'application/json' },
        }
      )
    );
  }

  console.log(
    `Saved ${processedMd.sections.length} sections for file '${document.name}'`
  );

  return addCorsHeaders(
    new Response(null, {
      status: 204,
      headers: { 'Content-Type': 'application/json' },
    })
  );
});
