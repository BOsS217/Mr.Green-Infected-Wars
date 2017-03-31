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
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

function ENT:Initialize()   
	self:PhysicsInit( SOLID_VPHYSICS )  
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:DrawShadow(false)
	self.Entity:SetSolid(SOLID_NONE)
end 

function ENT:Think()
	// Use own colors, but owner's alpha
	local pl = self:GetOwner():GetRagdollEntity() or self:GetOwner()
	local r,g,b,_ = self:GetColor()
	local _,_,_,a = pl:GetColor()
	
	// apparently it doesn't do this itself
	if (pl == self:GetOwner():GetRagdollEntity()) then
		a = 255
	end
	
	if (self:GetOwner().Dissolving or self:GetOwner().Gibbed) then
		a = 0
	end
	
	self:SetColor(r,g,b,a)
end

function ENT:CreateFromTable( suittable )
	
	self:SetModel(suittable.model)
	self:SetNWString("bone", suittable.bone)
	self:SetDTVector(0, suittable.pos)
	self:SetDTAngle(0, suittable.ang)
	self:SetDTVector(1, suittable.scale)
	
	if suittable.mat and suittable.mat ~= "" then
		self:SetMaterial(suittable.mat)
	end
	if suittable.color then
		self:SetColor( suittable.color.r, suittable.color.g, suittable.color.b, 255 )
	end
end