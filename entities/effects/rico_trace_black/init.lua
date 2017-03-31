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

	self.StartPos = data:GetStart()
	self.EndPos = data:GetOrigin()
	
	self.Alpha = 255
	self.Entity:SetRenderBoundsWS( self.StartPos, self.EndPos )
	
	WorldSound("Bullets.DefaultNearmiss", self.StartPos, 70, math.random(110, 180))

	
end

function EFFECT:Think( )

	self.Alpha = self.Alpha - FrameTime() * 256
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
					 Color( 255, 1, 1, self.Alpha ) )		// Color (optional)
	end

end