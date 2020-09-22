import discord, json
import json, discord, asyncio, time, os, sys, aiohttp, io
from discord.ext import commands
from itertools import cycle
from aioconsole import ainput
from halo import Halo
import logging
from config import Config
logger = logging.getLogger('discord')
logger.setLevel(logging.DEBUG)
handler = logging.FileHandler(filename='discord.log', encoding='utf-8', mode='w')
handler.setFormatter(logging.Formatter('%(asctime)s:%(levelname)s:%(name)s: %(message)s'))
logger.addHandler(handler)
global move_queue
move_queue = []

bot = commands.Bot(command_prefix='>')

async def discord_VoIP():
    await bot.wait_until_ready()
    print("> VoIP module loaded")
    guild = bot.get_guild(Config.guildid)
    while not bot.is_closed():
            if os.path.getsize('queue.json') > 10:
                try:
                    with open('queue.json', 'r') as f:
                            move_queue = json.load(f)
                    while len(move_queue) > 0:
                        y = []
                        for x in move_queue:
                            channel = bot.get_channel(x['channel_id'])
                            user = guild.get_member(x['member_id'])
                            try:
                                await user.move_to(channel)
                                print(f"{user} moved to {channel}")
                            except:
                                print(f"Failed to move {user} to {channel}") 
                            y.append(x)
                        [move_queue.remove(z) for z in y]
                        with open('queue.json', 'w') as f:
                            json.dump(move_queue, f, indent=4)
                except:
                    print("[QUEUE] Can't load queue.json!")

@bot.event
async def on_ready():
    print('Logged in as', bot.user)
    activity = discord.Activity(name='DiscordVoIP by Pitu7944#2711', type=discord.ActivityType.watching)
    await bot.change_presence(activity=activity)
    
@bot.command()
async def ping(ctx):
    await ctx.send('pong')

bot.loop.create_task(discord_VoIP())
bot.run(Config.botToken)

