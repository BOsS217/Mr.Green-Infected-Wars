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
	SWEP.PrintName = "'Lucky Foot'"			
	SWEP.Author	= ""
	SWEP.Slot = 2
	SWEP.SlotPos = 1
	SWEP.ViewModelFlip = true
	
	SWEP.ShowWorldModel = false
	
	SWEP.IconLetter = "/"
	SWEP.SelectFont = "HL2MPTypeDeath"
	killicon.AddFont("iw_und_luckyfoot", "HL2MPTypeDeath", SWEP.IconLetter, Color(255, 0, 0, 255 ))
end

function SWEP:InitializeClientsideModels()
	
	self.ViewModelBoneMods = {
		["v_weapon.TMP_ShellEject"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}
	self.VElements = {
		["thing1"] = { type = "Model", model = "models/Gibs/Antlion_gib_Large_3.mdl", bone = "v_weapon.TMP_Parent", rel = "legs!", pos = Vector(0.725, 0, 7.849), angle = Angle(140.863, 180, 0), size = Vector(0.135, 0.135, 0.135), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["legs!"] = { type = "Model", model = "models/Gibs/Fast_Zombie_Legs.mdl", bone = "v_weapon.TMP_Parent", rel = "", pos = Vector(0, 3.549, -5.582), angle = Angle(0, 90, 0), size = Vector(0.157, 0.157, 0.157), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["bob"] = { type = "Model", model = "models/Gibs/Fast_Zombie_Torso.mdl", bone = "v_weapon.TMP_Parent", rel = "legs!", pos = Vector(-4.283, 0.012, -12.719), angle = Angle(-15.325, 0, -0.663), size = Vector(0.398, 0.298, 0.449), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	self.WElements = {
		["legs!"] = { type = "Model", model = "models/Gibs/Fast_Zombie_Legs.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "luckyfoot", pos = Vector(-2.313, 0, 3.763), angle = Angle(-90, 0, 0), size = Vector(0.326, 0.326, 0.326), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["bob"] = { type = "Model", model = "models/Gibs/Fast_Zombie_Torso.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "legs!", pos = Vector(-2.27, -0.213, -19.146), angle = Angle(-7.42, 0, 0), size = Vector(0.493, 0.549, 0.68), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["glow"] = { type = "Sprite", sprite = "effects/redflare", bone = "ValveBiped.Bip01_R_Hand", rel = "bob", pos = Vector(-3.569, 0.936, 45.549), size = { x = 5.294, y = 5.294 }, color = Color(255, 255, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
		["glow+"] = { type = "Sprite", sprite = "effects/redflare", bone = "ValveBiped.Bip01_R_Hand", rel = "bob", pos = Vector(-3.569, -0.652, 45.549), size = { x = 5.294, y = 5.294 }, color = Color(255, 255, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
		["luckyfoot"] = { type = "Model", model = "models/weapons/w_smg_tmp.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0.256, 1.169, 0), angle = Angle(-7.308, 0, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["thing1"] = { type = "Model", model = "models/Gibs/Antlion_gib_Large_3.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "luckyfoot", pos = Vector(6.125, 0, 3.112), angle = Angle(-126.95, 180, 0), size = Vector(0.203, 0.203, 0.203), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} }
	}
	
end

SWEP.Base				= "iw_base"

SWEP.Instructions	= "Nasty weapon that gets stronger when fired at crowd of humans!" 

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_smg_tmp.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_tmp.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("npc/barnacle/neck_snap1.wav")--Sound("NPC_BlackHeadcrab.FootstepWalk")--Sound("NPC_Barnacle.BreakNeck")
SWEP.Primary.Recoil			= 3
SWEP.Primary.Unrecoil		= 7
SWEP.Primary.Damage			= 3
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 40
SWEP.Primary.Delay			= 0.13
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize * 6
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"
SWEP.Primary.Cone			= 0.05
SWEP.Primary.ConeMoving		= 0.13
SWEP.Primary.ConeCrouching	= 0.03

SWEP.MuzzleEffect			= "rg_muzzle_pistol"
SWEP.ShellEffect 			= "none"

SWEP.CrowdDistance = 210
SWEP.CrowdMax = 7

SWEP.Tracer = "black_tracer"

--SWEP.IronSightsPos = Vector(-5.6, -6, 3.6)
--SWEP.IronSightsAng = Vector(0, 0, 0)

function SWEP:AdditionalCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	if ent:IsValid() and ent:IsPlayer() and ent:Team() ~= attacker:Team() then
		local dudes = team.GetPlayers(TEAM_HUMAN)
		local adddmg = 0
			for _,pl in pairs(dudes) do
				if pl and IsValid(pl) and pl:Alive() and ent ~= pl and ent:GetPos():Distance(pl:GetPos()) <= self.CrowdDistance then
					adddmg = adddmg + 1
				end
			end
		local dmg = self.Primary.Damage
		dmginfo:SetDamage(math.Clamp(dmg+adddmg,dmg,dmg+self.CrowdMax))
	end
end

if CLIENT then
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		draw.SimpleText( self.IconLetter, self.SelectFont, x + wide/2, y + tall*0.3, Color( 255, 0, 0, 255 ), TEXT_ALIGN_CENTER )

		self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )
	end
end
