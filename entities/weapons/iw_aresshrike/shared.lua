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
	SWEP.PrintName = "Ares Shrike"			
	SWEP.Slot = 2
	SWEP.SlotPos = 1
	SWEP.IconLetter = "z"
	SWEP.ViewModelFlip = false
	
	SWEP.OverrideAngle = {}
	SWEP.OverrideAngle["L_Forearm"] = Angle(0,0,10)
	
	killicon.Add( "iw_aresshrike", "killicon/infectedwars/aresshrike", Color(255, 80, 0, 255 ) )
end

function SWEP:InitializeClientsideModels()
	
	self.VElements = {
		["ammo"] = { type = "Quad", bone = "Cylinder16", rel = "", pos = Vector(0.349, -1.163, 0.481), angle = Angle(0, 180, 166.319), size = 0.012, draw_func = function(wep) DrawWeaponInfo(wep) end}
	}

	self.WElements = {}
	
end

SWEP.Base				= "iw_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_ares_shrikesb.mdl"
SWEP.WorldModel			= "models/weapons/infectedwars/w_ares_shrikesb.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("Ares.Single2")//Sound("weapons/m249/ares_shrike-2.wav")
SWEP.Primary.Recoil			= 3.2
SWEP.Primary.Unrecoil		= 9
SWEP.Primary.Damage			= 13
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 100
SWEP.Primary.Delay			= 0.09
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize * 3
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"
SWEP.Primary.Cone			= 0.05
SWEP.Primary.ConeMoving		= 0.14
SWEP.Primary.ConeCrouching	= 0.035

SWEP.MuzzleEffect			= "rg_muzzle_rifle"
SWEP.ShellEffect			= "rg_shelleject_rifle" 

if CLIENT then
	local ares = surface.GetTextureID("killicon/infectedwars/aresshrike")
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		 
		surface.SetDrawColor( Color( 255, 210, 0, 255 ))
		surface.SetTexture(ares)
		surface.DrawTexturedRect(x+wide/2-(wide*0.5)/2,y+tall/2-(tall*0.6)/2,wide*0.5,tall*0.6)
		
		// Draw weapon info box
		self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )
	end
end
--SWEP.IronSightsPos = Vector(-4.49,-2,2.15)
--SWEP.IronSightsAng = Vector(.00001,-.06,.00001)