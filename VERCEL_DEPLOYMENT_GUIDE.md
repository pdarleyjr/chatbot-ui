# Vercel Deployment Guide

This guide provides instructions on how to fix common Vercel deployment issues for this repository.

## Common Issues and Solutions

### 1. Git Author Access Issue

If you see an error like:
```
Git author superman32432432 must have access to the project on Vercel to create deployments.
```

This means the Git author used for commits doesn't have access to the Vercel project. To fix this:

#### Option 1: Update Git Author

Run the provided script to update your Git author to match the one expected by Vercel:

```powershell
.\fix-vercel-deployment.ps1
```

This script:
- Updates your Git author to "superman32432432"
- Commits any pending changes with the new author
- Pushes changes to the main branch

#### Option 2: Add Your Git Author to Vercel

Alternatively, you can add your current Git author to the Vercel project:

1. Go to your Vercel project settings
2. Navigate to the "Git Integration" section
3. Add your Git author as a collaborator

### 2. Trigger a New Deployment

If you've fixed the Git author issue but still need to trigger a new deployment:

```powershell
.\trigger-vercel-deployment.ps1
```

This script:
- Creates or updates a deployment trigger file
- Commits and pushes the change to trigger a new deployment

### 3. Branch Issues

All deployments should be made from the `main` branch only. If you're having branch-related issues:

```powershell
.\sync-to-main-only.ps1
```

This script:
- Ensures all local files are on the main branch
- Removes outdated branches
- Sets main as the default branch

## Vercel Configuration

For optimal Vercel deployment:

1. Always push to the `main` branch
2. Ensure your Git author has access to the Vercel project
3. Check the Vercel dashboard for deployment logs if issues persist

## Supabase Preview Issues

If you see "Supabase Preview Skipped", this is normal for this project configuration and doesn't affect the main deployment.