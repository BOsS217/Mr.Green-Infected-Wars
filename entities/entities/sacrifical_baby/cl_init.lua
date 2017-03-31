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

local matPentagram 		= Material( "infectedwars/pentagram" )

function ENT:Name()
	return "< Sacrifical Baby >"
end

function ENT:Team()
	return TEAM_UNDEAD
end

function ENT:Initialize()
	self.emitter = ParticleEmitter( self.Entity:GetPos() )
end

function ENT:Think()
	
	self.endpos = self.Entity:GetDTVector( 0 )
	
	if not self.Entity:GetDTBool( 0 ) then return end
	local hp = self.Entity:GetDTFloat( 0 )
	
	-- Particle timer
	self.ParticleTimer = self.ParticleTimer or (CurTime()+0.01)
	if ( self.ParticleTimer <= CurTime() ) then 
		self.ParticleTimer = CurTime() + 0.01 + 0.02/hp
		-- Smoke effects
		local spawnPos = self.endpos+((math.random(0,25)/math.random(1,2))*(Vector(math.Rand(-1,1),math.Rand(-1,1),0):Normalize()))
		if self.emitter then -- make sure that the emitter was created
			local particle = self.emitter:Add( "particle/fire", spawnPos )
			particle:SetVelocity( Vector(0,0,15+math.random(0,10)) )
			particle:SetDieTime( 0.5 + math.Rand(0,0.5) + (hp/100) )
			particle:SetStartAlpha( math.Rand( 100, 150 ) )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( math.Rand( 5, 10 ) )
			particle:SetEndSize( math.Rand( 5, 10 ) )
			particle:SetRoll( math.Rand( -0.2, 0.2 ) )
			local ran = math.random(0,20)
			particle:SetColor( 255, 20+ran, 20+ran )
		end
	end

end

function ENT:OnRemove()
	self.emitter:Finish()
end

function ENT:Draw()

	self.Entity:DrawModel() 
	
	if not self.Entity:GetDTBool( 1 ) or not self.endpos then return end

	render.SetMaterial( matPentagram )
	
	local Size = 50 + 10*math.sin(CurTime())
	render.DrawQuadEasy( self.endpos, Vector(0,0,1), Size, Size, Color(255,255,255,255), 0 )
	local Jump = CurTime()%5*4
	render.DrawQuadEasy( self.endpos+Vector(0,0,Jump*1.5), Vector(0,0,1), 40, 40, Color(255,255,255,math.max(10-Jump,0)*(255/20)), 0 )
end

