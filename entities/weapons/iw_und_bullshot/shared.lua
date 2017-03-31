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
	SWEP.PrintName = "Bullshot"			
	SWEP.Author	= "ClavusElite"
	SWEP.Slot = 2
	SWEP.SlotPos = 1
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = true
	
	SWEP.ShowWorldModel = false
	
	SWEP.IconLetter = "k"
	killicon.AddFont("iw_und_bullshot", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255 ))
end

function SWEP:InitializeClientsideModels()
	
	self.ViewModelBoneMods = {
		["v_weapon.M3_CHAMBER"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}

	
	self.VElements = {
		["thing"] = { type = "Model", model = "models/Gibs/gunship_gibs_midsection.mdl", bone = "v_weapon.M3_PARENT", rel = "", pos = Vector(0.013, 3.687, 4.331), angle = Angle(116.199, 90.494, 0), size = Vector(0.035, 0.021, 0.035), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["h1+++"] = { type = "Model", model = "models/Gibs/Antlion_gib_small_1.mdl", bone = "v_weapon.M3_PARENT", rel = "", pos = Vector(0.025, 4.098, 10.842), angle = Angle(-33.163, -90, 0), size = Vector(0.206, 0.128, 0.185), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["h1+"] = { type = "Model", model = "models/Gibs/Antlion_gib_small_1.mdl", bone = "v_weapon.M3_PARENT", rel = "", pos = Vector(0.025, 4.098, 13.685), angle = Angle(-33.163, -90, 0), size = Vector(0.206, 0.128, 0.185), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["h1++"] = { type = "Model", model = "models/Gibs/Antlion_gib_small_1.mdl", bone = "v_weapon.M3_PARENT", rel = "", pos = Vector(0.025, 4.098, 12.291), angle = Angle(-33.163, -90, 0), size = Vector(0.206, 0.128, 0.185), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["h1"] = { type = "Model", model = "models/Gibs/Antlion_gib_small_1.mdl", bone = "v_weapon.M3_PARENT", rel = "", pos = Vector(0.025, 4.098, 15.149), angle = Angle(-33.163, -90, 0), size = Vector(0.206, 0.128, 0.185), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	self.WElements = {
		["bullshot"] = { type = "Model", model = "models/weapons/w_shot_m3super90.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["thing"] = { type = "Model", model = "models/Gibs/gunship_gibs_midsection.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "bullshot", pos = Vector(7.006, -0.364, 5.568), angle = Angle(11.262, 180, 0), size = Vector(0.035, 0.021, 0.035), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["h1+++"] = { type = "Model", model = "models/Gibs/Antlion_gib_small_1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "bullshot", pos = Vector(19.136, -0.338, 5.611), angle = Angle(79.125, 180, 0), size = Vector(0.206, 0.165, 0.172), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["h1+"] = { type = "Model", model = "models/Gibs/Antlion_gib_small_1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "bullshot", pos = Vector(22.899, -0.338, 5.611), angle = Angle(79.125, 180, 0), size = Vector(0.206, 0.165, 0.172), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["h1++"] = { type = "Model", model = "models/Gibs/Antlion_gib_small_1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "bullshot", pos = Vector(20.981, -0.338, 5.611), angle = Angle(79.125, 180, 0), size = Vector(0.206, 0.165, 0.172), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["h1"] = { type = "Model", model = "models/Gibs/Antlion_gib_small_1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "bullshot", pos = Vector(24.794, -0.338, 5.611), angle = Angle(79.125, 180, 0), size = Vector(0.206, 0.165, 0.172), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
end

SWEP.Base				= "iw_base"

SWEP.Instructions	= "Primary fire can push your opponents away, secondary fire makes you launch yourself!" 

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_shot_m3super90.mdl"
SWEP.WorldModel			= "models/weapons/w_shot_m3super90.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("BULLSHOT.Single2")//Sound("npc/antlion/land1.wav")
SWEP.Primary.Recoil			= 9
SWEP.Primary.Unrecoil		= 7
SWEP.Primary.Damage			= 4
SWEP.Primary.NumShots		= 4
SWEP.Primary.ClipSize		= 10
SWEP.Primary.Delay			= 0.45
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize * 6
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"
SWEP.Primary.Cone			= 0.09
SWEP.Primary.ConeMoving		= 0.12
SWEP.Primary.ConeCrouching	= 0.072

SWEP.Secondary.Delay = 2

SWEP.MuzzleEffect			= "rg_muzzle_rifle"
SWEP.ShellEffect 			= "none"

--SWEP.IronSightsPos = Vector(-5.6, -6, 3.6)
--SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.NextReload = 0
SWEP.SecTimer = 0

function SWEP:Reload()
	--self:SetIronsights(false)
	
	if CurTime() < self.NextReload then return end
	self.NextReload = CurTime() + self.Primary.Delay * 2
	
	if self.Weapon:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
		self.Weapon:SetNetworkedBool( "reloading", true )
		self.Weapon:DefaultReload( ACT_VM_RELOAD )
		timer.Simple(0.4, self.Weapon.SendWeaponAnim, self.Weapon, ACT_SHOTGUN_RELOAD_FINISH)
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	end
end

function SWEP:ShootBullets(dmg, numbul, cone)
	local bullet = {}
	bullet.Num = numbul
	bullet.Src = self.Owner:GetShootPos()
	bullet.Dir = self.Owner:GetAimVector()
	bullet.Spread = Vector(cone, cone, 0)
	bullet.Tracer = 1
	bullet.Force = 100
	bullet.Damage = dmg
	bullet.TracerName = "black_tracer"
	bullet.Callback = function( attacker, tr, dmginfo )
		local ent = tr.Entity
		if ent and ent:IsValid() and ent:IsPlayer() and ent:Team() ~= attacker:Team() and SERVER then
			ent:SetVelocity(attacker:GetAimVector()*700)
		end
	end
	
	self.Owner:FireBullets(bullet)
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation(PLAYER_ATTACK1)
end

function SWEP:SecondaryAttack()

	if not self:CanPrimaryAttack() or self.SecTimer > CurTime() then return end
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.SecTimer = CurTime()+self.Secondary.Delay
	
	self.Weapon:EmitSound(self.Primary.Sound)
	
	self:TakePrimaryAmmo(1)
	
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation(PLAYER_ATTACK1)	
	
	if SERVER then
		self.Owner:SetVelocity((-1)*self.Owner:GetAimVector()*400)
	end

	self.Owner:ViewPunch(Angle(math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0))

	if CLIENT then
		//self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end
end

