# trigger-vercel-deployment.ps1
# Script to trigger a new Vercel deployment by making a small change and pushing it

Write-Host "Triggering a new Vercel deployment..." -ForegroundColor Green

# Create or update a deployment trigger file
$triggerFile = ".vercel-deploy-trigger"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Set-Content -Path $triggerFile -Value "Deployment triggered at: $timestamp"

# Commit the change
git add $triggerFile
git commit -m "Trigger Vercel deployment"

# Push to main branch
git push origin main

Write-Host "`nVercel deployment has been triggered!" -ForegroundColor Green
Write-Host "Check your Vercel dashboard to see the deployment status." -ForegroundColor Yellow