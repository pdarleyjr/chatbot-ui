# connect-to-vercel.ps1
# Script to help connect the repository to your actual Vercel account

Write-Host "Setting up connection to your Vercel account (pdarleyjr)..." -ForegroundColor Green

# Update Git author to match your actual GitHub account
Write-Host "Updating Git author to match your GitHub account..." -ForegroundColor Cyan
git config --local user.name "pdarleyjr"
git config --local user.email "pdarleyjr@gmail.com"

# Verify the changes
$name = git config user.name
$email = git config user.email
Write-Host "Git author updated to: $name <$email>" -ForegroundColor Cyan

# Create vercel.json file with project configuration
$vercelConfig = @"
{
  "version": 2,
  "name": "chatbot-ui",
  "framework": "nextjs",
  "buildCommand": "npm run build",
  "devCommand": "npm run dev",
  "installCommand": "npm install",
  "outputDirectory": ".next",
  "github": {
    "enabled": true,
    "silent": false
  },
  "env": {
    "NEXT_PUBLIC_SUPABASE_URL": "https://uloayyhcpjmxljbhfysg.supabase.co",
    "NEXT_PUBLIC_SUPABASE_ANON_KEY": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVsb2F5eWhjcGpteGxqYmhmeXNnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU0NDU4NDUsImV4cCI6MjA2MTAyMTg0NX0.qED8NMgurHVBxQYz3YL3KfdySsev4alMRxDCi1J_-1Y"
  }
}
"@

Set-Content -Path "vercel.json" -Value $vercelConfig
Write-Host "Created vercel.json configuration file" -ForegroundColor Cyan

# Commit and push changes
$status = git status --porcelain
if ($status) {
    Write-Host "Committing changes..." -ForegroundColor Cyan
    git add .
    git commit -m "Add Vercel configuration for pdarleyjr account"
    git push origin main
}

# Display instructions for connecting to Vercel
Write-Host "`nNext steps to connect to your Vercel account:" -ForegroundColor Green
Write-Host "1. Go to https://vercel.com/new" -ForegroundColor Yellow
Write-Host "2. Click 'Continue with GitHub'" -ForegroundColor Yellow
Write-Host "3. Authorize Vercel to access your GitHub repositories" -ForegroundColor Yellow
Write-Host "4. Find and select 'pdarleyjr/chatbot-ui'" -ForegroundColor Yellow
Write-Host "5. Vercel should automatically detect the project configuration from vercel.json" -ForegroundColor Yellow
Write-Host "6. Click 'Deploy'" -ForegroundColor Yellow

Write-Host "`nAlternatively, you can continue using the Vercel CLI method:" -ForegroundColor Green
Write-Host ".\deploy-with-vercel-cli.ps1" -ForegroundColor Yellow

Write-Host "`nFor detailed instructions, see GITHUB_VERCEL_CONNECTION.md" -ForegroundColor Cyan