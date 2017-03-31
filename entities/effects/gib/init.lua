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

EFFECT.Time = math.Rand(5, 10)	
/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
	if TOTALGIBS > 45 then return end
	TOTALGIBS = TOTALGIBS + 1
	
	// HumanGibs is defined in gamemode shared 
	// (because we need to precache the models on the server before we can use the physics)
	local iCount = table.Count( HumanGibs )
	
	// Use a random model from the gibs collection
	self.Entity:SetModel( HumanGibs[ math.random( iCount ) ] )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMaterial( "models/flesh" )
	
	self.Entity.IsGib = true
	
	// Only collide with world/static
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	self.Entity:SetCollisionBounds( Vector( -128 -128, -128 ), Vector( 128, 128, 128 ) )
	
	// Add Velocity
	local phys = self.Entity:GetPhysicsObject()
	if ( phys && phys:IsValid() ) then
	
		phys:Wake()
		phys:SetAngle( Angle( math.random(0,359), math.random(0,359), math.random(0,359) ) )
		phys:SetVelocity( (data:GetNormal() * 3/8 + VectorRand() * 1/4 + Vector(0,0,math.random(0,3)) * 3/8) *  math.random( 50, 200 ) )
	
	end
	
	// Gib life time
	self.Time = CurTime() + math.random(8, 15)

end


/*---------------------------------------------------------
   THINK
   Returning false makes the entity die
---------------------------------------------------------*/
function EFFECT:Think( )
	if TOTALGIBS > 45 then
		return false
	end
	if not EFFECT_UBERGORE or self.Time < CurTime() then
		TOTALGIBS = TOTALGIBS - 1
		return false
	end	
	return true
end


/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()
	
	self.Entity:DrawModel()

end



