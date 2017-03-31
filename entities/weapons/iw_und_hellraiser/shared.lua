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
	SWEP.PrintName = "Hellraiser"			
	SWEP.Author	= "ClavusElite"
	SWEP.Slot = 2
	SWEP.SlotPos = 1
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false
	
	SWEP.ShowWorldModel = false
	
	SWEP.IconLetter = "v"
	killicon.AddFont("iw_und_hellraiser", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255 ))
end

function SWEP:InitializeClientsideModels()
	
	self.VElements = {
		["thing2"] = { type = "Model", model = "models/Gibs/Antlion_gib_Large_3.mdl", bone = "v_weapon.galil", rel = "", pos = Vector(0, -1.425, 0.55), angle = Angle(160.725, 90, 4.275), size = Vector(0.107, 0.094, 0.172), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["thing"] = { type = "Model", model = "models/Gibs/Strider_Gib1.mdl", bone = "v_weapon.galil", rel = "", pos = Vector(0, 0.731, 3.111), angle = Angle(0, 90, 0), size = Vector(0.079, 0.079, 0.291), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} }
	}
	
	self.WElements = {
		["hellraiser"] = { type = "Model", model = "models/weapons/w_rif_galil.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["thing2"] = { type = "Model", model = "models/Gibs/Antlion_gib_Large_3.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "hellraiser", pos = Vector(5.168, -0.288, 5.888), angle = Angle(-75.031, 0, -180), size = Vector(0.107, 0.094, 0.172), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["thing"] = { type = "Model", model = "models/Gibs/Strider_Gib1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "hellraiser", pos = Vector(9.182, -0.357, 4.855), angle = Angle(-92.139, 0, 0), size = Vector(0.079, 0.079, 0.291), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} }
	}
	
end

SWEP.Base				= "iw_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_rif_galil.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_galil.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("HellRaiser.Single2")//Sound("npc/antlion/foot1.wav")
SWEP.Primary.Recoil			= 4
SWEP.Primary.Unrecoil		= 7
SWEP.Primary.Damage			= 3
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 20
SWEP.Primary.Delay			= 0.11
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize * 8
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"
SWEP.Primary.Cone			= 0.06
SWEP.Primary.ConeMoving		= 0.15
SWEP.Primary.ConeCrouching	= 0.04

SWEP.MuzzleEffect			= "rg_muzzle_rifle"
SWEP.ShellEffect 			= "none"

--SWEP.IronSightsPos = Vector(6.02,-3,2.3)
--SWEP.IronSightsAng = Vector(2.5,-.21,0)

function SWEP:AdditionalCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
		if ent:IsValid() and ent:IsPlayer() and SERVER then
			if ent:Team() == TEAM_HUMAN then
				ent:SetSuitPower( ent:SuitPower() - 15 )
			end
		end
end

function SWEP:ShootBullets1(dmg, numbul, cone)
	local bullet = {}
	bullet.Num = numbul
	bullet.Src = self.Owner:GetShootPos()
	bullet.Dir = self.Owner:GetAimVector()
	bullet.Spread = Vector(cone, cone, 0)
	bullet.Tracer = 1
	bullet.Force = dmg * 0.5
	bullet.Damage = dmg
	bullet.TracerName = "AR2Tracer"
	-- Drain suit power
	bullet.Callback = function ( attacker, tr, dmginfo )  
		if CLIENT then return end
		local ent = tr.Entity
		if ent:IsValid() and ent:IsPlayer() then
			if ent:Team() == TEAM_HUMAN then
				ent:SetSuitPower( ent:SuitPower() - 15 )
			end
		end
	end
	
	self.Owner:FireBullets(bullet)
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation(PLAYER_ATTACK1)
end