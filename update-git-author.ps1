# update-git-author.ps1
# Script to update Git author to match the one expected by Vercel

Write-Host "Updating Git author for Vercel deployment..." -ForegroundColor Green

# Update Git author name and email
# Replace 'pdarleyjr' with your actual GitHub username that has access to Vercel
git config --local user.name "pdarleyjr"
git config --local user.email "pdarleyjr@users.noreply.github.com"

# Verify the changes
$name = git config user.name
$email = git config user.email
Write-Host "Git author updated to: $name <$email>" -ForegroundColor Cyan

# Commit any pending changes with the new author
$status = git status --porcelain
if ($status) {
    Write-Host "Committing pending changes with the new author..." -ForegroundColor Cyan
    git add .
    git commit -m "Update Git author for Vercel deployment"
    
    # Push changes to the main branch
    git push origin main
}

Write-Host "`nGit author has been updated!" -ForegroundColor Green
Write-Host "Now try deploying to Vercel again." -ForegroundColor Yellow