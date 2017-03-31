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

if SERVER then AddCSLuaFile( "shared.lua" ) end

//Melee base
SWEP.Base = "iw_base_melee"

//Models paths
SWEP.Author = "NECROSSIN"
SWEP.ViewModel = Model ( "models/weapons/v_knife_t.mdl"  )
SWEP.WorldModel = Model ( "models/weapons/w_knife_t.mdl"  )

//Name and fov
SWEP.PrintName = "Knife"
SWEP.ViewModelFOV = 57

//Position
SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.HoldType = "knife"

SWEP.MeleeDamage = 20
SWEP.MeleeRange = 50
SWEP.MeleeSize = 0.875

SWEP.Primary.Delay = 0.55

SWEP.HitDecal = "Manhackcut"

SWEP.HitGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE
SWEP.MissGesture = SWEP.HitGesture

SWEP.NoHitSoundFlesh = true

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/knife/knife_slash"..math.random(1, 2)..".wav")
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/knife/knife_hitwall1.wav")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("weapons/knife/knife_hit"..math.random(1, 4)..".wav")
end

//Killicon
if CLIENT then 
SWEP.IconLetter = "j"
killicon.AddFont("iw_und_undeadknife", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255))
SWEP.ShowViewModel = true
//SWEP.IgnoreFingers = true
//SWEP.FlipYaw = true
end

if CLIENT then
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		draw.SimpleText( "j", "CSSelectIcons", x + wide/2, y + tall*0.3, Color( 255, 210, 0, 255 ), TEXT_ALIGN_CENTER )
	end
end
 

function SWEP:Precache()
	util.PrecacheSound("weapons/knife/knife_slash1.wav")
	util.PrecacheSound("weapons/knife/knife_slash2.wav")
end
