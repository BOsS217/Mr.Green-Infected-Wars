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

SWEP.HoldType = "smg"

if CLIENT then
	SWEP.PrintName = "P90"			
	SWEP.Slot = 2
	SWEP.SlotPos = 1
	SWEP.IconLetter = "m"
	killicon.AddFont("iw_p90", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255 ))
	
	SWEP.ShowWorldModel = false
	
end

function SWEP:InitializeClientsideModels()
	
	self.VElements = {
		["ammo"] = { type = "Quad", bone = "v_weapon.p90_Parent", rel = "", pos = Vector(-0.45, 3.482, 0.5), angle = Angle(0, 0, 168.561), size = 0.012, draw_func = function(wep) DrawWeaponInfo(wep) end}
	}

	self.WElements = {
		["p90"] = { type = "Model", model = "models/weapons/w_smg_p90.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.419, 0, -0.419), angle = Angle(-11.089, 0, 180), size = Vector(0.912, 0.912, 0.912), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
end

SWEP.Base				= "iw_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_smg_p90.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_p90.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("Weapon_P90.Single")
SWEP.Primary.Recoil			= 1.25
SWEP.Primary.Unrecoil		= 7
SWEP.Primary.Damage			= 9
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 50
SWEP.Primary.Delay			= 0.06
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize * 5
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"
SWEP.Primary.Cone			= 0.06
SWEP.Primary.ConeMoving		= 0.16
SWEP.Primary.ConeCrouching	= 0.05

SWEP.MuzzleEffect			= "rg_muzzle_rifle"
SWEP.ShellEffect			= "rg_shelleject" 

--SWEP.IronSightsPos = Vector(3.7, -5.4, 2.8)
--SWEP.IronSightsAng = Vector(0.6, -1.4, -1.5)