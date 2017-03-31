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

util.PrecacheSound("physics/flesh/flesh_bloody_impact_hard1.wav")
util.PrecacheSound("physics/flesh/flesh_squishy_impact_hard1.wav")
util.PrecacheSound("physics/flesh/flesh_squishy_impact_hard2.wav")
util.PrecacheSound("physics/flesh/flesh_squishy_impact_hard3.wav")
util.PrecacheSound("physics/flesh/flesh_squishy_impact_hard4.wav")

local function CollideCallback(particle, hitpos, hitnormal)
	if not particle.HitAlready then
		particle.HitAlready = true

		local pos = hitpos + hitnormal

		if math.random(1, 3) == 3 then
			WorldSound("physics/flesh/flesh_squishy_impact_hard"..math.random(1,4)..".wav", hitpos, 50, math.random(95, 105))
		end

		util.Decal("Blood", pos, hitpos - hitnormal)

		particle:SetDieTime(0)
	end
end

function EFFECT:Init(data)
	local Pos = data:GetOrigin() + Vector(0,0,10)

	local emitter = ParticleEmitter(Pos)
	for i=1, data:GetMagnitude() do
		local particle = emitter:Add("decals/blood_spray"..math.random(1,8), Pos + VectorRand() * 8)
		particle:SetVelocity(VectorRand():Normalize() * math.random(90, 175) + Vector(0,0,80))
		particle:SetDieTime(math.Rand(3, 6))
		particle:SetStartAlpha(230)
		particle:SetEndAlpha(230)
		particle:SetStartSize(math.Rand(10, 14))
		particle:SetEndSize(10)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-20, 20))
		particle:SetAirResistance(5)
		particle:SetBounce(0)
		particle:SetGravity(Vector(0, 0, -600))
		particle:SetCollide(true)
		particle:SetCollideCallback(CollideCallback)
		particle:SetLighting(true)
		particle:SetColor(255, 0, 0)
	end
	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end


//old
// All Garry's code down here, just a few tweaks from me
--[[
local BloodSprite = Material( "effects/bloodstream" )

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )

		// Table to hold particles
		self.Particles = {}
		
		self.PlaybackSpeed 	= math.Rand( 2, 5 )
		self.Width 			= math.Rand( 2, 16 )
		self.ParCount		= 8
		
		local Dir = VectorRand() * 1/4 + data:GetNormal() * 1/2 + Vector( 0, 0, math.random(0,4)) * 1/4
		
		local Speed = math.Rand( 300, 1500 )
		
		local SquirtDelay = math.Rand( 3, 5 )
		
		Dir.z = math.max( Dir.z, Dir.z * -1 )
		if (Dir.z > 0.5) then
			Dir.z = Dir.z - 0.3
		end
		
		for i=1, math.random( 4, 8 ) do
		
			Dir = Dir * 0.95 + VectorRand() * 0.02
		
			local p = {}
			
				p.Pos = data:GetOrigin()
				p.Vel = Dir * (Speed * (i /16))
				p.Delay = (16 - i)  * SquirtDelay
				p.Rest = false
			
			table.insert( self.Particles, p )
		
		end

		self.NextThink = CurTime() +  math.Rand( 0, 1 )
	
end


local function VectorMin( v1, v2 )
	
	if ( v1 == nil ) then return v2 end
	if ( v2 == nil ) then return v1 end
	
	local vr = Vector( v2.x, v2.y, v2.z )
	
	if ( v1.x < v2.x ) then vr.x = v1.x end
	if ( v1.y < v2.y ) then vr.y = v1.y end
	if ( v1.z < v2.z ) then vr.z = v1.z end
	
	return vr

end

local function VectorMax( v1, v2 )
	
	if ( v1 == nil ) then return v2 end
	if ( v2 == nil ) then return v1 end
	
	local vr = Vector( v2.x, v2.y, v2.z )
	
	if ( v1.x > v2.x ) then vr.x = v1.x end
	if ( v1.y > v2.y ) then vr.y = v1.y end
	if ( v1.z > v2.z ) then vr.z = v1.z end
	
	return vr

end

/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think( )

	if not EFFECT_UBERGORE then return false end
	//if ( self.NextThink > CurTime() ) then return true end

	local FrameSpeed = self.PlaybackSpeed * FrameTime()
	
	local bMoved = false
	local min = self.Entity:GetPos()
	local max = min
	
	self.Width = self.Width - 0.7 * FrameSpeed
	if ( self.Width < 0 ) then
		return false
	end
	
	for k, p in pairs( self.Particles ) do
	
			if ( p.Rest ) then
									
			// Waiting to be spawned. Some particles have an initial delay 
			// to give a stream effect..
			elseif ( p.Delay > 0 ) then
			
				p.Delay = p.Delay - 100 * FrameSpeed
			
			// Normal movement code. Handling particles in Lua isn't great for 
			// performance but since this is clientside and only happening sometimes
			// for short periods - it should be fine.
			else
				
				// Gravity
				p.Vel:Sub( Vector( 0, 0, 60 * FrameSpeed ) )
				
				// Air resistance
				p.Vel.x = math.Approach( p.Vel.x, 0, 2 * FrameSpeed )
				p.Vel.y = math.Approach( p.Vel.y, 0, 2 * FrameSpeed )
				
				local trace = {}
				trace.start 	= p.Pos
				trace.endpos 	= p.Pos + p.Vel * FrameSpeed
				trace.mask 		= MASK_NPCWORLDSTATIC
				local tr = util.TraceLine( trace )

				if (tr.Hit) then
								
					tr.HitPos:Add( tr.HitNormal * 2 )
					
					local effectdata = EffectData()
						effectdata:SetOrigin( tr.HitPos )
						effectdata:SetNormal( tr.HitNormal )
					util.Effect( "bloodsplash", effectdata )
					
					// If we hit the ceiling just stunt the vertical velocity
					// else enter a rested state
					if ( tr.HitNormal.z < -0.75 ) then
					
						p.Vel.z = 0
					
					else
					
						p.Rest = true
					
					end
		
				end
				
				// Add velocity to position
				p.Pos = tr.HitPos
				bMoved = true
			
			end
			
	end
	
	self.ParCount = table.Count( self.Particles )
	
	
	// I really need to make a better/faster way to do this
	if (bMoved) then
	
		for k, p in pairs( self.Particles ) do
		
			min = VectorMin( min, p.Pos )
			max = VectorMax( max, p.Pos )
			
		end

		local Pos = min + ((max - min) * 0.5)
		self.Entity:SetPos( Pos )
		self.Entity:SetCollisionBounds( Pos - min, Pos - max )
	end
	
	
	// Returning false kills the effect
	return (self.ParCount > 0)
	
end


/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()

	render.SetMaterial( BloodSprite )
	
	local LastPos = nil
	local pCount = 0
	
	// I don't know what kind of performance hit this gives us..
	local LightColor = render.GetLightColor( self.Entity:GetPos() ) * 255
		LightColor.r = math.Clamp( LightColor.r, 70, 255 )
	local color = Color( LightColor.r*0.5, 0, 0, 255 )

	for k, p in pairs( self.Particles ) do
	
		local Sin = math.sin( (pCount / (self.ParCount-2)) * math.pi )
		
		if ( LastPos ) then
		
			render.DrawBeam( LastPos, 		
					 p.Pos,
					 self.Width * Sin,					
					 1,					
					 0,				
					 color )
		
		end
		
		pCount = pCount + 1
		LastPos = p.Pos
	
	end
	
	
	//render.DrawSprite( self.Entity:GetPos(), 32, 32, color_white )
	
end
]]


