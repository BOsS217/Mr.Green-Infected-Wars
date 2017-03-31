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
	SWEP.PrintName = "'HotShot'"			
	SWEP.Author	= "NECROSSIN"
	SWEP.Slot = 2
	SWEP.SlotPos = 1
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = true

	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false
	SWEP.AlwaysDrawViewModel = false
	SWEP.IgnoreBonemerge = false
	SWEP.UseHL2Bonemerge = false
	
	SWEP.IconLetter = "r"
	SWEP.SelectFont = "CSSelectIcons"
	killicon.AddFont("iw_und_hotshot", "CSKillIcons", SWEP.IconLetter, Color(255, 0, 0, 255 ))
end

function SWEP:InitializeClientsideModels()
	
	self.ViewModelBoneMods = {}

	self.VElements = {
		["thing3"] = { type = "Model", model = "models/Gibs/Strider_Gib6.mdl", bone = "v_weapon.awm_parent", rel = "", pos = Vector(1.157, 4.211, 4.568), angle = Angle(-174.125, -44.174, 90), size = Vector(0.054, 0.054, 0.054), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["thing2"] = { type = "Model", model = "models/Gibs/Shield_Scanner_Gib3.mdl", bone = "v_weapon.awm_parent", rel = "", pos = Vector(-0.225, 5.163, -1.32), angle = Angle(-65.625, -90, 0), size = Vector(0.125, 0.125, 0.125), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["thing1"] = { type = "Model", model = "models/Gibs/Shield_Scanner_Gib4.mdl", bone = "v_weapon.awm_parent", rel = "", pos = Vector(0.056, 3.256, 7.269), angle = Angle(151.973, 90, 0), size = Vector(0.287, 0.287, 0.287), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} }
	}
	self.WElements = {
		["thing3"] = { type = "Model", model = "models/Gibs/Strider_Gib6.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "hotshot", pos = Vector(11.637, -0.113, 3.575), angle = Angle(-29.719, 90, 0), size = Vector(0.059, 0.059, 0.059), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["hotshot"] = { type = "Model", model = "models/weapons/w_snip_awp.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0, -0.538, -1.589), angle = Angle(0, 0, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["thing2"] = { type = "Model", model = "models/Gibs/Shield_Scanner_Gib3.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "hotshot", pos = Vector(3.805, -1.7, 5.631), angle = Angle(31.08, 180, -6.963), size = Vector(0.15, 0.15, 0.15), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["thing1"] = { type = "Model", model = "models/Gibs/Shield_Scanner_Gib4.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "hotshot", pos = Vector(18.187, -1.726, 3.605), angle = Angle(44.581, 4.038, 9.951), size = Vector(0.374, 0.33, 0.379), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} }
	}
	
end

SWEP.Base				= "iw_und_wraithbow"

SWEP.Instructions	= "Ricochet-based undead rifle! Deals more damage with each bullet reflection." 

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_snip_awp.mdl"
SWEP.WorldModel			= "models/weapons/w_snip_awp.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("NPC_dog.Pneumatic_1")
SWEP.Primary.Recoil			= 14
SWEP.Primary.Unrecoil		= 7
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 5
SWEP.Primary.Delay			= 0.5
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "XBowBolt"
SWEP.Primary.Cone			= 0.03
SWEP.Primary.ConeMoving		= 0.09
SWEP.Primary.ConeCrouching	= 0.012
SWEP.Primary.ZoomedCone		= 0.01
SWEP.Primary.ZoomedConeMoving = 0.05
SWEP.Primary.ZoomedConeCrouching = 0.003

SWEP.Tracer = "black_tracer"

SWEP.Secondary.Delay = 0.5

SWEP.MaxHits = 4

SWEP.ShellEffect 			= "none"

local Hits = 0

function SWEP:DoRicochet(attacker, hitpos, hitnormal, normal, damage)
		local shots = 1
			
		attacker.RicochetBullet = true
		attacker:FireBullets({Num = shots, 
							Src = hitpos, 
							Dir = 2 * hitnormal * hitnormal:Dot(normal * -1) + normal, 
							Spread = Vector(0, 0, 0), 
							Tracer = 1, 
							TracerName = "rico_trace_black", 
							Force = damage * 0.15, 
							Damage = damage, 
							Callback = function(attacker, tr, dmginfo)
								GenericBulletCallback(attacker, tr, dmginfo)
								self:AdditionalCallback(attacker, tr, dmginfo)
							end
							})
		attacker.RicochetBullet = nil
end

function SWEP:AdditionalCallback(attacker, tr, dmginfo)
	if Hits >= self.MaxHits then
		Hits = 0
		return
	end
	if SERVER and tr.HitWorld and not tr.HitSky then
		timer.Simple(0.001, function()
						self:DoRicochet(attacker, tr.HitPos, tr.HitNormal, tr.Normal, math.Clamp(dmginfo:GetDamage()*1.5,self.Primary.Damage,100))
						end)
	end
	Hits = Hits + 1
end


function SWEP:OnPrimaryAttack()
	//self:SetZoom(false)
end

if CLIENT then
function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	draw.SimpleText( "r", "CSSelectIcons", x + wide/2, y + tall*0.3, Color( 255, 0, 0, 255 ), TEXT_ALIGN_CENTER )
	// Draw weapon info box
	self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )
end 
end

