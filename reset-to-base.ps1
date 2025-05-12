# reset-to-base.ps1
# Script to reset chatbot-ui to supabase-community/chatgpt-your-files base template
# while preserving existing knowledge base embeddings

Write-Host "Starting reset process..." -ForegroundColor Green

# Backup existing .env file
Write-Host "Backing up existing .env file..." -ForegroundColor Cyan
if (Test-Path ".env") {
    Copy-Item .env .env.backup -Force
}

# STEP 1 — WIPE EXISTING LOCAL FILES (EXCEPT .GIT)
Write-Host "Step 1: Wiping existing local files (preserving .git)..." -ForegroundColor Cyan
Get-ChildItem -Force | Where-Object { $_.Name -ne ".git" -and $_.Name -ne ".env.backup" -and $_.Name -ne "reset-to-base.ps1" } | Remove-Item -Recurse -Force

# STEP 2 — CLONE NEW BASE TEMPLATE
Write-Host "Step 2: Getting new base template..." -ForegroundColor Cyan
# Create a temporary directory for cloning
$tempDir = [System.IO.Path]::GetTempPath() + [System.Guid]::NewGuid().ToString()
New-Item -ItemType Directory -Path $tempDir | Out-Null

# Clone into the temporary directory
git clone https://github.com/supabase-community/chatgpt-your-files $tempDir
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error cloning repository. Exiting." -ForegroundColor Red
    Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
    exit 1
}

# Copy all files from temp directory to current directory
Write-Host "Copying files from template..." -ForegroundColor Cyan
Copy-Item -Path "$tempDir\*" -Destination "." -Recurse -Force

# Clean up temp directory
Remove-Item -Path $tempDir -Recurse -Force

# STEP 3 — REINITIALIZE GIT AND PUSH
Write-Host "Step 3: Reinitializing git and pushing..." -ForegroundColor Cyan
Remove-Item -Recurse -Force .git
git init
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error initializing git. Exiting." -ForegroundColor Red
    exit 1
}

git remote add origin https://github.com/pdarleyjr/chatbot-ui.git

# STEP 4 — INSTALL & CONFIGURE ENV
Write-Host "Step 4: Installing dependencies and configuring environment..." -ForegroundColor Cyan
npm install
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error installing dependencies. Exiting." -ForegroundColor Red
    exit 1
}

# Restore .env file
if (Test-Path ".env.backup") {
    Copy-Item .env.backup .env -Force
    Remove-Item .env.backup -Force
    Write-Host "Restored existing .env file." -ForegroundColor Green
} else {
    # If no backup exists, create from example and add keys
    if (Test-Path ".env.example") {
        Copy-Item .env.example .env -Force
        
        # Update .env with Supabase & OpenAI keys
        $envContent = Get-Content -Path .env -Raw
        $envContent = $envContent.Replace("NEXT_PUBLIC_SUPABASE_URL=your-project-url", "NEXT_PUBLIC_SUPABASE_URL=https://uloayyhcpjmxljbhfysg.supabase.co")
        $envContent = $envContent.Replace("NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key", "NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVsb2F5eWhjcGpteGxqYmhmeXNnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU0NDU4NDUsImV4cCI6MjA2MTAyMTg0NX0.qED8NMgurHVBxQYz3YL3KfdySsev4alMRxDCi1J_-1Y")
        $envContent = $envContent.Replace("OPENAI_API_KEY=your-openai-api-key", "OPENAI_API_KEY=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")
        
        # Add Supabase service role key if needed
        if (-not ($envContent -match "SUPABASE_SERVICE_ROLE_KEY")) {
            $envContent += "`nSUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVsb2F5eWhjcGpteGxqYmhmeXNnIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0NTQ0NTg0NSwiZXhwIjoyMDYxMDIxODQ1fQ.7gG5paXVbkH-QqKm6T3qOaUvKppQ9OM6PFrKGfwL-Yw"
        }
        
        # Add DB URL if needed
        if (-not ($envContent -match "SUPABASE_DB_URL")) {
            $envContent += "`nSUPABASE_DB_URL=postgresql://postgres.uloayyhcpjmxljbhfysg:Ampbj1206%40%40%40@aws-0-us-east-2.pooler.supabase.com:5432/postgres"
        }
        
        Set-Content -Path .env -Value $envContent
        Write-Host "Created new .env file with your credentials." -ForegroundColor Green
    }
}

# Create .gitignore if it doesn't exist or update it
if (-not (Test-Path ".gitignore")) {
    @"
# Environment variables
.env
.env.local
.env.*

# Supabase
.supabase/

# Node modules
node_modules/

# Build files
.next/
out/
build/
dist/

# Logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Editor directories and files
.idea/
.vscode/
*.suo
*.ntvs*
*.njsproj
*.sln
*.sw?
"@ | Set-Content -Path ".gitignore"
} else {
    $gitignore = Get-Content -Path ".gitignore" -Raw
    if (-not ($gitignore -match "\.env")) {
        $gitignore += "`n# Environment variables`n.env`n.env.local`n.env.*"
        Set-Content -Path ".gitignore" -Value $gitignore
    }
}

# STEP 5 — LINK TO YOUR SUPABASE PROJECT
Write-Host "Step 5: Linking to Supabase project..." -ForegroundColor Cyan
supabase link --project-ref uloayyhcpjmxljbhfysg
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error linking to Supabase project. Exiting." -ForegroundColor Red
    exit 1
}

