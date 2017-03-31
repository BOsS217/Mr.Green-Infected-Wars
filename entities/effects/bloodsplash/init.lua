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

for i=1, 4 do
	util.PrecacheSound("physics/flesh/flesh_squishy_impact_hard"..i..".wav")
end

local NextEffect = 0

function EFFECT:Init(data)
	local Pos = data:GetOrigin()
	local Norm = data:GetNormal()
	
	if CurTime() < NextEffect then return end
	NextEffect = CurTime() + 0.2
	
	
	local LightColor = render.GetLightColor(Pos) * 255
	LightColor.r = math.Clamp( LightColor.r, 70, 255 )

	util.Decal("Blood", Pos + Norm*10, Pos - Norm*10)
	
	if math.random(0, 11) == 0 then
		WorldSound("physics/flesh/flesh_bloody_impact_hard1.wav", Pos, 80, math.random(75, 110))
	end

	if Norm.z < -0.5 then
		self.DieTime 		= CurTime() + 10
		self.Pos 			= Pos
		self.NextDrip 		= 0
		self.LastDelay		= 0
	end
end

local function CollideCallbackSmall(particle, hitpos, hitnormal)
if not particle.HitAlready then
		particle.HitAlready = true
	if math.random(1, 11) == 3 then
		WorldSound("ambient/water/rain_drip"..math.random(1,4)..".wav", hitpos, 90, math.random(95, 115))
	end
	util.Decal("Impact.Flesh", hitpos + hitnormal, hitpos - hitnormal)
	particle:SetDieTime(0)
end	
end

function EFFECT:Think()
	if not self.DieTime then return false end
	if self.DieTime < CurTime() then return false end
	if self.NextDrip > CurTime() then return true end
	
	self.LastDelay = self.LastDelay + math.Rand( 0.1, 0.2 )
	self.NextDrip = CurTime() + self.LastDelay
	
	local LightColor = render.GetLightColor( self.Pos ) * 255
		LightColor.r = math.Clamp( LightColor.r, 70, 255 )
	
	local emitter = ParticleEmitter(self.Pos)
		local RandVel = VectorRand() * 16
		RandVel.z = 0
		local particle = emitter:Add("effects/blooddrop.vmt", self.Pos + RandVel)
		if particle then
			particle:SetVelocity(Vector(0, 0, math.Rand(-300, -150)))
			particle:SetDieTime(math.Rand(3,5))
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(255)
			particle:SetStartSize(2)
			particle:SetEndSize(0)
			particle:SetColor( LightColor.r*0.5, 0, 0 )
			particle:SetCollide(true)
			particle:SetCollideCallback(CollideCallbackSmall)
			
		end
	emitter:Finish()

	return true
end

function EFFECT:Render()
end


//old
--[[
/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
	local Pos = data:GetOrigin()
	local Norm = data:GetNormal()
	
	local LightColor = render.GetLightColor( Pos ) * 255
		LightColor.r = math.Clamp( LightColor.r, 70, 255 )
		
	local emitter = ParticleEmitter( Pos )
	
		local particle = emitter:Add( "effects/blood_core", Pos )
			particle:SetVelocity( Norm )
			particle:SetDieTime( math.Rand( 1.0, 4.0 ) )
			particle:SetStartAlpha( 255 )
			particle:SetStartSize( math.Rand( 16, 32 ) )
			particle:SetEndSize( math.Rand( 32, 64 ) )
			particle:SetRoll( math.Rand( 0, 360 ) )
			particle:SetColor( LightColor.r*0.5, 0, 0 )
				
	emitter:Finish()

	util.Decal( "Blood", Pos + Norm*10, Pos - Norm*10 )
	
	if ( math.random( 0, 4 ) == 0 ) then
		// WorldSound is needed because EmitSound calls in Effects will sound omnipresent
		WorldSound( "physics/flesh/flesh_squishy_impact_hard"..math.random(1,4)..".wav", Pos, 80, math.Rand( 70, 140 ) )
	end
		
	// If we hit the ceiling drip blood randomly for a while
	if ( Norm.z < -0.5 ) then
	
		self.DieTime 		= CurTime() + 10
		self.Pos 			= Pos
		self.NextDrip 		= 0;
		self.LastDelay		= 0;
	
	end
	
end


/*---------------------------------------------------------
   THINK
   Returning false makes the entity die
---------------------------------------------------------*/
function EFFECT:Think( )

	if (!self.DieTime) then return false end
	if (self.DieTime < CurTime()) then return false end

	if (self.NextDrip > CurTime()) then return true end
	
	self.LastDelay = self.LastDelay + math.Rand( 0.1, 0.2 )
	self.NextDrip = CurTime() + self.LastDelay
	
	local LightColor = render.GetLightColor( self.Pos ) * 255
		LightColor.r = math.Clamp( LightColor.r, 70, 255 )
	
	local emitter = ParticleEmitter( self.Pos )
	
		local RandVel = VectorRand() * 16
		RandVel.z = 0
		
		local particle = emitter:Add( "effects/blooddrop", self.Pos + RandVel )
		if (particle) then
		
			particle:SetVelocity( Vector( 0, 0, math.Rand( -300, -150 ) ) )
			particle:SetDieTime( 1 )
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 255 )
			particle:SetStartSize( 2 )
			particle:SetEndSize( 0 )
			particle:SetColor( LightColor.r*0.5, 0, 0 )
			
		end
				
	emitter:Finish()

	
	return true
	
end


/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()

	// Do nothing - this effect is only used to spawn the particles in Init
	
end
]]


