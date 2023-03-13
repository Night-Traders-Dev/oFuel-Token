const Discord = require('discord.js');
const client = new Discord.Client();

const currency = {
  'OTIP': {
    name: 'ŌTip',
    symbol: 'OTIP',
    balance: {}
  }
};

// Helper function to get user ID from mention string
function getUserFromMention(mention) {
  const matches = mention.match(/^<@!?(\d+)>$/);
  if (!matches) return;
  const id = matches[1];
  return client.users.cache.get(id);
}

client.on('ready', () => {
  console.log(`Logged in as ${client.user.tag}!`);
});

client.on('message', message => {
  // Ignore messages from bots and DMs
  if (message.author.bot || !message.guild) return;

  // Parse message content into command and arguments
  const args = message.content.slice('!'.length).trim().split(/ +/g);
  const command = args.shift().toLowerCase();

  if (command === 'balance') {
    // Check balance for a user
    const user = message.mentions.users.first() || message.author;
    const balance = currency.OTIP.balance[user.id] || 0;
    message.channel.send(`${user.username} has ${balance} ${currency.OTIP.symbol}`);
  }
  else if (command === 'give') {
    // Give ōTip to a user
    const user = getUserFromMention(args[0]);
    const amount = parseInt(args[1]);

    if (!user || isNaN(amount)) {
      message.channel.send('Invalid syntax. Usage: !give @user <amount>');
      return;
    }

    const senderBalance = currency.OTIP.balance[message.author.id] || 0;
    if (senderBalance < amount) {
      message.channel.send('You do not have enough ōTip to give.');
      return;
    }

    currency.OTIP.balance[message.author.id] -= amount;
    currency.OTIP.balance[user.id] = (currency.OTIP.balance[user.id] || 0) + amount;

    message.channel.send(`${message.author.username} gave ${user.username} ${amount} ${currency.OTIP.symbol}`);
  }
  else if (command === 'tip') {
    // Tip ōTip to a user
    const user = getUserFromMention(args[0]);
    const amount = parseInt(args[1]);

    if (!user || isNaN(amount)) {
      message.channel.send('Invalid syntax. Usage: !tip @user <amount>');
      return;
    }

    const senderBalance = currency.OTIP.balance[message.author.id] || 0;
    if (senderBalance < amount) {
      message.channel.send('You do not have enough ōTip to tip.');
      return;
    }

    currency.OTIP.balance[message.author.id] -= amount;
    currency.OTIP.balance[user.id] = (currency.OTIP.balance[user.id] || 0) + amount;

    message.channel.send(`${message.author.username} tipped ${user.username} ${amount} ${currency.OTIP.symbol}`);
  }
});

client.login('YOUR_DISCORD_BOT_TOKEN');
