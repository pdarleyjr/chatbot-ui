# PowerShell script to deploy Supabase Edge Functions

Write-Host "Deploying Supabase Edge Functions..."

# Change to the supabase directory
Set-Location supabase

# Deploy the functions
supabase functions deploy chat
supabase functions deploy embed
supabase functions deploy process

# Return to the original 
Set-Location ..

Write-Host "Supabase Edge Functions deployed successfully!"