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

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function SWEP:UpdateHealScore( target, prevhp )

	ply = self.Owner
	// Give Green-Coins for healing
	self.healstack = self.healstack + math.max(0, target:Health() - prevhp)
	if self.healstack > 30 then
		self.healstack = 0
		ply:GiveGreenCoins( 1, "xY12xF@@" )
	end	

	ply:AddScore("humanshealed",2)
	ply.AmountHealed = ply.AmountHealed+2
	
	if ply.AmountHealed >= 200 then
		ply:UnlockAchievement("bloodbuddy")
	end
	if ply:GetScore("humanshealed") > 10000 then
		ply:UnlockAchievement("motherteresa")
		if ply:GetScore("humanshealed") > 50000 then
			ply:UnlockAchievement("soundofprogress")
		end
	end

end