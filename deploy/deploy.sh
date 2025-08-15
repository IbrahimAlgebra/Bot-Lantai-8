#!/bin/bash

# Azure Bot Deployment Script
# Make sure you have Azure CLI installed and logged in

echo "🚀 Starting Azure Bot Deployment..."

# Variables (Update these with your values)
RESOURCE_GROUP="myBotResourceGroup"
APP_SERVICE_PLAN="myBotServicePlan"
WEB_APP_NAME="myAzureBot-$(date +%s)"
LOCATION="East US"
BOT_NAME="MyAzureBot"

echo "📋 Configuration:"
echo "  Resource Group: $RESOURCE_GROUP"
echo "  App Service Plan: $APP_SERVICE_PLAN"
echo "  Web App Name: $WEB_APP_NAME"
echo "  Location: $LOCATION"

# Step 1: Create Resource Group
echo "📦 Creating Resource Group..."
az group create --name $RESOURCE_GROUP --location "$LOCATION"

# Step 2: Create App Service Plan
echo "🔧 Creating App Service Plan..."
az appservice plan create \
  --name $APP_SERVICE_PLAN \
  --resource-group $RESOURCE_GROUP \
  --sku FREE \
  --is-linux

# Step 3: Create Web App
echo "🌐 Creating Web App..."
az webapp create \
  --resource-group $RESOURCE_GROUP \
  --plan $APP_SERVICE_PLAN \
  --name $WEB_APP_NAME \
  --runtime "NODE|18-lts"

# Step 4: Configure App Settings
echo "⚙️ Configuring App Settings..."
az webapp config appsettings set \
  --resource-group $RESOURCE_GROUP \
  --name $WEB_APP_NAME \
  --settings \
    MicrosoftAppId="" \
    MicrosoftAppPassword="" \
    MicrosoftAppTenantId="" \
    BOT_NAME="$BOT_NAME" \
    NODE_ENV="production"

# Step 5: Deploy Code
echo "📤 Deploying Code..."
# Create deployment package
zip -r deploy.zip . -x "*.git*" "node_modules/*" "*.log" ".env"

# Deploy to Azure
az webapp deployment source config-zip \
  --resource-group $RESOURCE_GROUP \
  --name $WEB_APP_NAME \
  --src deploy.zip

# Step 6: Get Web App URL
echo "✅ Deployment Complete!"
echo "🌐 Your bot is available at: https://$WEB_APP_NAME.azurewebsites.net"
echo "🔗 Bot endpoint: https://$WEB_APP_NAME.azurewebsites.net/api/messages"

# Clean up
rm -f deploy.zip

echo "🎉 Done! Don't forget to:"
echo "1. Register your bot in Azure Bot Service"
echo "2. Configure the messaging endpoint in Azure Portal"
echo "3. Set up your MicrosoftAppId and MicrosoftAppPassword"
