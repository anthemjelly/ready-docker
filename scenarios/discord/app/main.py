import os
import discord
from discord.ext import commands
from deep_translator import GoogleTranslator
from dotenv import load_dotenv

# 載入環境變數
load_dotenv()
TOKEN = os.getenv("DISCORD_BOT_TOKEN")

# 設定機器人
intents = discord.Intents.default()
intents.message_content = True
bot = commands.Bot(command_prefix="!", intents=intents)

@bot.event
async def on_ready():
    print(f"已登入為 {bot.user}")

@bot.command()
async def translate(ctx, *, text):
    """翻譯：!translate 你好 → Hello"""
    try:
        # 自動偵測語言並翻成英文
        translated = GoogleTranslator(source='auto', target='en').translate(text)
        await ctx.send(f"🔄 翻譯結果：\n{translated}")
    except Exception as e:
        await ctx.send(f"❌ 翻譯失敗：{e}")

# 啟動機器人（後續把 Dockerfile 的 CMD 換成這個）
# bot.run(TOKEN)