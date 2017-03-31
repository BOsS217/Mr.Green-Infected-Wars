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

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 90))
end

function ENT:SetScaling()
		self.scale = self:GetDTVector(1)
		self:SetModelScale(self.scale)
end

function ENT:DrawTranslucent()  
	if (!IsValid(self:GetOwner())) then return end
	local dead = !self:GetOwner():Alive()
	local isself = (LocalPlayer() == self:GetOwner())
	if (isself and !dead) then return end

	self:SetScaling()
	
	local bonename = self:GetNWString("bone")
	if (bonename == "ValveBiped.Bip01_Head1" and isself) then return end 
	local ply = self:GetOwner():GetRagdollEntity() or self:GetOwner()
	local bone = ply:LookupBone(bonename)  
	if bone then  
		
		local position, angles = ply:GetBonePosition(bone)
		
		local localpos = self:GetDTVector(0)
		local localang = self:GetDTAngle(0)

		local newpos, newang = LocalToWorld( localpos, localang, position, angles ) 

		self:SetPos(newpos)  
		self:SetAngles(newang)  

		self:DrawModel()
	end 
	
end  

function ENT:Draw()
	self:DrawTranslucent()	
end

/*
for k, v in pairs(ents.FindByModel("models//gibs/hgibs.mdl")) do v:SetNWAngle("angles", Angle(0,0,0)) end
*/
