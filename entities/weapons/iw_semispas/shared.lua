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

SWEP.HoldType = "shotgun"

if CLIENT then
	SWEP.PrintName = "Semi Spas-12"
	SWEP.Author	= "ClavusElite"
	SWEP.Slot = 3
	SWEP.SlotPos = 1
	
	
	SWEP.ReverseHands = true
	//fix some weird angles and such
	SWEP.OverrideAngle = {}
	SWEP.OverrideAngle["R_Wrist"] = Angle(0,180,90)
	SWEP.OverrideAngle["R_Forearm"] = Angle(0,180,180)
	
	SWEP.OverrideAngle["L_Forearm"] = Angle(0,180,180)
	SWEP.OverrideAngle["L_Wrist"] = Angle(0,180,90)
	
	SWEP.OverrideTranslation = {}
	//SWEP.OverrideTranslation["L_Forearm"] = Vector(0,0,0)
	SWEP.IgnoreThumbs = true
	
	SWEP.IconLetter = "0"
	SWEP.SelectFont = "HL2MPTypeDeath"
	killicon.AddFont("iw_semispas", SWEP.SelectFont, SWEP.IconLetter, Color(255, 80, 0, 255 ))
end

function SWEP:InitializeClientsideModels()
	
	self.VElements = {
		["ammo"] = { type = "Quad", bone = "body", rel = "", pos = Vector(-0.325, 0.805, 0.1), angle = Angle(0, 0, 175.705), size = 0.012, draw_func = function(wep) DrawWeaponInfo(wep) end}
	}

	self.WElements = {}
	
end
-- Derive from super90 shotgun
SWEP.Base				= "iw_m3super90"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_shot_shotteh01.mdl"
SWEP.WorldModel			= "models/weapons/infectedwars/w_shot_shotteh01.mdl"

SWEP.Weight				= 10
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("SEMISPASIW.Single2")//Sound("weapons/m3/shotteh-1.wav")
SWEP.Primary.Recoil			= 11
SWEP.Primary.Damage			= 13
SWEP.Primary.NumShots		= 10
SWEP.Primary.ClipSize		= 6
SWEP.Primary.Delay			= 0.95
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize*5
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "buckshot"
SWEP.Primary.Cone			= 0.15
SWEP.Primary.ConeMoving		= 0.21
SWEP.Primary.ConeCrouching	= 0.12

SWEP.MuzzleEffect			= "rg_muzzle_hmg"
SWEP.ShellEffect			= "rg_shelleject_shotgun" 

SWEP.Tracer 				= ""

--SWEP.IronSightsPos = Vector(5.73,-2,3.375)
--SWEP.IronSightsAng = Vector(0.001,.05,0.001)
