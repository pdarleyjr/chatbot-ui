# migrate-to-main.ps1
# Script to migrate all content from other branches to the main branch

Write-Host "Starting migration to main branch..." -ForegroundColor Green

# Check if we're on the main branch, if not switch to it
$currentBranch = git rev-parse --abbrev-ref HEAD
if ($currentBranch -ne "main") {
    Write-Host "Switching to main branch..." -ForegroundColor Cyan
    
    # Check if main branch exists locally
    $mainExists = git show-ref --verify --quiet refs/heads/main
    if ($LASTEXITCODE -ne 0) {
        # Create main branch if it doesn't exist
        Write-Host "Creating main branch..." -ForegroundColor Cyan
        git checkout -b main
    } else {
        # Switch to existing main branch
        git checkout main
    }
}

# Get list of all branches except main
$branches = git branch | Where-Object { $_ -notmatch "^\*?\s*main$" } | ForEach-Object { $_.Trim() }

# Merge each branch into main
foreach ($branch in $branches) {
    Write-Host "Merging $branch into main..." -ForegroundColor Cyan
    git merge $branch --no-edit
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Warning: Merge conflicts detected with $branch. Aborting merge." -ForegroundColor Yellow
        git merge --abort
        Write-Host "You may need to manually merge changes from $branch." -ForegroundColor Yellow
    }
}

# Push changes to remote main branch
Write-Host "Pushing changes to remote main branch..." -ForegroundColor Cyan
git push -u origin main

# Set main as the default branch for this repository
Write-Host "Setting main as the default branch..." -ForegroundColor Cyan
git config --local init.defaultBranch main

# Instructions for GitHub
Write-Host "`nMigration complete!" -ForegroundColor Green
Write-Host "`nIMPORTANT: To complete the setup on GitHub:" -ForegroundColor Yellow
Write-Host "1. Go to your GitHub repository settings" -ForegroundColor Yellow
Write-Host "2. Navigate to 'Branches' section" -ForegroundColor Yellow
Write-Host "3. Change the default branch to 'main'" -ForegroundColor Yellow
Write-Host "4. Consider deleting the other branches once you've verified all content is on main" -ForegroundColor Yellow