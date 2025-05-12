# deploy-with-vercel-cli.ps1
# Script to deploy the project using Vercel CLI instead of GitHub integration

Write-Host "Preparing to deploy with Vercel CLI..." -ForegroundColor Green

# Check if Vercel CLI is installed
$vercelInstalled = $null
try {
    $vercelInstalled = Get-Command vercel -ErrorAction Stop
} catch {
    $vercelInstalled = $null
}

if (-not $vercelInstalled) {
    Write-Host "Vercel CLI not found. Installing..." -ForegroundColor Yellow
    npm install -g vercel
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error installing Vercel CLI. Please install it manually with 'npm install -g vercel'" -ForegroundColor Red
        exit 1
    }
}

# Ensure we're on the main branch
$currentBranch = git rev-parse --abbrev-ref HEAD
if ($currentBranch -ne "main") {
    Write-Host "Switching to main branch..." -ForegroundColor Cyan
    git checkout main
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error switching to main branch. Exiting." -ForegroundColor Red
        exit 1
    }
}

# Commit any pending changes
$status = git status --porcelain
if ($status) {
    Write-Host "Committing pending changes..." -ForegroundColor Cyan
    git add .
    git commit -m "Prepare for Vercel CLI deployment"
    git push origin main
}

# Create a .vercel.json file with project settings
$vercelConfig = @"
{
  "version": 2,
  "buildCommand": "npm run build",
  "devCommand": "npm run dev",
  "installCommand": "npm install",
  "framework": "nextjs",
  "outputDirectory": ".next"
}
"@

Set-Content -Path ".vercel.json" -Value $vercelConfig
Write-Host "Created .vercel.json configuration file" -ForegroundColor Cyan

# Create a .env.production file with environment variables
$envContent = Get-Content -Path ".env" -Raw
Set-Content -Path ".env.production" -Value $envContent
Write-Host "Created .env.production file from .env" -ForegroundColor Cyan

# Login to Vercel (if needed)
Write-Host "Checking Vercel login status..." -ForegroundColor Cyan
$loginStatus = vercel whoami
if ($LASTEXITCODE -ne 0) {
    Write-Host "Please login to Vercel:" -ForegroundColor Yellow
    vercel login
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error logging in to Vercel. Exiting." -ForegroundColor Red
        exit 1
    }
}

# Deploy to Vercel
Write-Host "Deploying to Vercel..." -ForegroundColor Green
Write-Host "You will be prompted to configure your project if this is the first deployment." -ForegroundColor Yellow
Write-Host "Use the following settings when prompted:" -ForegroundColor Yellow
Write-Host "  - Set up and deploy: Yes" -ForegroundColor Yellow
Write-Host "  - Link to existing project: Select your project or No to create new" -ForegroundColor Yellow
Write-Host "  - Directory: ./ (current directory)" -ForegroundColor Yellow
Write-Host "  - Override settings: No" -ForegroundColor Yellow

vercel --prod

if ($LASTEXITCODE -eq 0) {
    Write-Host "`nDeployment successful!" -ForegroundColor Green
    Write-Host "Your project is now deployed on Vercel without requiring GitHub integration." -ForegroundColor Green
} else {
    Write-Host "`nDeployment encountered issues. Check the Vercel CLI output above." -ForegroundColor Red
}

# Cleanup
Write-Host "`nCleaning up temporary files..." -ForegroundColor Cyan
if (Test-Path ".vercel.json") {
    Remove-Item ".vercel.json"
}

Write-Host "`nDone!" -ForegroundColor Green