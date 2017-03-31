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
	SWEP.PrintName = "G36"			
	SWEP.Slot = 2
	SWEP.SlotPos = 1
	SWEP.ViewModelFOV = 70
	
	//SWEP.IgnoreFingers = true
	SWEP.FlipYaw = true
	
	SWEP.OverrideAngle = {}
	SWEP.OverrideAngle["R_Forearm"] = Angle(0,0,10)
	
	SWEP.IconLetter = "o"
	killicon.Add( "iw_g36", "killicon/infectedwars/g36", Color(255, 80, 0, 255 ) )
end

function SWEP:InitializeClientsideModels()
	
	self.VElements = {
		["ammo"] = { type = "Quad", bone = "Body", rel = "", pos = Vector(-0.313, 3.224, -1.219), angle = Angle(0, 0, -96.845), size = 0.012, draw_func = function(wep) DrawWeaponInfo(wep) end}
	}

	self.WElements = {}
	
end

SWEP.Base				= "iw_scout" -- use zoom code from scout

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel				= "models/weapons/v_g36c_snipe.mdl"
SWEP.WorldModel				= "models/weapons/infectedwars/w_rif_g36.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("Weapon_SG550.Single")
SWEP.Primary.Recoil			= 1.8
SWEP.Primary.Unrecoil		= 8
SWEP.Primary.Damage			= 22
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 30
SWEP.Primary.Delay			= 0.13
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize * 5
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"
SWEP.Primary.Cone			= 0.045
SWEP.Primary.ConeMoving		= 0.07
SWEP.Primary.ConeCrouching	= 0.02
SWEP.Primary.OrigCone		= SWEP.Primary.Cone
SWEP.Primary.OrigConeMoving	= SWEP.Primary.ConeMoving
SWEP.Primary.OrigConeCrouching	= SWEP.Primary.ConeCrouching
SWEP.Primary.ZoomedCone		= 0.02
SWEP.Primary.ZoomedConeMoving = 0.06
SWEP.Primary.ZoomedConeCrouching = 0.012

SWEP.MuzzleEffect			= "rg_muzzle_rifle"
SWEP.ShellEffect			= "rg_shelleject_rifle" 
SWEP.EjectDelay				= 0.1

SWEP.IronSightsPos = Vector (3.5978, -3.9252, 0.5547)
SWEP.IronSightsAng = Vector (0, 0, 0)
