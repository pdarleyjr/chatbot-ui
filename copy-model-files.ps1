# PowerShell script to copy model files from chatbot-ui-model-files to the project

# Create the destination directory if it doesn't exist
$destinationDir = "public/models/Supabase/gte-small"
if (-not (Test-Path $destinationDir)) {
    New-Item -ItemType Directory -Path $destinationDir -Force
}

# Copy the model files
Copy-Item -Path "../chatbot-ui-model-files/public/models/Supabase/gte-small/*" -Destination $destinationDir -Force

Write-Host "Model files copied successfully!"