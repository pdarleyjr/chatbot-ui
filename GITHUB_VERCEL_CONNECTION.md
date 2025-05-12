# Connecting GitHub to Your Vercel Account

This guide will help you connect your GitHub repository to your actual Vercel account (pdarleyjr).

## Your Vercel Account Information

Based on the screenshot you provided:
- Username: pdarleyjr
- Email: pdarleyjr@gmail.com
- Default team: peter-darleys-projects
- Vercel ID: PQHcHxa3h9JZhvCCCwBCdh

## Steps to Connect GitHub to Vercel

1. **Log in to Vercel**
   - Go to [vercel.com](https://vercel.com) and log in with your account (pdarleyjr@gmail.com)

2. **Go to Import Project**
   - Click on "Add New..." → "Project"
   - This will take you to the import page

3. **Connect to GitHub (if not already connected)**
   - Click "Continue with GitHub"
   - Authorize Vercel to access your GitHub repositories if prompted
   - Make sure you're using your own GitHub account (pdarleyjr), not @superman32432432

4. **Import Your Repository**
   - Once connected to GitHub, you should see a list of your repositories
   - Find and select "pdarleyjr/chatbot-ui"
   - Click "Import"

5. **Configure Project Settings**
   - Framework Preset: Next.js
   - Root Directory: ./
   - Build Command: `npm run build`
   - Output Directory: .next
   - Install Command: `npm install`

6. **Environment Variables**
   - Add the following environment variables from your .env file:
     ```
     NEXT_PUBLIC_SUPABASE_URL=https://uloayyhcpjmxljbhfysg.supabase.co
     NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVsb2F5eWhjcGpteGxqYmhmeXNnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU0NDU4NDUsImV4cCI6MjA2MTAyMTg0NX0.qED8NMgurHVBxQYz3YL3KfdySsev4alMRxDCi1J_-1Y
     SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVsb2F5eWhjcGpteGxqYmhmeXNnIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0NTQ0NTg0NSwiZXhwIjoyMDYxMDIxODQ1fQ.7gG5paXVbkH-QqKm6T3qOaUvKppQ9OM6PFrKGfwL-Yw
     OPENAI_API_KEY=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
     ```

7. **Deploy**
   - Click "Deploy" to start the deployment process

## Troubleshooting GitHub Connection Issues

If you encounter issues connecting your GitHub account:

1. **Check GitHub Integration in Vercel Settings**
   - Go to your Vercel account settings
   - Navigate to "Integrations" → "Git"
   - Ensure GitHub is properly connected to your account
   - If not, click "Connect GitHub" and follow the prompts

2. **Check Repository Access**
   - Make sure your GitHub account has access to the repository
   - If it's a private repository, ensure Vercel has been granted access to it

3. **Disconnect and Reconnect GitHub**
   - If issues persist, try disconnecting GitHub from Vercel
   - Then reconnect it by following the steps above

## Alternative: Continue Using Vercel CLI

If you prefer to avoid GitHub integration entirely, you can continue using the Vercel CLI method that we've already set up:

```powershell
.\deploy-with-vercel-cli.ps1
```

This approach bypasses GitHub integration entirely and deploys directly from your local files.