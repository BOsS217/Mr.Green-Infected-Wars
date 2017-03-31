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

-- This particular file may contain different code than the live version.

-- Metatable expanding
local meta = FindMetaTable("Player")
if meta then
	function meta:GreenCoins()
		if not self.GCData then
			return 0
		end

		return self.GCData["amount_current"] or 0
	end
	
	function meta:GetGreenCoins()
		return self:GreenCoins()
	end
end