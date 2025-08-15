# Azure Bot Project

## Deskripsi
Azure Bot Framework application yang dibuat dengan Express.js dan Bot Builder SDK.

## Prerequisites
- Node.js (versi 14 atau lebih tinggi)
- npm atau yarn
- Bot Framework Emulator untuk testing local
- Azure subscription untuk deployment

## Setup Lokal

### 1. Install Dependencies
```bash
npm install
```

### 2. Konfigurasi Environment
Salin file `.env` dan isi dengan kredensial bot Anda:
```env
MicrosoftAppId=YOUR_APP_ID
MicrosoftAppPassword=YOUR_APP_PASSWORD
MicrosoftAppTenantId=YOUR_TENANT_ID
PORT=3978
```

### 3. Jalankan Bot
```bash
# Development mode dengan auto-reload
npm run dev

# Production mode
npm start
```

Bot akan berjalan di `http://localhost:3978`

## Testing

### Bot Framework Emulator
1. Download Bot Framework Emulator dari https://github.com/Microsoft/BotFramework-Emulator
2. Buka emulator dan connect ke `http://localhost:3978/api/messages`
3. Untuk testing lokal, kosongkan App ID dan Password

## Deployment ke Azure

### Prerequisites Azure
1. Azure subscription
2. Azure CLI terinstall
3. Bot sudah terdaftar di Azure Bot Service

### Steps Deployment

#### 1. Login ke Azure
```bash
az login
```

#### 2. Create Resource Group (jika belum ada)
```bash
az group create --name myBotResourceGroup --location "East US"
```

#### 3. Create App Service Plan
```bash
az appservice plan create --name myBotServicePlan --resource-group myBotResourceGroup --sku FREE
```

#### 4. Create Web App
```bash
az webapp create --resource-group myBotResourceGroup --plan myBotServicePlan --name myAzureBot --runtime "NODE|18-lts"
```

#### 5. Configure App Settings
```bash
az webapp config appsettings set --resource-group myBotResourceGroup --name myAzureBot --settings MicrosoftAppId="YOUR_APP_ID" MicrosoftAppPassword="YOUR_APP_PASSWORD"
```

#### 6. Deploy Code
```bash
# Zip deployment
az webapp deployment source config-zip --resource-group myBotResourceGroup --name myAzureBot --src ./deploy.zip
```

### Alternative: GitHub Actions Deployment
Lihat file `.github/workflows/azure-deploy.yml` untuk setup CI/CD.

## Struktur Project
```
├── index.js              # Main application file
├── package.json          # Dependencies dan scripts
├── .env                  # Environment variables (local)
├── .gitignore           # Git ignore rules
├── README.md            # Documentation
└── deploy/              # Deployment files
    ├── web.config       # IIS configuration
    └── azure-deploy.yml # GitHub Actions workflow
```

## Endpoints

- `GET /` - Status bot
- `POST /api/messages` - Bot webhook endpoint
- `GET /health` - Health check

## Development Tips
1. Gunakan Bot Framework Emulator untuk testing
2. Enable debug mode dengan `DEBUG=true` di .env
3. Check logs di console untuk troubleshooting
4. Gunakan ngrok untuk expose local bot ke internet saat development

## Resources
- [Azure Bot Service Documentation](https://docs.microsoft.com/en-us/azure/bot-service/)
- [Bot Framework SDK](https://github.com/Microsoft/botbuilder-js)
- [Bot Framework Emulator](https://github.com/Microsoft/BotFramework-Emulator)
