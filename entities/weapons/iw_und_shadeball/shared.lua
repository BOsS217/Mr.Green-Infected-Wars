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

SWEP.HoldType = "grenade"
SWEP.Base = "iw_base_dummy"
if CLIENT then
	SWEP.PrintName = "Shade Bomb"			
	SWEP.Author	= "" -- ClavusElite
	SWEP.DrawCrosshair = false
	SWEP.Slot = 2
	SWEP.SlotPos = 1
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60
	
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false
	SWEP.IgnoreBonemerge = true
	SWEP.UseHL2Bonemerge = true
	
	SWEP.OverrideAngle = {}
	SWEP.OverrideAngle["ValveBiped.Bip01_R_Forearm"] = Angle(0,0,30)
	
end

SWEP.NoDeployDelay = true


function SWEP:InitializeClientsideModels()
	
	self.ViewModelBoneMods = {
		["ValveBiped.cube3"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}
	
	self.VElements = {
		["bomb"] = { type = "Model", model = "models/Weapons/w_bugbait.mdl", bone = "ValveBiped.cube3", rel = "", pos = Vector(0.068, 0.787, 0.462), angle = Angle(0, -70.031, -137.9), size = Vector(0.718, 0.718, 0.718), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/shadertest/shader4", skin = 0, bodygroup = {} }
	}
	self.WElements = {
		["bomb"] = { type = "Model", model = "models/Weapons/w_bugbait.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.055, 3.088, -0.382), angle = Angle(0, 0, 0), size = Vector(0.718, 0.718, 0.718), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/shadertest/shader4", skin = 0, bodygroup = {} }
	}
	
end

SWEP.Instructions = "Explodes in a cloud of black smoke on impact. Blinds nearby enemies for a few seconds." 

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel = "models/Weapons/V_bugbait.mdl"
SWEP.WorldModel = "models/Weapons/w_bugbait.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("weapons/slam/throw.wav")
SWEP.Primary.Recoil			= 1
SWEP.Primary.Unrecoil		= 1
SWEP.Primary.Damage			= 1
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 10
SWEP.Primary.Delay			= 1.5
SWEP.Primary.DefaultClip	= 10
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Cone			= 0
SWEP.Primary.ConeMoving		= 0
SWEP.Primary.ConeCrouching	= 0

--SWEP.IronSightsPos = Vector(-4.5, -9.6, 3.1)
--SWEP.IronSightsAng = Vector(1.1, 0.6, -3.3)

util.PrecacheSound("infectedwars/roar1.wav")
util.PrecacheSound("infectedwars/roar2.wav")

local restoretimer = 0

function SWEP:PrimaryAttack()

	local ply = self.Owner

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if not self:CanPrimaryAttack() then return end
	
	self.Weapon:SendWeaponAnim(ACT_VM_THROW)
	timer.Create("balldraw",0.5,1,function()
		if self.Weapon and self.Weapon:IsValid() then
			self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
		end
	end,self)
	
	self:TakePrimaryAmmo(1)
	
	self.Weapon:EmitSound(self.Weapon.Primary.Sound)
	
	if (!SERVER) then return end
	
	local Ball = ents.Create("shadeball")
	local Force = 800
	
	local v = self.Owner:GetShootPos()
		v = v + self.Owner:GetUp() * -8
	Ball:SetPos(v)
	Ball:SetAngles( self.Owner:GetAimVector():Angle() )
	Ball:SetOwner(self.Owner)
	Ball:Spawn()
	
	Ball:Activate()
	Ball:SetMaterial("models/shadertest/shader4")
	
	local Phys = Ball:GetPhysicsObject()
	Phys:SetVelocity(self.Owner:GetAimVector() * Force)
	
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
	if CLIENT then
		self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end

end

function SWEP:OnHolster()
	timer.Destroy("balldraw")
end

function SWEP:Think()
 
end 

local screamtimer = 0

function SWEP:SecondaryAttack()
	if screamtimer < CurTime() then
		screamtimer = CurTime()+2
		self.Owner:EmitSound("infectedwars/roar"..math.random(1,2)..".wav")
	end
end

if CLIENT then
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		draw.SimpleText( "8", "HL2MPTypeDeath", x + wide/2, y + tall*0.3, Color( 255, 210, 0, 255 ), TEXT_ALIGN_CENTER )
		// Draw weapon info box
		self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )
	end
end

