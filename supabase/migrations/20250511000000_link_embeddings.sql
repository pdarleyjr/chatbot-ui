-- 2025-05-11: search_documents() over pre-existing embeddings
CREATE OR REPLACE FUNCTION public.search_documents(
  query_vector vector,           -- the incoming question's embedding
  match_limit integer DEFAULT 5  -- how many hits to return
)
RETURNS TABLE (
  id bigint,
  similarity double precision,
  source_name text,
  snippet text
)
AS $$
BEGIN
  RETURN QUERY
    SELECT
      ds.document_id,
      1 - (ds.embedding <=> query_vector) AS similarity,
      d.name AS source_name,
      left(ds.content, 256) AS snippet
    FROM public.document_sections AS ds
    JOIN public.documents AS d
      ON ds.document_id = d.id
    ORDER BY ds.embedding <=> query_vector
    LIMIT match_limit;
END;
$$
LANGUAGE plpgsql;

-- Grant EXECUTE so your Edge function or API can call it:
GRANT EXECUTE ON FUNCTION public.search_documents(vector, integer) TO anon, service_role;