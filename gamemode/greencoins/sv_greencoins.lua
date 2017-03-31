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

-- This particular file may contain different code than the live version

AddCSLuaFile("sh_greencoins.lua")
AddCSLuaFile("cl_greencoins.lua")
include("sh_greencoins.lua")

-- Debug setting
local DEBUG = false

-- Deluvas; lol :V
function GM:GetFirstKey(iCode)
	return 0
end

-- Metatable expanding
local meta = FindMetaTable("Player")
if meta then
	function meta:GiveGreenCoins(amount, hash)
	end
	
	function meta:TakeGreenCoins(amount, hash)
	end
	
	-- Save GC
	function meta:SaveGreenCoins()
	end
end

function GM:SendCoins(pl, amount)
	if not pl.GCData then
		return
	end

	umsg.Start("SendGC", pl)
	umsg.Long(pl.GCData["amount_current"])
	umsg.End()	
	
	--Coin effect
	if amount then
		umsg.Start("CoinEffect", pl)
		umsg.Short(amount)
		umsg.End()
	end
end