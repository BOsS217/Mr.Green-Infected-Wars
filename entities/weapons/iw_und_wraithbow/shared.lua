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

SWEP.HoldType = "crossbow"

if CLIENT then
	SWEP.PrintName = "Wraith Bow"			
	SWEP.Author	= "ClavusElite"
	SWEP.Slot = 2
	SWEP.SlotPos = 1
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false

	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false
	SWEP.AlwaysDrawViewModel = true
	SWEP.IgnoreBonemerge = true
	//SWEP.UseHL2Bonemerge = true
	
	SWEP.IconLetter = "1"
	SWEP.SelectFont = "HL2MPTypeDeath"
	killicon.AddFont("iw_und_wraithbow", "HL2MPTypeDeath", SWEP.IconLetter, Color(255, 80, 0, 255 ))
end

function SWEP:InitializeClientsideModels()
	
	self.ViewModelBoneMods = {
		["Crossbow_model.bolt"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}

	self.VElements = {
		["tasty"] = { type = "Model", model = "models/Gibs/HGIBS_spine.mdl", bone = "Crossbow_model.bolt", rel = "", pos = Vector(0, -0.201, -0.069), angle = Angle(0, 0, -5.401), size = Vector(0.574, 0.574, 1.496), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["left+"] = { type = "Model", model = "models/Gibs/Strider_Left_Leg.mdl", bone = "Crossbow_model.Crossbow_base", rel = "", pos = Vector(-3.356, 5.618, 25.85), angle = Angle(167.255, -105.982, -0.687), size = Vector(0.054, 0.054, 0.054), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["right"] = { type = "Model", model = "models/Gibs/Strider_Right_Leg.mdl", bone = "Crossbow_model.Crossbow_base", rel = "", pos = Vector(-4.225, 4.205, 25.837), angle = Angle(9.744, 42.588, -180), size = Vector(0.054, 0.054, 0.054), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["left"] = { type = "Model", model = "models/Gibs/Strider_Left_Leg.mdl", bone = "Crossbow_model.Crossbow_base", rel = "", pos = Vector(6.275, 4.031, 25.419), angle = Angle(167.255, -25.701, -0.687), size = Vector(0.054, 0.054, 0.054), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["right+"] = { type = "Model", model = "models/Gibs/Strider_Right_Leg.mdl", bone = "Crossbow_model.Crossbow_base", rel = "", pos = Vector(2.055, 4.443, 25.837), angle = Angle(9.744, 103.531, -180), size = Vector(0.054, 0.054, 0.054), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	self.WElements = {
		["right+"] = { type = "Model", model = "models/Gibs/Strider_Right_Leg.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(28.83, -11.801, -0.151), angle = Angle(0.187, -65.846, 93.617), size = Vector(0.054, 0.054, 0.054), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["wrathbow"] = { type = "Model", model = "models/weapons/w_crossbow.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-0.113, 0, 0), angle = Angle(-0.625, 9.894, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["left+"] = { type = "Model", model = "models/Gibs/Strider_Left_Leg.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "wrathbow", pos = Vector(30, -10.655, 0.305), angle = Angle(3.441, -74.964, 88.894), size = Vector(0.054, 0.054, 0.054), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["right"] = { type = "Model", model = "models/Gibs/Strider_Right_Leg.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(30, -1.425, 6.186), angle = Angle(-70.812, -2.5, 168.936), size = Vector(0.054, 0.054, 0.054), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["left"] = { type = "Model", model = "models/Gibs/Strider_Left_Leg.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "wrathbow", pos = Vector(30, 0.526, -6.045), angle = Angle(70.935, -26.644, 22.013), size = Vector(0.054, 0.054, 0.054), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["tasty"] = { type = "Model", model = "models/Gibs/HGIBS_spine.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "wrathbow", pos = Vector(12.531, -2.093, 3.917), angle = Angle(0, 89.861, 84.012), size = Vector(0.643, 0.643, 1.243), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
end

SWEP.Base				= "iw_base"

SWEP.Instructions	= "A long range weapon that's more lethal if fired from a longer distance!" 

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel = "models/weapons/v_crossbow.mdl"
SWEP.WorldModel = "models/weapons/w_crossbow.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("Weapon_Crossbow.Single")
SWEP.Primary.Recoil			= 14
SWEP.Primary.Unrecoil		= 7
SWEP.Primary.Damage			= 25 // minimum damage, maximum damage is three times as much
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 1
SWEP.Primary.Delay			= 0.5
SWEP.Primary.DefaultClip	= 25
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "XBowBolt"
SWEP.Primary.Cone			= 0.04
SWEP.Primary.ConeMoving		= 0.1
SWEP.Primary.ConeCrouching	= 0.012
SWEP.Primary.ZoomedCone		= 0.02
SWEP.Primary.ZoomedConeMoving = 0.05
SWEP.Primary.ZoomedConeCrouching = 0.005

SWEP.Tracer = "black_tracer"

SWEP.Secondary.Delay = 0.5

SWEP.ShellEffect 			= "none"

--SWEP.IronSightsPos = Vector(6.02,-3,2.3)
--SWEP.IronSightsAng = Vector(2.5,-.21,0)

function SWEP:OnDeploy()
	if SERVER then
		self.OldFOV = self.Owner:GetFOV()
	end
end

function SWEP:SecondaryAttack()
	self.Weapon.NextZoom = self.Weapon.NextZoom or CurTime()
	if CurTime() < self.Weapon.NextZoom then return end
	self.Weapon.NextZoom = CurTime() + self.Secondary.Delay

	local zoomed = !(self.Weapon:GetDTBool(0, false))
	
	self:SetZoom(zoomed)
end

function SWEP:SetZoom( b )

	if ( self.Weapon:GetDTBool( 0 ) == b ) then return end
	
	if (b == false) then
		if SERVER then
			self.Owner:SetFOV(self.OldFOV or 75, 0.5)
		end
		self.Primary.Cone			= 0.04
		self.Primary.ConeMoving		= 0.1
		self.Primary.ConeCrouching	= 0.024
	else
		if SERVER then
			self.Owner:SetFOV(30, 0.5)
		end
		self.Primary.Cone			= self.Primary.ZoomedCone
		self.Primary.ConeMoving		= self.Primary.ZoomedConeMoving
		self.Primary.ConeCrouching	= self.Primary.ZoomedConeCrouching
	end
	
	self.Weapon:SetDTBool(0, b)
end

function SWEP:Reload()
	self.Weapon:DefaultReload(ACT_VM_RELOAD)
	self:SetZoom(false)	
end

function SWEP:OnHolster()
	if SERVER then
		if self.Owner then
			self.Owner:SetFOV(self.OldFOV or 75, 0.5)
		end
	end
	self:SetZoom(false)
	return !self.Weapon:GetDTBool( 0 )
end

function SWEP:AdditionalCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	if ent:IsValid() and ent:IsPlayer() and ent:Team() ~= attacker:Team() then
		local dis = attacker:GetPos():Distance(ent:GetPos())
		local dmg = self.Primary.Damage	
		dmginfo:SetDamage(math.Clamp(dis/(1200/dmg*3),dmg,dmg*3))
	end
end

function SWEP:OnPrimaryAttack()
	self.Weapon:DefaultReload(ACT_VM_RELOAD)
	self:SetZoom(false)
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
	bullet.TracerName = "black_tracer"
	
	-- Increase damage at range
	bullet.Callback = function ( attacker, tr, dmginfo )  
		local ent = tr.Entity
		if ent:IsValid() and ent:IsPlayer() and ent:Team() ~= attacker:Team() then
			local dis = attacker:GetPos():Distance(ent:GetPos())
			dmginfo:SetDamage(math.Clamp(dis/(1200/dmg*3),dmg,dmg*3))
		end
	end
	
	self.Owner:FireBullets(bullet)
	self.Weapon:DefaultReload(ACT_VM_RELOAD)
	self:SetZoom(false)
end

if CLIENT then

	function SWEP:AdjustMouseSensitivity()
		if self.Weapon:GetDTBool( 0 ) then return 0.4 end
	end

end