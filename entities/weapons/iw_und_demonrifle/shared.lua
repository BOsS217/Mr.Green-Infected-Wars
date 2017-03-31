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
	SWEP.PrintName = "Demon Rifle"			
	SWEP.Author	= "ClavusElite"
	SWEP.Slot = 2
	SWEP.SlotPos = 1 
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = true
	
	SWEP.ShowWorldModel = false
	
	SWEP.IconLetter = "b"
	killicon.AddFont("iw_und_demonrifle", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255 ))
end

function SWEP:InitializeClientsideModels()
	
	self.ViewModelBoneMods = {
		["v_weapon.AK47_Bolt"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}
	
	self.VElements = {
		["thing"] = { type = "Model", model = "models/Gibs/Strider_Gib7.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(0, 2.437, 4.788), angle = Angle(95.944, 90, 0), size = Vector(0.123, 0.028, 0.054), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} }
	}
	self.WElements = {
		["demonrifle"] = { type = "Model", model = "models/weapons/w_rif_ak47.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["thing"] = { type = "Model", model = "models/Gibs/Strider_Gib7.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "demonrifle", pos = Vector(8.144, -0.294, 1.894), angle = Angle(0, 0, 0), size = Vector(0.123, 0.026, 0.054), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} }
	}
	
end

SWEP.Base				= "iw_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_rif_ak47.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_ak47.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("DemonRifle.Single2")//Sound("npc/ichthyosaur/snap.wav")
SWEP.Primary.Recoil			= 2
SWEP.Primary.Unrecoil		= 7
SWEP.Primary.Damage			= 13
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 16
SWEP.Primary.Delay			= 0.35
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize * 5
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "SMG1"
SWEP.Primary.Cone			= 0.04
SWEP.Primary.ConeMoving		= 0.1
SWEP.Primary.ConeCrouching	= 0.02

SWEP.MuzzleEffect			= "rg_muzzle_rifle"
SWEP.ShellEffect 			= "none"

--SWEP.IronSightsPos = Vector(6.02,-3,2.3)
--SWEP.IronSightsAng = Vector(2.5,-.21,0)