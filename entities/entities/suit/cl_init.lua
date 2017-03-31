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

include("shared.lua")

function ENT:Draw()  
	return false	
end  

function ENT:Think()
	if IsValid(self:GetOwner()) then
		self:GetOwner().EquipedSuit = self:GetNWString("suitname")
	end
end
function ENT:OnRemove()
	if IsValid(self:GetOwner()) then
		self:GetOwner().EquipedSuit = nil
	end
end