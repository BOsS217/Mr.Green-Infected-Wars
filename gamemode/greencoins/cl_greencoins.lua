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

-- This particular file may contain different code than the live version.

include("sh_greencoins.lua")

function ReceiveGC(um)
	local tab = {}
	tab["amount_current"] = um:ReadLong()

	LocalPlayer().GCData = tab
end
usermessage.Hook("SendGC",ReceiveGC)

function DrawGC()
	local MySelf = LocalPlayer()
	if not (MySelf:IsValid() and MySelf.Class and MySelf.Class ~= 0) then return end
	if ENDROUND then return end
	local coins = MySelf:GreenCoins()
	draw.RoundedBox(5, 3, 120, 200, 24, Color(0, 0, 0, 180))
	local drawcol = Color(115,160,150,185)
	draw.DrawText("GreenCoins: "..coins, "InfoSmall", 10, 124, drawcol, TEXT_ALIGN_LEFT)
	draw.DrawText("GreenCoins: "..coins, "InfoSmall", 10, 124, drawcol, TEXT_ALIGN_LEFT)
end
--hook.Add("HUDPaint", "DrawGreenCoins", DrawGC)