--[[-----------------------------------------------------------------------------
 * Infected Wars, an open source Garry's Mod game-mode.
 *
 * Infected Wars is the work of multiple authors,
 * a full list can be found in CONTRIBUTORS.md.
 * For more information, visit https://github.com/JarnoVgr/InfectedWars
 *
 * Infected Wars is free software: you can redistribute it and/or modify
 * it under the terms of the MIT License.
 *
 * A full copy of the MIT License can be found in LICENSE.txt.
 -----------------------------------------------------------------------------]]


--[[------------------------------------
Server-only options, so you don't 
need to update your client cache constantly
------------------------------------]]

--TODO: Move to cvars

-- Round time in seconds (example: 15 x 60 makes 15 minutes)
ROUNDLENGTH = 15 * 60

-- Maximum rounds per map before next map is forced
MAX_ROUNDS_PER_MAP = 3

-- Between the end of the round and the next map
INTERMISSIONTIME = 30

-- How many seconds after round start can players still join human team when they join?
-- For obvious reasons, never make this larger than ROUNDTIME
HUMAN_JOINTIME = ROUNDLENGTH/3

-- Amount of reinforcements the undead have. Base number + increment per human player
-- If reinforcements reach 0, the humans win the round.
UNDEAD_REINFORCEMENTS = 50
UNDEAD_REINFORCEMENTS_INCREMENT_PER_PLAYER = 5

-- Amount of seconds players have spawn protection
SPAWN_PROTECTION = 7

-- Amount of seconds before a killed zombie player is allowed to respawn, 
-- always keep this more than 1
SPAWNTIME = 4

-- Amount of seconds before player can use roll the dice again
RTD_TIME = 180

-- Ammo droprate of zombies, the lower the number, the higher the chance 
-- (ex: 5 = random(1,5) chance, 1 = random(1,1) chance = always). USE ROUND NUMBERS.
AMMO_DROPRATE = 3

--Amount of seconds before ammo dissapears (anti-lag purpose)
AMMO_CLEANUP = 80//70

-- enable or disable gore on the entire server
GORE_MOD = true

-- Amount of times a behemoth player is allowed to die before being switched to another class
BEHEMOTH_DEATH_LIMIT = 10

--Amount of time when humans cant suicide
NOSUICIDE_TIME = 160

-- Mapcycle. Goes from top to bottom. Chooses 1st map when the current map is not
-- in the list. It also checks if the minimum and maximum values match the current
-- amount of players.
-- Maps will be played in the order you add them!
-- You can NOT add maps twice or it'll mess up the system!
MAPCYCLE = {}
local function AddMap( name, minpl, maxpl )
	tab = { map = name, minplayers = minpl, maxplayers = maxpl }
	table.insert(MAPCYCLE,tab)
end


--Mr. Green maplist
AddMap("cs_assault", 0, 99 )
AddMap("cs_apartments", 0, 99 )
AddMap("dm_iw_metalgrounds", 22, 99 )
AddMap("de_residentevil2_final", 0, 99 )
AddMap("de_industry", 0, 99 )
AddMap("cs_churchS", 0, 10 )
AddMap("dm_abyss", 0, 99 )
AddMap("dm_striker", 0, 99 )
AddMap("de_port", 10, 99 )
AddMap("de_menace_final", 0, 99 )
AddMap("de_piranesi", 0, 99 )
AddMap("cs_code_name_otter_packed", 0, 10 )
AddMap("cs_office2008", 0, 99 )
AddMap("dm_outlying_v2", 0, 99 )
AddMap("dm_steamlab", 0, 22 )
AddMap("de_nuke", 0, 99 )
AddMap("de_nightfever", 0, 99 )
AddMap("dm_democracy", 6, 99 )
AddMap("cs_wolfenstein", 12, 99 )
AddMap("dm_balcony_beta4", 0, 22 )
AddMap("dm_powerhouse", 0, 99 )
AddMap("dm_biohazard", 0, 99 )
AddMap("cs_desperados", 19, 99 )
AddMap("dm_underpass", 0, 99 )
AddMap("ad_egon_world", 8, 99 )
AddMap("de_prodigy", 0, 99 )
AddMap("de_train", 0, 99 )
AddMap("cs_gentech_final", 6, 99 )
AddMap("dm_resistance", 0, 99 )
AddMap("dm_waterworks", 14, 99 )
AddMap("dm_runoff", 0, 99 )
AddMap("dm_plaza17", 0, 99 )
AddMap("css_galleria", 0, 99 )
--AddMap( "De_Crypt_CN_v1_ex", 8, 99 )
AddMap("dm_lockdown", 0, 99 )
AddMap("cs_pariah", 0, 99 )
AddMap("de_cbble", 14, 99 )
AddMap("cs_harborbank", 6, 99 )
AddMap("cs_italy", 0, 99 )
AddMap("de_farpoint_b1", 0, 99 )
AddMap("de_alivemetal", 0, 10 )
AddMap("de_chateau", 0, 99 )
AddMap("dm_avalon", 0, 99 )
AddMap("de_abbaye_premium_beta_v10", 0, 99 )
AddMap("de_aztec", 0, 99 )
AddMap("de_dust", 0, 99 )
--AddMap("de_dust2", 0, 99 )

-- Server news. Add whatever you like. Things like: "OMG YOU LIEK MUDKIPZ?"
NEWS = {}
NEWS[1] = "New to this gamemode? READ THE HELP FILE, you'll find it useful! (press F1)"
NEWS[2] = "The Green-Coins shop has opened! Access the menu (F1) and press the shop button!"
NEWS[3] = "Hold your Use key to select a power!"
NEWS[4] = "Press F1 for help topics and more detailed information! ---> There's also a changelog! <---"
NEWS[5] = "Press F2 to change class!"
NEWS[6] = "Press F4 to view the stats and achievements of you and other players!"
NEWS[7] = "Report any bugs on our bugtracker at bugs.left4green.com!"
NEWS[8] = "Type '!rtd' to Roll The Dice and see if lady luck smiles upon you!"
NEWS[9] = "Join the Mr. Green Steam community! http://steamcommunity.com/groups/mrgreen"

NEWSTIMER = 45 -- amount of seconds between each news display, set to -1 if you don't want news being displayed