# STEP 6 — INTEGRATE YOUR EXISTING EMBEDDINGS
Write-Host "Step 6: Creating migration for existing embeddings..." -ForegroundColor Cyan

# Create migrations directory if it doesn't exist
if (-not (Test-Path "supabase/migrations")) {
    New-Item -Path "supabase/migrations" -ItemType Directory -Force | Out-Null
}

# Create migration file for search_documents function
$migrationContent = @"
-- 2025-05-11: search_documents() over pre-existing embeddings
CREATE OR REPLACE FUNCTION public.search_documents(
  query_vector vector,           -- the incoming question's embedding
  match_limit integer DEFAULT 5  -- how many hits to return
)
RETURNS TABLE (
  source_id uuid,
  similarity double precision,
  source_name text,
  snippet text
)
AS $$
BEGIN
  RETURN QUERY
    SELECT
      e.source_id,
      1 - (e.embedding <=> query_vector) AS similarity,
      s.name AS source_name,
      left(s.content, 256) AS snippet
    FROM public.knowledge_base_embeddings AS e
    JOIN public.knowledge_base_sources    AS s
      ON e.source_id = s.id
    ORDER BY e.embedding <=> query_vector
    LIMIT match_limit;
END;
$$
LANGUAGE plpgsql;

-- Grant EXECUTE so your Edge function or API can call it:
GRANT EXECUTE ON FUNCTION public.search_documents(vector, integer) TO anon, service_role;
"@

Set-Content -Path "supabase/migrations/20250511_link_embeddings.sql" -Value $migrationContent

# Push migration to Supabase
Write-Host "Pushing migration to Supabase..." -ForegroundColor Cyan
supabase db push
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error pushing migration to Supabase. Exiting." -ForegroundColor Red
    exit 1
}

# STEP 7 — ADJUST THE NEW REPO'S CHAT HANDLER
Write-Host "Step 7: Adjusting chat handler to use existing embeddings..." -ForegroundColor Cyan

# Find the chat handler file
$chatHandlerPath = ""
if (Test-Path "pages/api/chat.ts") {
    $chatHandlerPath = "pages/api/chat.ts"
} elseif (Test-Path "app/api/chat/route.ts") {
    $chatHandlerPath = "app/api/chat/route.ts"
} else {
    # Search for any chat handler files
    $chatHandlerFiles = Get-ChildItem -Path . -Recurse -Filter "*chat*.ts" | Where-Object { $_.FullName -match "api" }
    if ($chatHandlerFiles.Count -gt 0) {
        $chatHandlerPath = $chatHandlerFiles[0].FullName
    }
}

if ($chatHandlerPath -ne "") {
    Write-Host "Found chat handler at $chatHandlerPath" -ForegroundColor Green
    
    # Read the current content
    $chatHandlerContent = Get-Content -Path $chatHandlerPath -Raw
    
    # Look for a good place to insert our code
    if ($chatHandlerContent -match "// Generate embeddings or retrieve context here") {
        $newChatHandlerContent = $chatHandlerContent -replace "// Generate embeddings or retrieve context here", @"
// Search for relevant documents using our existing knowledge base
const { data: results } = await supabase
  .rpc('search_documents', {
    query_vector: embedding,    // OpenAI embedding you just computed
    match_limit: 5,
  });

// Map results to context for the prompt
const contextText = results?.map(item => 
  `Source: ${item.source_name}\n${item.snippet}`
).join('\n\n');

// Add the context to your prompt
"@
        
        # Write the modified content back
        Set-Content -Path $chatHandlerPath -Value $newChatHandlerContent
        Write-Host "Modified chat handler to use existing knowledge base embeddings." -ForegroundColor Green
    } else {
        Write-Host "Could not find a suitable place to insert code in the chat handler." -ForegroundColor Yellow
        Write-Host "You may need to manually adjust it to use the search_documents() function." -ForegroundColor Yellow
    }
}

# Clean up redundant files
Write-Host "Cleaning up redundant files..." -ForegroundColor Cyan
$redundantFiles = @(
    "COMPREHENSIVE_LOGIN_FIX.md",
    "comprehensive-fix-and-deploy.ps1",
    "deploy-with-fixes.ps1",
    "final-fix.ps1",
    "fix-build-issues.ps1",
    "fix-login-issues.ps1",
    "fix-production-login.ps1",
    "fix-source-maps.cjs",
    "LOGIN_FIX.md",
    "repair-migrations.ps1"
)

foreach ($file in $redundantFiles) {
    if (Test-Path $file) {
        Remove-Item $file -Force
        Write-Host "Removed redundant file: $file" -ForegroundColor Yellow
    }
}

# Commit changes but don't push yet
git add .
git commit -m "Reset to supabase-community/chatgpt-your-files base with knowledge base integration"

Write-Host "Reset process complete!" -ForegroundColor Green
Write-Host "Changes have been committed but not pushed." -ForegroundColor Yellow
Write-Host "To push changes: git push -f origin main" -ForegroundColor Cyan
Write-Host "To test locally: npm run dev" -ForegroundColor Cyan

# Self-destruct this script
$scriptPath = $MyInvocation.MyCommand.Path
Write-Host "This script will self-destruct in 5 seconds..." -ForegroundColor Red
Start-Sleep -Seconds 5
Remove-Item $scriptPath -Force