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

include('shared.lua')

function ENT:Initialize()
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetNotSolid(true)	
	self.Entity:DrawShadow( false )
	
	self.nextheal = 0
end	

function ENT:Think()
	if !IsValid(self:GetOwner()) or !self:GetOwner():Alive() then
		self:Remove()
		return
	end
	self.Entity:SetPos(self:GetOwner():GetPos())
	if self.nextheal < CurTime() then
	
		local players = team.GetPlayers(TEAM_UNDEAD)
		//local players = ents.FindInSphere(self.Entity:GetPos(), 150)
		for k, pl in pairs(players) do
			if pl:IsPlayer() and pl != self:GetOwner() and pl:Team() == TEAM_UNDEAD and pl:Alive() and self.Entity:GetPos():Distance(pl:GetPos()) <= 150 then
				local hpplus = 5

				pl:SetHealth(math.min(pl:GetMaximumHealth(),pl:Health()+hpplus))
				
				local eff = EffectData()
					eff:SetOrigin(pl:GetPos())
				util.Effect( "demon_heal", eff )
			end
		end
		self.nextheal = CurTime() + 2
	end
end

function ENT:OnRemove()
end
