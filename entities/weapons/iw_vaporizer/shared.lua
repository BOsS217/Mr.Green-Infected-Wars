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
	SWEP.PrintName = "Vaporizer Rifle"			
	SWEP.Slot = 2
	SWEP.SlotPos = 1
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60
	SWEP.IconLetter = "8"
	SWEP.SelectFont = "HL2MPTypeDeath"
	killicon.AddFont("iw_vaporizer", "HL2MPTypeDeath", SWEP.IconLetter, Color(255, 80, 0, 255 ))
end

function SWEP:InitializeClientsideModels()
	
	self.ViewModelBoneMods = {
		["Reload1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -13.625, 0) },
		["Claw2"] = { scale = Vector(2, 2, 2), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["Shell1"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["Claw1"] = { scale = Vector(2, 2, 2), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["Reload"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -11.775, 0) },
		["Vent"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["Bolt1"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["Bolt2"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["Shell2"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}

	
	self.VElements = {
		["ball1+"] = { type = "Model", model = "models/Effects/combineball.mdl", bone = "Shell2", rel = "", pos = Vector(0, 0, -0.47), angle = Angle(-90, 0, 0), size = Vector(0.079, 0.079, 0.079), color = Color(71, 197, 254, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["glow2"] = { type = "Sprite", sprite = "sprites/strider_blackball", bone = "Base", rel = "ball1+", pos = Vector(0, 0, 0), size = { x = 2.531, y = 2.531 }, color = Color(255, 255, 255, 255), nocull = true, additive = true, vertexalpha = false, vertexcolor = true, ignorez = false},
		["ball1"] = { type = "Model", model = "models/Effects/combineball.mdl", bone = "Shell1", rel = "", pos = Vector(0, 0, -1.101), angle = Angle(-90, 0, 0), size = Vector(0.079, 0.079, 0.079), color = Color(71, 197, 254, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["glow3"] = { type = "Sprite", sprite = "effects/redflare", bone = "Base", rel = "thing", pos = Vector(2.206, 0.206, 0.393), size = { x = 2.591, y = 2.591 }, color = Color(255, 255, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = true},
		["thing"] = { type = "Model", model = "models/Gibs/manhack_gib03.mdl", bone = "Bolt1", rel = "", pos = Vector(0.03, -0.506, -0.213), angle = Angle(-90, 0, 0), size = Vector(0.425, 0.425, 0.425), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["glow1"] = { type = "Sprite", sprite = "sprites/strider_blackball", bone = "Base", rel = "ball1", pos = Vector(0, 0, 0), size = { x = 2.287, y = 2.287 }, color = Color(255, 255, 255, 255), nocull = true, additive = true, vertexalpha = false, vertexcolor = true, ignorez = false}
	}
	
	self.WElements = {
		["ball1"] = { type = "Model", model = "models/Effects/combineball.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(15.625, 0.749, -6.763), angle = Angle(0, 0, 0), size = Vector(0.065, 0.065, 0.065), color = Color(71, 197, 254, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["glow3"] = { type = "Sprite", sprite = "effects/redflare", bone = "ValveBiped.Bip01_R_Hand", rel = "thing", pos = Vector(2.206, 0.206, 0.393), size = { x = 2.591, y = 2.591 }, color = Color(255, 255, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
		["glow1"] = { type = "Sprite", sprite = "sprites/strider_blackball", bone = "ValveBiped.Bip01_R_Hand", rel = "ball1", pos = Vector(0.4, 0, 0), size = { x = 2.049, y = 2.049 }, color = Color(255, 255, 255, 255), nocull = true, additive = true, vertexalpha = false, vertexcolor = true, ignorez = false},
		["thing"] = { type = "Model", model = "models/Gibs/manhack_gib03.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(9.029, 1.18, -6.369), angle = Angle(6.906, 180, -90), size = Vector(0.425, 0.425, 0.425), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
end

SWEP.Instructions = "Extreme power, dissolves enemies. Consumes suit power quick!" 

SWEP.Base				= "iw_pulserifle"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_IRifle.mdl"
SWEP.WorldModel			= "models/weapons/w_IRifle.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("PropJeep.FireChargedCannon")//Sound("weapons/gauss/fire1.wav")
SWEP.Primary.Recoil			= 16
SWEP.Primary.Unrecoil		= 6
SWEP.Primary.Damage			= 40
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= -1
SWEP.Primary.Delay			= 0.4
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Cone			= 0.022
SWEP.Primary.ConeMoving		= 0.08
SWEP.Primary.ConeCrouching	= 0.014

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.MuzzleEffect			= "rg_muzzle_rifle"

--SWEP.IronSightsPos = Vector(-4.5, -9.6, 3.1)
--SWEP.IronSightsAng = Vector(1.1, 0.6, -3.3)

SWEP.Drain = 12

function SWEP:ShootBullets(dmg, numbul, cone)
	local bullet = {}
	bullet.Num = numbul
	bullet.Src = self.Owner:GetShootPos()
	bullet.Dir = self.Owner:GetAimVector()
	bullet.Spread = Vector(cone, cone, 0)
	bullet.Tracer = 1
	bullet.Force = 0
	bullet.Damage = dmg
	bullet.TracerName = "AR2Tracer"
	
	-- Dissolve entity
	bullet.Callback = function ( attacker, tr, dmginfo )  
		local ent = tr.Entity
		if ent:IsValid() and ent:IsPlayer() and SERVER then
			if ent:Team() ~= attacker:Team() and not ent.God then
				ent.Dissolving = true
				timer.Simple( 0.05, function( ply )
					ply.Dissolving = false
				end,ent)
			end
		end
	end
	
	self.Owner:FireBullets(bullet)
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation(PLAYER_ATTACK1)
end


