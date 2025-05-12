# push-to-main.ps1
# Script to ensure all changes are pushed to the main branch

Write-Host "Ensuring all changes are pushed to the main branch..." -ForegroundColor Green

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

# Stage all changes
Write-Host "Staging all changes..." -ForegroundColor Cyan
git add .

# Commit changes if there are any
$status = git status --porcelain
if ($status) {
    $commitMessage = Read-Host -Prompt "Enter commit message"
    git commit -m $commitMessage
}

# Pull the latest changes from the remote main branch
Write-Host "Pulling latest changes from remote main branch..." -ForegroundColor Cyan
git pull origin main --no-edit

# Push changes to the remote main branch
Write-Host "Pushing changes to remote main branch..." -ForegroundColor Cyan
git push origin main

Write-Host "All changes have been pushed to the main branch!" -ForegroundColor Green