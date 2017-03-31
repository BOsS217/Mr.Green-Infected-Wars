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

EFFECT.Mat = Material( "effects/infectedwars/black_tracer" )

function EFFECT:Init( data )

	self.Position = data:GetStart()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	// Keep the start and end pos - we're going to interpolate between them
	self.StartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )
	self.EndPos = data:GetOrigin()
	
	self.Alpha = 255

end

function EFFECT:Think( )

	self.Alpha = self.Alpha - FrameTime() * 4048
	
	self.StartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )
	self.Entity:SetRenderBoundsWS( self.StartPos, self.EndPos )
	
	if (self.Alpha < 0) then return false end
	return true

end

function EFFECT:Render( )

	if ( self.Alpha < 1 ) then return end
	
	self.Length = (self.StartPos - self.EndPos):Length()
		
	render.SetMaterial( self.Mat )
	local texcoord = math.Rand( 0, 1 )
	
	
	for i=1, 6 do
		render.DrawBeam( self.StartPos, 										// Start
					 self.EndPos,											// End
					 3,													// Width
					 texcoord,														// Start tex coord
					 texcoord + self.Length / 128,									// End tex coord
					 Color( 255, 255, 255, self.Alpha ) )		// Color (optional)
	end

end
