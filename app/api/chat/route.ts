import { createRouteHandlerClient } from '@supabase/auth-helpers-nextjs';
import { cookies } from 'next/headers';
import { NextRequest, NextResponse } from 'next/server';

export const runtime = 'edge';

export async function POST(req: NextRequest) {
  try {
    // Get the request body
    const body = await req.json();
    const { messages, embedding } = body;

    // Get the Supabase client
    const supabase = createRouteHandlerClient({ cookies });
    
    // Get the session
    const { data: { session } } = await supabase.auth.getSession();
    
    if (!session) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      );
    }

    // Forward the request to the Supabase function
    const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
    console.log(`Forwarding request to ${supabaseUrl}/functions/v1/chat`);
    console.log('Messages count:', messages.length);
    console.log('Embedding length:', embedding ? embedding.length : 'undefined');
    
    const response = await fetch(`${supabaseUrl}/functions/v1/chat`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${session.access_token}`,
      },
      body: JSON.stringify({ messages, embedding }),
    });
    
    console.log('Supabase function response status:', response.status);
    
    // Check if the response is ok
    if (!response.ok) {
      const errorText = await response.text();
      console.error(`Supabase function error: ${response.status} ${response.statusText}`, errorText);
      return NextResponse.json(
        { error: `Error from Supabase function: ${response.status} ${response.statusText}` },
        { status: response.status }
      );
    }

    // Get the response as a readable stream
    const reader = response.body?.getReader();
    const stream = new ReadableStream({
      async start(controller) {
        if (!reader) {
          controller.close();
          return;
        }

        try {
          while (true) {
            const { done, value } = await reader.read();
            if (done) {
              controller.close();
              break;
            }
            controller.enqueue(value);
          }
        } catch (error) {
          controller.error(error);
        }
      },
    });
    
    // Return the response with the same headers
    return new Response(stream, {
      headers: {
        'Content-Type': 'text/event-stream',
        'Cache-Control': 'no-cache',
        'Connection': 'keep-alive',
        'Transfer-Encoding': 'chunked',
        'X-Content-Type-Options': 'nosniff',
      },
    });
  } catch (error) {
    console.error('Error in chat API route:', error);
    return NextResponse.json(
      { error: 'Internal Server Error' },
      { status: 500 }
    );
  }
}