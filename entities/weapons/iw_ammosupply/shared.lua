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

SWEP.HoldType = "melee"

if CLIENT then
	SWEP.PrintName = "Ammo Supply"			
	SWEP.Author	= "ClavusElite"
	SWEP.Slot = 3
	SWEP.SlotPos = 2
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60
	SWEP.DrawCrosshair = false
	
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false
	
end

function SWEP:InitializeClientsideModels()
	
	self.ViewModelBoneMods = {
		["v_weapon.c4"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.Right_Arm"] = { scale = Vector(1, 1, 1), pos = Vector(-1.106, 2.275, 0.025), angle = Angle(0, 0, 0) }
	}
	
	self.VElements = {
		["ammobox"] = { type = "Model", model = "models/Items/BoxMRounds.mdl", bone = "v_weapon.c4", rel = "", pos = Vector(-1.589, -0.318, -2.645), angle = Angle(-1.188, -86.37, 0.906), size = Vector(0.317, 0.442, 0.361), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["ammo"] = { type = "Quad", bone = "v_weapon.c4", rel = "", pos = Vector(-3.688, -3.151, 0.218), angle = Angle(0, 180, 90), size = 0.012, draw_func = function(wep) DrawWeaponInfo(wep) end}
	}
	self.WElements = {
		["ammo"] = { type = "Model", model = "models/Items/BoxMRounds.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.526, 5.682, 1.468), angle = Angle(-163.4, 16.086, 0), size = Vector(0.254, 0.428, 0.398), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
end

SWEP.Base = "iw_base_dummy"

SWEP.Instructions	= "Drop ammunition for your team."

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= ""
SWEP.WorldModel			= ""

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.ViewModel = "models/weapons/v_c4.mdl"
SWEP.WorldModel = "models/Items/BoxMRounds.mdl"

SWEP.Primary.Sound			= Sound("weapons/slam/throw.wav")
SWEP.Primary.Recoil			= 1
SWEP.Primary.Unrecoil		= 1
SWEP.Primary.Damage			= 1
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 5
SWEP.Primary.Delay			= 1
SWEP.Primary.DefaultClip	= 5
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Cone			= 0
SWEP.Primary.ConeMoving		= 0
SWEP.Primary.ConeCrouching	= 0

--SWEP.IronSightsPos = Vector(-4.5, -9.6, 3.1)
--SWEP.IronSightsAng = Vector(1.1, 0.6, -3.3)

local restoretimer = 0

function SWEP:PrimaryAttack()

	local ply = self.Owner

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if not self:CanPrimaryAttack() then return end
	
	self:TakePrimaryAmmo(1)
	self.Weapon:EmitSound(self.Weapon.Primary.Sound)
	
	if (!SERVER) then return end
	
	local Box = ents.Create("ammobox")
	local Force = 200
	
	local v = self.Owner:GetShootPos()
		v = v + self.Owner:GetForward() * 4
		v = v + self.Owner:GetRight() * 8
		v = v + self.Owner:GetUp() * -3
	Box:SetPos(v)
	Box:SetAngles( self.Owner:GetAimVector():Angle() )
	Box:SetOwner(self.Owner)
	Box:Spawn()
	
	Box:Activate()
	
	local Phys = Box:GetPhysicsObject()
	Phys:SetVelocity((self.Owner:GetAimVector()+Vector(0,0,0.5)) * Force)
	
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
	if CLIENT then
		//self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end

end


function SWEP:SecondaryAttack()

end

if CLIENT then
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		draw.SimpleText( "9", "HL2MPTypeDeath", x + wide/2, y + tall*0.3, Color( 255, 210, 0, 255 ), TEXT_ALIGN_CENTER )
		// Draw weapon info box
		self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )
	end
end