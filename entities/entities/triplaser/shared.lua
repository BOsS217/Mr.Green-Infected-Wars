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

ENT.Type = "anim"
ENT.PrintName = ""
ENT.Author = "ClavusElite" -- Code based on trip mine from The Stalker made by Rambo_6 (aka Sechs)
ENT.Purpose	= ""

function ENT:Initialize()
	if SERVER then
		self.Entity:DrawShadow( false )
		self.Entity:SetSolid( SOLID_BBOX )
		self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
		self.Entity:SetTrigger( true )
	end
	self.at = CurTime() + 2
end


/*---------------------------------------------------------
---------------------------------------------------------*/
function ENT:SetEndPos( endpos )
	self.Entity:SetDTVector( 0, endpos )	
	self.Entity:SetCollisionBoundsWS( self.Entity:GetPos(), endpos, Vector() * 0.25 )
end


/*---------------------------------------------------------
---------------------------------------------------------*/
function ENT:GetEndPos()
	return self.Entity:GetDTVector( 0 )
end


/*---------------------------------------------------------
---------------------------------------------------------*/
function ENT:GetActiveTime()
	--return self.Entity:GetNetworkedFloat( "at" )
	return self.at
end
