-- 2025-05-13: Enable Row Level Security on all public tables
-- This migration addresses security lints by enabling RLS on all public tables

-- Enable RLS on all tables mentioned in the security lints
ALTER TABLE IF EXISTS public.insights_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.insights_raw ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.insights_by_period ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.migrations ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.execution_entity ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.workflows_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.webhook_entity ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.credentials_entity ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.role ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.tag_entity ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.installed_nodes ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.variables ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.auth_identity ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.event_destinations ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.execution_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.workflow_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.installed_packages ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.user ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.workflow_entity ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.auth_provider_sync_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.workflow_statistics ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.project_relation ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.shared_credentials ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.invalid_auth_token ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.shared_workflow ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.execution_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.project ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.execution_annotations ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.execution_annotation_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.annotation_tag_entity ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.processed_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.user_api_keys ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.test_metric ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.test_definition ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.test_case_execution ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.test_run ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.folder ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.folder_tag ENABLE ROW LEVEL SECURITY;

-- Create a generic policy for all tables to allow authenticated users to access data
-- This is a temporary solution and should be replaced with more specific policies
-- based on the actual table structure and requirements

DO $$
DECLARE
    table_name text;
BEGIN
    FOR table_name IN
        SELECT tablename FROM pg_tables WHERE schemaname = 'public'
    LOOP
        EXECUTE format('
            CREATE POLICY "Authenticated users can access %1$s" ON public.%1$s
            FOR ALL TO authenticated
            USING (true);
        ', table_name);
    END LOOP;
END
$$;