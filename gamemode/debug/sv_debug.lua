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

function DebugVector(start, vector, color)
	umsg.Start("Debug_Vector")
	umsg.Vector(start)
	umsg.Vector(vector)
	umsg.Vector(Vector(color.r, color.g, color.b))
	umsg.End()
end