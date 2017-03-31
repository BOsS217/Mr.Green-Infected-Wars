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
	
	timer.Simple(8,function(ent)
		if IsValid(ent) then
			ent:Remove()
		end
	end,self.Entity)
end	

function ENT:Think()
	if self.nextheal < CurTime() then

		//local players = ents.FindInSphere(self.Entity:GetPos(), 150)
		local players = team.GetPlayers(TEAM_UNDEAD)
		for k, pl in pairs(players) do
			if pl:IsPlayer() and pl:Team() == TEAM_UNDEAD and pl:Alive() and self.Entity:GetPos():Distance(pl:GetPos()) <= 150 then
				local hpplus = 0
				if pl:HasBought("maliceabsorption2") then
					hpplus = 20
				elseif pl:HasBought("maliceabsorption1") then
					hpplus = 11
				end
				
				if hpplus > 0 then
					pl:SetHealth(math.min(pl:GetMaximumHealth(),pl:Health()+hpplus))
					
					local eff = EffectData()
						eff:SetOrigin(pl:GetPos())
					util.Effect( "demon_heal", eff )
				end
			end
		end
		self.nextheal = CurTime() + 2
	end
end

function ENT:OnRemove()
end
