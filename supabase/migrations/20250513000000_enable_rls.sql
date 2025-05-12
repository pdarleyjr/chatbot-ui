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

-- Create default policies for all tables
-- These policies allow authenticated users to access their own data
-- You may need to adjust these policies based on your specific requirements

-- Default policy for insights_metadata
CREATE POLICY "Users can access their own insights_metadata" ON public.insights_metadata
  FOR ALL TO authenticated
  USING (auth.uid() = created_by);

-- Default policy for insights_raw
CREATE POLICY "Users can access their own insights_raw" ON public.insights_raw
  FOR ALL TO authenticated
  USING (auth.uid() = created_by);

-- Default policy for insights_by_period
CREATE POLICY "Users can access their own insights_by_period" ON public.insights_by_period
  FOR ALL TO authenticated
  USING (auth.uid() = created_by);

-- Default policy for migrations
CREATE POLICY "Admin users can access migrations" ON public.migrations
  FOR ALL TO authenticated
  USING (auth.jwt() ->> 'role' = 'admin');

-- Default policy for execution_entity
CREATE POLICY "Users can access their own execution_entity" ON public.execution_entity
  FOR ALL TO authenticated
  USING (auth.uid() = created_by);

-- Default policy for workflows_tags
CREATE POLICY "Users can access their own workflows_tags" ON public.workflows_tags
  FOR ALL TO authenticated
  USING (auth.uid() = created_by);

-- Default policy for webhook_entity
CREATE POLICY "Users can access their own webhook_entity" ON public.webhook_entity
  FOR ALL TO authenticated
  USING (auth.uid() = created_by);

-- Default policy for credentials_entity
CREATE POLICY "Users can access their own credentials_entity" ON public.credentials_entity
  FOR ALL TO authenticated
  USING (auth.uid() = created_by);

-- Default policy for role
CREATE POLICY "Users can view roles" ON public.role
  FOR SELECT TO authenticated
  USING (true);

-- Default policy for tag_entity
CREATE POLICY "Users can access their own tag_entity" ON public.tag_entity
  FOR ALL TO authenticated
  USING (auth.uid() = created_by);

-- Default policy for settings
CREATE POLICY "Users can access their own settings" ON public.settings
  FOR ALL TO authenticated
  USING (auth.uid() = created_by);

-- Default policy for installed_nodes
CREATE POLICY "Users can access their own installed_nodes" ON public.installed_nodes
  FOR ALL TO authenticated
  USING (auth.uid() = created_by);

-- Default policy for variables
CREATE POLICY "Users can access their own variables" ON public.variables
  FOR ALL TO authenticated
  USING (auth.uid() = created_by);

-- Default policy for auth_identity
CREATE POLICY "Users can access their own auth_identity" ON public.auth_identity
  FOR ALL TO authenticated
  USING (auth.uid() = created_by);

-- Default policy for event_destinations
CREATE POLICY "Users can access their own event_destinations" ON public.event_destinations
  FOR ALL TO authenticated
  USING (auth.uid() = created_by);

-- Default policy for execution_data
CREATE POLICY "Users can access their own execution_data" ON public.execution_data
  FOR ALL TO authenticated
  USING (auth.uid() = created_by);

-- Default policy for workflow_history
CREATE POLICY "Users can access their own workflow_history" ON public.workflow_history
  FOR ALL TO authenticated
  USING (auth.uid() = created_by);

-- Default policy for installed_packages
CREATE POLICY "Users can access their own installed_packages" ON public.installed_packages
  FOR ALL TO authenticated
  USING (auth.uid() = created_by);

-- Default policy for user
CREATE POLICY "Users can access their own user data" ON public.user
  FOR ALL TO authenticated
  USING (auth.uid() = id);

-- Default policy for workflow_entity
CREATE POLICY "Users can access their own workflow_entity" ON public.workflow_entity
  FOR ALL TO authenticated
  USING (auth.uid() = created_by);

-- Default policy for auth_provider_sync_history
CREATE POLICY "Users can access their own auth_provider_sync_history" ON public.auth_provider_sync_history
  FOR ALL TO authenticated
  USING (auth.uid() = created_by);

-- Default policy for workflow_statistics
CREATE POLICY "Users can access their own workflow_statistics" ON public.workflow_statistics
  FOR ALL TO authenticated
  USING (auth.uid() = created_by);

-- Default policy for project_relation
CREATE POLICY "Users can access their own project_relation" ON public.project_relation
  FOR ALL TO authenticated
  USING (auth.uid() = created_by);

-- Default policy for shared_credentials
CREATE POLICY "Users can access their own shared_credentials" ON public.shared_credentials
  FOR ALL TO authenticated
  USING (auth.uid() = created_by);

-- Default policy for invalid_auth_token
CREATE POLICY "Users can access their own invalid_auth_token" ON public.invalid_auth_token
  FOR ALL TO authenticated
  USING (auth.uid() = created_by);

-- Default policy for shared_workflow
CREATE POLICY "Users can access their own shared_workflow" ON public.shared_workflow
  FOR ALL TO authenticated
  USING (auth.uid() = created_by);

-- Default policy for execution_metadata
CREATE POLICY "Users can access their own execution_metadata" ON public.execution_metadata
  FOR ALL TO authenticated
  USING (auth.uid() = created_by);

-- Default policy for project
CREATE POLICY "Users can access their own project" ON public.project
  FOR ALL TO authenticated
  USING (auth.uid() = created_by);

-- Default policy for execution_annotations
CREATE POLICY "Users can access their own execution_annotations" ON public.execution_annotations
  FOR ALL TO authenticated
  USING (auth.uid() = created_by);

-- Default policy for execution_annotation_tags
CREATE POLICY "Users can access their own execution_annotation_tags" ON public.execution_annotation_tags
  FOR ALL TO authenticated
  USING (auth.uid() = created_by);

-- Default policy for annotation_tag_entity
CREATE POLICY "Users can access their own annotation_tag_entity" ON public.annotation_tag_entity
  FOR ALL TO authenticated
  USING (auth.uid() = created_by);

-- Default policy for processed_data
CREATE POLICY "Users can access their own processed_data" ON public.processed_data
  FOR ALL TO authenticated
  USING (auth.uid() = created_by);

-- Default policy for user_api_keys
CREATE POLICY "Users can access their own user_api_keys" ON public.user_api_keys
  FOR ALL TO authenticated
  USING (auth.uid() = created_by);

-- Default policy for test_metric
CREATE POLICY "Users can access their own test_metric" ON public.test_metric
  FOR ALL TO authenticated
  USING (auth.uid() = created_by);

-- Default policy for test_definition
CREATE POLICY "Users can access their own test_definition" ON public.test_definition
  FOR ALL TO authenticated
  USING (auth.uid() = created_by);

-- Default policy for test_case_execution
CREATE POLICY "Users can access their own test_case_execution" ON public.test_case_execution
  FOR ALL TO authenticated
  USING (auth.uid() = created_by);

-- Default policy for test_run
CREATE POLICY "Users can access their own test_run" ON public.test_run
  FOR ALL TO authenticated
  USING (auth.uid() = created_by);

-- Default policy for folder
CREATE POLICY "Users can access their own folder" ON public.folder
  FOR ALL TO authenticated
  USING (auth.uid() = created_by);

-- Default policy for folder_tag
CREATE POLICY "Users can access their own folder_tag" ON public.folder_tag
  FOR ALL TO authenticated
  USING (auth.uid() = created_by);