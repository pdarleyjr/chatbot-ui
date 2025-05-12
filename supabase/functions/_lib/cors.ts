/**
 * Shared CORS headers for Supabase Edge Functions
 * 
 * These headers are necessary for browser clients to make cross-origin requests
 * to your Edge Functions. They must be included in both preflight (OPTIONS)
 * responses and actual (GET/POST/etc) responses.
 */
export const corsHeaders = {
  'Access-Control-Allow-Origin': '*',          // allow any origin for production
  'Access-Control-Allow-Methods': 'OPTIONS, POST, GET, PUT',        // allowed methods
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type', // specific headers
  'Access-Control-Expose-Headers': '*',                             // expose all headers
  'Access-Control-Max-Age': '86400',                                // cache preflight for 24 hours
  'Access-Control-Allow-Credentials': 'true',                       // allow credentials
};

/**
 * Handle CORS preflight requests
 * 
 * @returns Response with appropriate CORS headers
 */
export function handleCors() {
  return new Response(null, { headers: corsHeaders });
}

/**
 * Add CORS headers to any response
 * 
 * @param response The response to add CORS headers to
 * @returns Response with CORS headers added
 */
export function addCorsHeaders(response: Response): Response {
  // Create a new response with the same body, status, and statusText
  const newResponse = new Response(response.body, {
    status: response.status,
    statusText: response.statusText,
    headers: response.headers
  });
  
  // Add each CORS header
  Object.entries(corsHeaders).forEach(([key, value]) => {
    newResponse.headers.set(key, value);
  });
  
  return newResponse;
}