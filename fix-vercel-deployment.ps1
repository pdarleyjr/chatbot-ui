# fix-vercel-deployment.ps1
# Script to fix Vercel deployment by updating Git author to match the one expected by Vercel

Write-Host "Fixing Vercel deployment..." -ForegroundColor Green

# Update Git author name and email to match the one expected by Vercel
git config --local user.name "superman32432432"
git config --local user.email "superman32432432@users.noreply.github.com"

# Verify the changes
$name = git config user.name
$email = git config user.email
Write-Host "Git author updated to: $name <$email>" -ForegroundColor Cyan

# Commit any pending changes with the new author
$status = git status --porcelain
if ($status) {
    Write-Host "Committing pending changes with the new author..." -ForegroundColor Cyan
    git add .
    git commit -m "Fix Vercel deployment by updating Git author"
    
    # Push changes to the main branch
    git push origin main
}

Write-Host "`nVercel deployment fix has been applied!" -ForegroundColor Green
Write-Host "Now try deploying to Vercel again." -ForegroundColor Yellow
Write-Host "`nIf this doesn't work, you may need to:" -ForegroundColor Yellow
Write-Host "1. Go to your Vercel project settings" -ForegroundColor Yellow
Write-Host "2. Add 'superman32432432' as a collaborator" -ForegroundColor Yellow
Write-Host "3. Or update the Git integration settings to use your current Git author" -ForegroundColor Yellow