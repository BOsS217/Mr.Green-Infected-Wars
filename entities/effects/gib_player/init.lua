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

local NextEffect = 0

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
	local Pos = data:GetOrigin()
	local Normal = data:GetNormal()
	local ent = data:GetEntity()
	
	if not EFFECT_UBERGORE then return end
	
	//Prevent crashing
	if CurTime() < NextEffect then return end
	NextEffect = CurTime() + 0.2
	
	//for i= 0, 20 do
	
		//local effectdata = EffectData()
		//	effectdata:SetOrigin( Pos + i * Vector(0,0,3) + VectorRand() * 5 )
		//	effectdata:SetNormal( Normal )
		//util.Effect( "gore_bloodprop", effectdata )
		
	//end
	
	// Spawn Gibs
	for i = 0, math.random(3,12) do
	
		local effectdata = EffectData()
			effectdata:SetOrigin( Pos + i * Vector(0,0,6) + VectorRand() * 8 )
			effectdata:SetNormal( Normal )
		util.Effect( "gib", effectdata )
		
	end
	
	self.Emitter = ParticleEmitter(self.Entity:GetPos())

	for i=1, math.random(13,26) do
		local particle = self.Emitter:Add("effects/blood_core.vmt", Pos-Vector(0,0,20)+Vector(0,0,4)*i+VectorRand()*6)
		particle:SetVelocity(VectorRand()+Vector(0,0,-10)*math.Rand(0.1,1))
		particle:SetDieTime(math.Rand(4,6))
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(50)
		particle:SetStartSize(math.random(40,60))
		particle:SetEndSize(math.random(30,50))
		particle:SetRoll(math.Rand(0,3))
		particle:SetRollDelta(math.Rand(0,0.5))
		particle:SetColor(math.random(200,255), 0, 0)
		particle:SetLighting(true)
	end
	
	if ent:IsValid() then
		ent:EmitSound("physics/flesh/flesh_bloody_break.wav")
		
		local amount = ent:OBBMaxs():Length()
		local vel = ent:GetVelocity()
		util.Blood(ent:LocalToWorld(ent:OBBCenter()), math.Rand(amount * 0.25, amount * 0.5), vel:GetNormalized(), vel:Length() * 0.75)
		
	end
	
end


/*---------------------------------------------------------
   THINK
   Returning false makes the entity die
---------------------------------------------------------*/
function EFFECT:Think( )

	// Die instantly
	return false
	
end


/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()

	// Do nothing - this effect is only used to spawn the particles in Init
	
end



