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

if SERVER then
	AddCSLuaFile("shared.lua")
end

SWEP.HoldType = "ar2"

if CLIENT then
	SWEP.PrintName = "FAMAS"
	SWEP.Author	= "ClavusElite"
	SWEP.Slot = 2
	SWEP.SlotPos = 1
	SWEP.IconLetter = "t"
	killicon.AddFont("iw_famas", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255 ))
end

function SWEP:InitializeClientsideModels()
	
	self.VElements = {
		["ammo"] = { type = "Quad", bone = "v_weapon.famas", rel = "", pos = Vector(0.768, -0.788, 12.105), angle = Angle(0, 180, 176.694), size = 0.012, draw_func = function(wep) DrawWeaponInfo(wep) end}
	}

	self.WElements = {}
	
end

SWEP.Base				= "iw_base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_rif_famas.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_famas.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("Weapon_FAMAS.Single")
SWEP.Primary.Recoil			= 1.1
SWEP.Primary.Unrecoil		= 11
SWEP.Primary.Damage			= 14
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 30
SWEP.Primary.Delay			= 0.11
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize * 6
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"
SWEP.Primary.Cone			= 0.06
SWEP.Primary.ConeMoving		= 0.11
SWEP.Primary.ConeCrouching	= 0.045

SWEP.MuzzleEffect			= "rg_muzzle_rifle"
SWEP.ShellEffect			= "rg_shelleject_rifle" 

--SWEP.IronSightsPos = Vector(-4,-3,1)
--SWEP.IronSightsAng = Vector(3,.5,4)