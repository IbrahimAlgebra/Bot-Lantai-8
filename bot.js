
const { ActivityHandler, MessageFactory } = require('botbuilder');

class ConversationBot extends ActivityHandler {
    constructor() {
        super();
        
        // Bot state untuk menyimpan conversation data
        this.conversationReferences = {};
        
        this.onMessage(async (context, next) => {
            const userMessage = context.activity.text.toLowerCase().trim();
            
            // Simple conversation logic
            let replyText = '';
            
            switch (userMessage) {
                case 'hello':
                case 'hi':
                case 'halo':
                    replyText = 'Halo! Saya Azure Bot. Bagaimana saya bisa membantu Anda hari ini?';
                    break;
                case 'help':
                case 'bantuan':
                    replyText = 'Saya bisa membantu Anda dengan:\n- Menjawab pertanyaan\n- Memberikan informasi\n- Chat santai\n\nKetik "menu" untuk melihat opsi lainnya.';
                    break;
                case 'menu':
                    replyText = 'Menu Bot:\n1. Ketik "info" untuk informasi bot\n2. Ketik "time" untuk waktu saat ini\n3. Ketik "joke" untuk lelucon\n4. Ketik "help" untuk bantuan';
                    break;
                case 'info':
                    replyText = 'Saya adalah Azure Bot yang dibuat dengan Bot Framework. Saya dapat memproses pesan dan memberikan respon yang sesuai.';
                    break;
                case 'time':
                    replyText = `Waktu saat ini: ${new Date().toLocaleString('id-ID')}`;
                    break;
                case 'joke':
                    const jokes = [
                        'Mengapa programmer tidak suka alam? Karena terlalu banyak bug! 🐛',
                        'Apa bedanya Java dengan JavaScript? Sama seperti Car dengan Carpet! 🚗',
                        'Mengapa CSS selalu stress? Karena selalu ada yang tidak align! 😅'
                    ];
                    replyText = jokes[Math.floor(Math.random() * jokes.length)];
                    break;
                case 'bye':
                case 'goodbye':
                case 'selamat tinggal':
                    replyText = 'Sampai jumpa! Terima kasih sudah chat dengan saya. Have a great day! 👋';
                    break;
                default:
                    replyText = `Anda berkata: "${context.activity.text}"\n\nSaya belum mengerti pesan ini. Ketik "help" untuk melihat apa yang bisa saya lakukan.`;
            }
            
            await context.sendActivity(MessageFactory.text(replyText));
            await next();
        });
        
        this.onMembersAdded(async (context, next) => {
            const membersAdded = context.activity.membersAdded;
            const welcomeText = `
            🤖 **Selamat datang di Azure Bot!**

            Halo! Saya adalah bot assistant yang siap membantu Anda.

            **Perintah yang tersedia:**
            - Ketik **"help"** untuk bantuan
            - Ketik **"menu"** untuk melihat menu
            - Ketik **"hello"** untuk menyapa

            Mari mulai percakapan! 😊`;
            
            for (let cnt = 0; cnt < membersAdded.length; ++cnt) {
                if (membersAdded[cnt].id !== context.activity.recipient.id) {
                    await context.sendActivity(MessageFactory.text(welcomeText));
                }
            }
            
            await next();
        });
    }
    
    // Method untuk menambahkan conversation reference
    addConversationReference(activity) {
        const conversationReference = TurnContext.getConversationReference(activity);
        this.conversationReferences[conversationReference.conversation.id] = conversationReference;
    }
}

module.exports.ConversationBot = ConversationBot;
