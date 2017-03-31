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

ENT.Type = "anim"
ENT.PrintName = ""
ENT.Author = "ClavusElite"
ENT.Purpose	= ""

util.PrecacheModel("models/Gibs/HGIBS.mdl")

ENT.PlaceSound = Sound("npc/headcrab_poison/ph_talk1.wav")
ENT.SoundDeath = Sound("npc/headcrab_poison/ph_rattle1.wav")

function ENT:Team()
	return TEAM_UNDEAD
end