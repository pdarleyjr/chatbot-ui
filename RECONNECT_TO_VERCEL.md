# Reconnecting to Vercel

This guide will help you reconnect your GitHub repository to Vercel.

## Steps to Reconnect

1. **Log in to Vercel**
   - Go to [vercel.com](https://vercel.com) and log in with your account

2. **Connect GitHub Account**
   - If prompted with the "Connect to GitHub" screen:
     - Click the "Connect @superman32432432" button
     - Follow the authorization flow to connect your Vercel account to the GitHub account
   - If not automatically prompted, go to:
     - Vercel Dashboard → Settings → Git → Connect to GitHub

3. **Import Your Repository**
   - Once connected to GitHub, import your repository:
     - Go to "Add New..." → "Project"
     - Select "pdarleyjr/chatbot-ui" from the list
     - Click "Import"

4. **Configure Project Settings**
   - Framework Preset: Next.js
   - Root Directory: ./
   - Build Command: `npm run build`
   - Output Directory: .next
   - Install Command: `npm install`

5. **Environment Variables**
   - Add the following environment variables from your .env file:
     ```
     NEXT_PUBLIC_SUPABASE_URL=https://uloayyhcpjmxljbhfysg.supabase.co
     NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVsb2F5eWhjcGpteGxqYmhmeXNnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU0NDU4NDUsImV4cCI6MjA2MTAyMTg0NX0.qED8NMgurHVBxQYz3YL3KfdySsev4alMRxDCi1J_-1Y
     SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVsb2F5eWhjcGpteGxqYmhmeXNnIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0NTQ0NTg0NSwiZXhwIjoyMDYxMDIxODQ1fQ.7gG5paXVbkH-QqKm6T3qOaUvKppQ9OM6PFrKGfwL-Yw
     OPENAI_API_KEY=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
     ```

6. **Deploy**
   - Click "Deploy" to start the deployment process

## Troubleshooting

If you encounter issues:

1. **GitHub Permission Issues**
   - Ensure the GitHub account (@superman32432432) has the necessary permissions
   - You may need to request access or join the team as indicated in the screenshot

2. **Connection Issues**
   - Try disconnecting and reconnecting GitHub from Vercel settings
   - Check if there are any GitHub organization restrictions

3. **Deployment Failures**
   - Check the build logs for specific errors
   - Ensure all environment variables are correctly set
   - Verify the build and output directory settings

## Maintaining the Connection

Once connected:
- All pushes to the main branch will automatically trigger new deployments
- You can manage deployment settings in the Vercel project dashboard
- You can set up preview deployments for pull requests if needed