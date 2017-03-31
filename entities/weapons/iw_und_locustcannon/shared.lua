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
	SWEP.PrintName = "Locust Cannon"			
	SWEP.Author	= "ClavusElite"
	SWEP.Slot = 2
	SWEP.SlotPos = 1
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false
	
	SWEP.ShowViewModel = false
	SWEP.IgnoreBonemerge = false
	SWEP.UseHL2Bonemerge = true
	SWEP.ScaleDownLeftHand = true

	SWEP.ShowWorldModel = false
	
	SWEP.IconLetter = "0"
	SWEP.SelectFont = "HL2MPTypeDeath"
	killicon.AddFont("iw_und_locustcannon", "HL2MPTypeDeath", SWEP.IconLetter, Color(255, 80, 0, 255 ))
end

function SWEP:InitializeClientsideModels()
	
	self.VElements = {
		["bone+++++"] = { type = "Model", model = "models/Gibs/HGIBS_rib.mdl", bone = "ValveBiped.Gun", rel = "", pos = Vector(-0.638, -1.063, 0.874), angle = Angle(180, 78.324, 180), size = Vector(0.467, 0.467, 0.467), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["bone++++"] = { type = "Model", model = "models/Gibs/HGIBS_rib.mdl", bone = "ValveBiped.Gun", rel = "", pos = Vector(-0.638, -0.995, 3.93), angle = Angle(180, 78.324, 180), size = Vector(0.467, 0.467, 0.467), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["bone++"] = { type = "Model", model = "models/Gibs/HGIBS_rib.mdl", bone = "ValveBiped.Gun", rel = "", pos = Vector(0.75, -1, 1.618), angle = Angle(180, 105.186, 0), size = Vector(0.467, 0.467, 0.467), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["bone+"] = { type = "Model", model = "models/Gibs/HGIBS_rib.mdl", bone = "ValveBiped.Gun", rel = "", pos = Vector(0.75, -1.007, -1.232), angle = Angle(180, 105.186, 0), size = Vector(0.467, 0.467, 0.467), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["bone++++++"] = { type = "Model", model = "models/Gibs/HGIBS_rib.mdl", bone = "ValveBiped.Gun", rel = "", pos = Vector(-0.638, -1.063, -1.982), angle = Angle(180, 78.324, 180), size = Vector(0.467, 0.467, 0.467), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["bone1"] = { type = "Model", model = "models/Gibs/Antlion_gib_Large_3.mdl", bone = "ValveBiped.Gun", rel = "", pos = Vector(-0.119, -2.757, 0), angle = Angle(23.011, -88.175, 180), size = Vector(0.209, 0.179, 0.354), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["bone+++"] = { type = "Model", model = "models/Gibs/HGIBS_rib.mdl", bone = "ValveBiped.Gun", rel = "", pos = Vector(0.75, -1, -3.5), angle = Angle(180, 105.186, 0), size = Vector(0.467, 0.467, 0.467), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["bone"] = { type = "Model", model = "models/Gibs/HGIBS_rib.mdl", bone = "ValveBiped.Gun", rel = "", pos = Vector(0.75, -1, 4.605), angle = Angle(180, 105.186, 0), size = Vector(0.467, 0.467, 0.467), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["bone+++++++"] = { type = "Model", model = "models/Gibs/HGIBS_rib.mdl", bone = "ValveBiped.Gun", rel = "", pos = Vector(-0.638, -1.063, -4.308), angle = Angle(180, 78.324, 180), size = Vector(0.467, 0.467, 0.467), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	self.WElements = {
		["locust"] = { type = "Model", model = "models/Weapons/w_shotgun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(16.562, 0.524, -3.537), angle = Angle(167.143, -1.331, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["bone+++++"] = { type = "Model", model = "models/Gibs/HGIBS_rib.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(19.781, 0.832, -6.525), angle = Angle(97.25, -132.431, -51.113), size = Vector(0.3, 0.3, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["bone++++"] = { type = "Model", model = "models/Gibs/HGIBS_rib.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(21.051, 0.832, -6.525), angle = Angle(97.25, -132.431, -51.113), size = Vector(0.3, 0.3, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["bone1"] = { type = "Model", model = "models/Gibs/Antlion_gib_Large_3.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(20.163, 1.055, -8.124), angle = Angle(72.337, 0, 0), size = Vector(0.135, 0.109, 0.216), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["bone+"] = { type = "Model", model = "models/Gibs/HGIBS_rib.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(21.819, 1.544, -6.525), angle = Angle(90, -4.088, 0), size = Vector(0.3, 0.3, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["bone++++++"] = { type = "Model", model = "models/Gibs/HGIBS_rib.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(18.475, 0.832, -6.525), angle = Angle(97.25, -132.431, -51.113), size = Vector(0.3, 0.3, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["bone++"] = { type = "Model", model = "models/Gibs/HGIBS_rib.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(18.995, 1.544, -6.525), angle = Angle(90, -4.088, 0), size = Vector(0.3, 0.3, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["bone+++"] = { type = "Model", model = "models/Gibs/HGIBS_rib.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(17.357, 1.544, -6.525), angle = Angle(90, -4.088, 0), size = Vector(0.3, 0.3, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["bone"] = { type = "Model", model = "models/Gibs/HGIBS_rib.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(20.37, 1.549, -6.525), angle = Angle(90, -4.088, 0), size = Vector(0.3, 0.3, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["bone+++++++"] = { type = "Model", model = "models/Gibs/HGIBS_rib.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(16.806, 0.832, -6.525), angle = Angle(97.25, -132.431, -51.113), size = Vector(0.3, 0.3, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

end

SWEP.Base				= "iw_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/Weapons/v_shotgun.mdl"
SWEP.WorldModel			= "models/Weapons/w_shotgun.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("BULLSHOT.Single2")//Sound("npc/antlion/land1.wav")
SWEP.Primary.Recoil			= 8
SWEP.Primary.Unrecoil		= 7
SWEP.Primary.Damage			= 2
SWEP.Primary.NumShots		= 8
SWEP.Primary.ClipSize		= 10
SWEP.Primary.Delay			= 0.4
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize * 6
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"
SWEP.Primary.Cone			= 0.12
SWEP.Primary.ConeMoving		= 0.19
SWEP.Primary.ConeCrouching	= 0.08

SWEP.MuzzleEffect			= "rg_muzzle_rifle"

--SWEP.IronSightsPos = Vector(-5.6, -6, 3.6)
--SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.NextReload = 0


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
