# Azure Bot Deployment Script for PowerShell
# Make sure you have Azure CLI installed and logged in

Write-Host "🚀 Starting Azure Bot Deployment..." -ForegroundColor Green

# Variables (Update these with your values)
$ResourceGroup = "myBotResourceGroup"
$AppServicePlan = "myBotServicePlan"
$WebAppName = "myAzureBot-$(Get-Date -Format 'yyyyMMddHHmmss')"
$Location = "East US"
$BotName = "MyAzureBot"

Write-Host "📋 Configuration:" -ForegroundColor Yellow
Write-Host "  Resource Group: $ResourceGroup"
Write-Host "  App Service Plan: $AppServicePlan"
Write-Host "  Web App Name: $WebAppName"
Write-Host "  Location: $Location"

# Step 1: Login to Azure (if not already logged in)
Write-Host "🔐 Checking Azure login status..." -ForegroundColor Blue
$loginStatus = az account show 2>$null
if (-not $loginStatus) {
    Write-Host "Please login to Azure..." -ForegroundColor Yellow
    az login
}

# Step 2: Create Resource Group
Write-Host "📦 Creating Resource Group..." -ForegroundColor Blue
az group create --name $ResourceGroup --location $Location

# Step 3: Create App Service Plan
Write-Host "🔧 Creating App Service Plan..." -ForegroundColor Blue
az appservice plan create `
  --name $AppServicePlan `
  --resource-group $ResourceGroup `
  --sku FREE `
  --is-linux

# Step 4: Create Web App
Write-Host "🌐 Creating Web App..." -ForegroundColor Blue
az webapp create `
  --resource-group $ResourceGroup `
  --plan $AppServicePlan `
  --name $WebAppName `
  --runtime "NODE:18-lts"

# Step 5: Configure App Settings
Write-Host "⚙️ Configuring App Settings..." -ForegroundColor Blue
az webapp config appsettings set `
  --resource-group $ResourceGroup `
  --name $WebAppName `
  --settings `
    MicrosoftAppId="" `
    MicrosoftAppPassword="" `
    MicrosoftAppTenantId="" `
    BOT_NAME=$BotName `
    NODE_ENV="production"

# Step 6: Deploy Code
Write-Host "📤 Preparing deployment package..." -ForegroundColor Blue

# Create temporary deployment directory
$TempDir = ".\temp_deploy"
if (Test-Path $TempDir) {
    Remove-Item -Recurse -Force $TempDir
}
New-Item -ItemType Directory -Path $TempDir

# Copy necessary files
Copy-Item -Path ".\index.js" -Destination $TempDir
Copy-Item -Path ".\bot.js" -Destination $TempDir
Copy-Item -Path ".\package.json" -Destination $TempDir
Copy-Item -Path ".\deploy\web.config" -Destination $TempDir

# Create zip file
$ZipPath = ".\deploy.zip"
if (Test-Path $ZipPath) {
    Remove-Item $ZipPath
}

# Use 7-Zip if available, otherwise use PowerShell compression
if (Get-Command "7z" -ErrorAction SilentlyContinue) {
    7z a $ZipPath "$TempDir\*"
} else {
    Compress-Archive -Path "$TempDir\*" -DestinationPath $ZipPath
}

Write-Host "📤 Deploying to Azure..." -ForegroundColor Blue
az webapp deployment source config-zip `
  --resource-group $ResourceGroup `
  --name $WebAppName `
  --src $ZipPath

# Step 7: Get Web App URL
Write-Host "✅ Deployment Complete!" -ForegroundColor Green
Write-Host "🌐 Your bot is available at: https://$WebAppName.azurewebsites.net" -ForegroundColor Cyan
Write-Host "🔗 Bot endpoint: https://$WebAppName.azurewebsites.net/api/messages" -ForegroundColor Cyan

# Clean up
Remove-Item -Recurse -Force $TempDir
Remove-Item $ZipPath

Write-Host "`n🎉 Done! Don't forget to:" -ForegroundColor Green
Write-Host "1. Register your bot in Azure Bot Service" -ForegroundColor Yellow
Write-Host "2. Configure the messaging endpoint in Azure Portal" -ForegroundColor Yellow
Write-Host "3. Set up your MicrosoftAppId and MicrosoftAppPassword" -ForegroundColor Yellow
Write-Host "4. Test your bot using Bot Framework Emulator or Web Chat" -ForegroundColor Yellow

# Display next steps
Write-Host "`n📋 Next Steps:" -ForegroundColor Magenta
Write-Host "1. Go to Azure Portal (portal.azure.com)" -ForegroundColor White
Write-Host "2. Create a new Bot Service resource" -ForegroundColor White
Write-Host "3. Use this messaging endpoint: https://$WebAppName.azurewebsites.net/api/messages" -ForegroundColor White
Write-Host "4. Get the App ID and Password from the Bot Service" -ForegroundColor White
Write-Host "5. Update your .env file with the credentials" -ForegroundColor White
Write-Host "6. Redeploy with the updated credentials" -ForegroundColor White
