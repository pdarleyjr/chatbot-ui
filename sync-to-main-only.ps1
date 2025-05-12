# sync-to-main-only.ps1
# Script to ensure all local files are on the main branch and remove outdated branches

Write-Host "Starting synchronization to main branch only..." -ForegroundColor Green

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
    Write-Host "Committing pending changes to main..." -ForegroundColor Cyan
    git add .
    git commit -m "Sync all latest changes to main branch"
}

# Get list of all local branches except main
$branches = git branch | Where-Object { $_ -notmatch "^\*?\s*main$" } | ForEach-Object { $_.Trim() }

# Merge each branch into main to ensure we have all the latest changes
foreach ($branch in $branches) {
    Write-Host "Merging $branch into main..." -ForegroundColor Cyan
    git merge $branch --no-edit
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Merge conflicts detected with $branch. Resolving with 'ours' strategy..." -ForegroundColor Yellow
        git checkout --ours .
        git add .
        git commit -m "Resolve merge conflicts from $branch, keeping main branch version"
    }
}

# Force push main to remote to ensure it has all the latest changes
Write-Host "Force pushing main branch to remote..." -ForegroundColor Cyan
git push -f origin main
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error pushing to remote. Exiting." -ForegroundColor Red
    exit 1
}

# Delete all other local branches
foreach ($branch in $branches) {
    Write-Host "Deleting local branch $branch..." -ForegroundColor Cyan
    git branch -D $branch
}

# Delete all remote branches except main
Write-Host "Fetching remote branches..." -ForegroundColor Cyan
git fetch origin
$remoteBranches = git branch -r | Where-Object { $_ -notmatch "origin/main" -and $_ -notmatch "origin/HEAD" } | ForEach-Object { $_.Trim() }

foreach ($remoteBranch in $remoteBranches) {
    $branchName = $remoteBranch -replace "origin/", ""
    Write-Host "Deleting remote branch $branchName..." -ForegroundColor Cyan
    git push origin --delete $branchName
}

# Set main as the default branch for this repository
Write-Host "Setting main as the default branch..." -ForegroundColor Cyan
git config --local init.defaultBranch main

Write-Host "`nSynchronization complete!" -ForegroundColor Green
Write-Host "All local files are now on the main branch and outdated branches have been removed." -ForegroundColor Green
Write-Host "`nIMPORTANT: To complete the setup on GitHub:" -ForegroundColor Yellow
Write-Host "1. Go to your GitHub repository settings" -ForegroundColor Yellow
Write-Host "2. Navigate to 'Branches' section" -ForegroundColor Yellow
Write-Host "3. Ensure the default branch is set to 'main'" -ForegroundColor Yellow