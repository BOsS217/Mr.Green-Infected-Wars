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
	SWEP.PrintName = "'Hellfire' IMI Galil"			
	SWEP.Slot = 2
	SWEP.SlotPos = 1
	SWEP.IconLetter = "v"
	
	SWEP.ViewModelFlip = false
	
	/*SWEP.IgnoreThumbs = true
	
	SWEP.OverrideTranslation = {}
	SWEP.OverrideTranslation["v_weapon.Right_Hand"] = Vector(-1.2,0,0)
	*/
	SWEP.OverrideAngle = {}
	SWEP.OverrideAngle["v_weapon.Left_Arm"] = Angle(0,0,-90)
	
	killicon.AddFont("iw_galil", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255 ))
end

function SWEP:InitializeClientsideModels()
	
	self.VElements = {
		["ammo"] = { type = "Quad", bone = "v_weapon.galil", rel = "", pos = Vector(1.194, -0.369, 3.926), angle = Angle(0, 180, 174.35), size = 0.012, draw_func = function(wep) DrawWeaponInfo(wep) end}
	}

	self.WElements = {}
	
end



SWEP.Base				= "iw_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/v_rif_galil.mdl" )
SWEP.WorldModel			= Model ( "models/weapons/w_rif_galil.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("Weapon_Galil.Single")
SWEP.Primary.Recoil			= 3
SWEP.Primary.Unrecoil		= 8
SWEP.Primary.Damage			= 15.5
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 30
SWEP.Primary.Delay			= 0.09
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize * 5
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"
SWEP.Primary.Cone			= 0.055
SWEP.Primary.ConeMoving		= 0.12
SWEP.Primary.ConeCrouching	= 0.031

SWEP.MuzzleEffect			= "rg_muzzle_rifle"
SWEP.ShellEffect			= "rg_shelleject_rifle" 

function SWEP:AdditionalCallback(attacker, tr, dmginfo)
	local pos = tr.HitPos
	local ent = tr.Entity
	
	if pos then
		if IsValid(ent) and SERVER and math.random(2) == 1 then
			local dmginfo = DamageInfo()
			dmginfo:SetDamagePosition(pos)
			dmginfo:SetDamage(math.random(1,3))
			dmginfo:SetAttacker(attacker)
			dmginfo:SetInflictor(self.Weapon)
			dmginfo:SetDamageType(DMG_BURN)
			dmginfo:SetDamageForce(self.Primary.Damage * 200 * attacker:GetAimVector()) 
			
			ent:TakeDamageInfo(dmginfo) 
		end
	end
	
end


--SWEP.IronSightsPos = Vector(5.1, -4, 1.5)
--SWEP.IronSightsAng = Vector(0,0,0)