const express = require('express');
const { BotFrameworkAdapter, ActivityHandler, MessageFactory } = require('botbuilder');
require('dotenv').config();

const { ConversationBot } = require('./bot');

// Create Express server
const app = express();
const port = process.env.PORT || 3978;

// Create adapter
const adapter = new BotFrameworkAdapter({
    appId: process.env.MicrosoftAppId,
    appPassword: process.env.MicrosoftAppPassword
});

// Catch-all for errors
adapter.onTurnError = async (context, error) => {
    console.error(`\n [onTurnError] unhandled error: ${error}`);
    
    // Send a trace activity, which will be displayed in Bot Framework Emulator
    await context.sendTraceActivity(
        'OnTurnError Trace',
        `${error}`,
        'https://www.botframework.com/schemas/error',
        'TurnError'
    );
    
    // Send a message to the user
    await context.sendActivity('The bot encountered an error or bug.');
    await context.sendActivity('To continue to run this bot, please fix the bot source code.');
};


// Create the main bot
const myBot = new ConversationBot();

// Parse application/json
app.use(express.json());

// Listen for incoming requests
app.post('/api/messages', (req, res) => {
    adapter.processActivity(req, res, async (context) => {
        // Route to main bot
        await myBot.run(context);
    });
});

// Listen for incoming requests
app.get('/', (req, res) => {
    res.json({
        message: 'Azure Bot is running!',
        botName: process.env.BOT_NAME || 'AzureBot',
        environment: process.env.NODE_ENV || 'development',
        port: port
    });
});

// Health check endpoint
app.get('/health', (req, res) => {
    res.status(200).json({
        status: 'healthy',
        timestamp: new Date().toISOString()
    });
});

app.listen(port, () => {
    console.log(`\n${process.env.BOT_NAME || 'Azure Bot'} listening on port ${port}`);
    console.log('\nGet Bot Framework Emulator: https://aka.ms/botframework-emulator');
    console.log('To test your bot, see: https://aka.ms/debug-with-emulator');
    console.log(`\nTo talk to your bot, open the emulator and connect to http://localhost:${port}/api/messages`);
});

module.exports = app;
