# AI Coding Agent Instructions

## IMPORTANT: ALWAYS PUSH TO MAIN BRANCH

All AI coding agents working on this repository **MUST** follow these guidelines:

1. **ALWAYS push changes to the `main` branch ONLY**
2. **DO NOT create or push to any other branches**
3. **DO NOT create pull requests**

## Workflow for AI Coding Agents

When making changes to this repository, follow this workflow:

```bash
# Always start by pulling the latest changes from main
git pull origin main

# Make your changes to the codebase

# Stage your changes
git add .

# Commit your changes with a descriptive message
git commit -m "Your descriptive commit message"

# Push directly to main branch
git push origin main
```

## Troubleshooting

If you encounter issues pushing to main:

1. Make sure you're on the main branch:
   ```bash
   git checkout main
   ```

2. Pull the latest changes:
   ```bash
   git pull origin main
   ```

3. Resolve any conflicts and then push:
   ```bash
   git push origin main
   ```

## Repository Configuration

This repository is configured to enforce pushing to the main branch:

1. GitHub Actions workflow will automatically merge changes from other branches to main
2. The default branch is set to `main`

**DO NOT MODIFY THESE CONFIGURATIONS**