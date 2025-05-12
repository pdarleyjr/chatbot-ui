import { createClient } from '@supabase/supabase-js';
import { OpenAIStream, StreamingTextResponse } from 'ai';
import { codeBlock } from 'common-tags';
import OpenAI from 'openai';
import { Database } from '../_lib/database.ts';
import { corsHeaders, handleCors, addCorsHeaders } from '../_lib/cors.ts';

const openai = new OpenAI({
  apiKey: Deno.env.get('OPENAI_API_KEY'),
});

// These are automatically injected
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

  const { messages, embedding } = await req.json();
  
  console.log('Received embedding:', embedding.slice(0, 20) + '...');

  console.log('Calling search_documents function...');
  const { data: documents, error: matchError } = await supabase
    .rpc('search_documents', {
      query_vector: embedding,
      match_limit: 5,
    });
  
  console.log('search_documents result:', documents ? documents.length : 0, 'documents found');

  if (matchError) {
    console.error('Error in search_documents:', matchError);
    console.error('Error details:', JSON.stringify(matchError));

    return new Response(
      JSON.stringify({
        error: 'There was an error reading your documents, please try again.',
        details: matchError
      }),
      {
        status: 500,
        headers
      }
    );
  }

  const injectedDocs =
    documents && documents.length > 0
      ? documents.map((doc) => `Source: ${doc.source_name}\n${doc.snippet}`).join('\n\n')
      : 'No documents found';

  console.log(injectedDocs);

  const completionMessages: OpenAI.Chat.Completions.ChatCompletionMessageParam[] =
    [
      {
        role: 'user',
        content: codeBlock`
        You're an AI assistant who answers questions about documents.

        You're a chat bot, so keep your replies succinct.

        You're only allowed to use the documents below to answer the question.

        If the question isn't related to these documents, say:
        "Sorry, I couldn't find any information on that."

        If the information isn't available in the below documents, say:
        "Sorry, I couldn't find any information on that."

        Do not go off topic.

        Documents:
        ${injectedDocs}
      `,
      },
      ...messages,
    ];

  try {
    const completionStream = await openai.chat.completions.create({
      model: 'gpt-3.5-turbo',
      messages: completionMessages,
      max_tokens: 1024,
      temperature: 0,
      stream: true,
    });
    
    const stream = OpenAIStream(completionStream);
    const streamResponse = new StreamingTextResponse(stream);
    
    // Add CORS headers to the streaming response
    Object.entries(corsHeaders).forEach(([key, value]) => {
      streamResponse.headers.set(key, value);
    });
    
    return streamResponse;
  } catch (error) {
    console.error('OpenAI API error:', error);
    return new Response(
      JSON.stringify({
        error: 'Error generating completion',
        details: error instanceof Error ? error.message : String(error)
      }),
      {
        status: 500,
        headers
      }
    );
  }
});
