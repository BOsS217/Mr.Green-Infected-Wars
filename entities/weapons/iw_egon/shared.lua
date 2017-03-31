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

SWEP.Author			= "" -- Dark Moule/Team Garry
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= "High-power energy based weapon. Consumes suit power!"

if CLIENT then
	SWEP.ShowWorldModel = false
end

function SWEP:InitializeClientsideModels()
	
	self.VElements = {
		["glow1"] = { type = "Sprite", sprite = "sprites/blueflare1", bone = "Prong_A", rel = "", pos = Vector(0, -3.975, 11.199), size = { x = 10, y = 10 }, color = Color(255, 255, 255, 134), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = true},
		["glow3"] = { type = "Sprite", sprite = "sprites/animglow02", bone = "Base", rel = "", pos = Vector(0.58, 2.844, 17.444), size = { x = 25, y = 25 }, color = Color(179, 179, 255, 119), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
		["glow1+"] = { type = "Sprite", sprite = "sprites/blueflare1", bone = "Prong_B", rel = "", pos = Vector(2.325, 2.5, 11.656), size = { x = 10, y = 10 }, color = Color(255, 255, 255, 134), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = true}
	}
	self.WElements = {
		["egon"] = { type = "Model", model = "models/weapons/w_physics.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.049, 0.931, -3.25), angle = Angle(-5.057, 11.293, -159.601), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 1, bodygroup = {} },
		["glow1+"] = { type = "Sprite", sprite = "sprites/blueflare1", bone = "ValveBiped.Bip01_R_Hand", rel = "egon", pos = Vector(26.344, -1.525, -0.569), size = { x = 5.154, y = 5.154 }, color = Color(255, 255, 255, 134), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
		["glow3"] = { type = "Sprite", sprite = "sprites/animglow02", bone = "ValveBiped.Bip01_R_Hand", rel = "egon", pos = Vector(22.506, -0.701, -0.169), size = { x = 20, y = 20 }, color = Color(179, 179, 255, 119), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
		["glow1++"] = { type = "Sprite", sprite = "sprites/blueflare1", bone = "ValveBiped.Bip01_R_Hand", rel = "egon", pos = Vector(26.094, 1, 0.201), size = { x = 5.154, y = 5.154 }, color = Color(255, 255, 255, 134), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
		["glow1"] = { type = "Sprite", sprite = "sprites/blueflare1", bone = "ValveBiped.Bip01_R_Hand", rel = "egon", pos = Vector(26.344, 0.056, 1.531), size = { x = 5.154, y = 5.154 }, color = Color(255, 255, 255, 134), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false}
	}
	
end



SWEP.Base = "iw_base_dummy"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false	
SWEP.PrintName			= "Egon beamcannon"			
SWEP.Slot				= 2
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true
SWEP.ViewModel			= "models/weapons/v_superphyscannon.mdl"
SWEP.WorldModel			= "models/weapons/w_physics.mdl"

SWEP.Primary.Automatic = false
SWEP.Primary.Recoil			= 1
SWEP.Primary.Unrecoil		= 1
SWEP.Primary.Damage			= 1
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= -1
SWEP.Primary.Delay			= 1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Cone			= 0
SWEP.Primary.ConeMoving		= 0
SWEP.Primary.ConeCrouching	= 0

SWEP.HoldType = "shotgun"

local sndPowerUp		= Sound("Airboat.FireGunHeavy")
local sndAttackLoop 	= Sound("Airboat_fan_idle")
local sndPowerDown		= Sound("Town.d1_town_02a_spindown")

SWEP.Drain = 7
SWEP.DrainDelta = 0.25
SWEP.DrainTimer = 0
SWEP.CanAttack = true
SWEP.PrimFireDelay = 0.5
SWEP.NextPrimFire = 0

//function SWEP:Initialize()
//	self:SetWeaponHoldType( "shotgun" )
//end

function SWEP:OnDeploy()

end

function SWEP:OnViewModelDrawn()
	local vm = self.Owner:GetViewModel()
	if vm and vm:IsValid() then
		vm:SetPoseParameter("active",1)
	end
end

function SWEP:Think()

	if (!self.Owner || self.Owner == NULL) then return end

	
	if self.NextPrimFire < CurTime() then
	
		if ( self.Owner:KeyDown( IN_ATTACK ) and self.Owner:SuitPower() >= self.Drain ) then

			if self.CanAttack then
				self:UpdateAttack()
			end
			
		elseif ( self.Owner:KeyReleased( IN_ATTACK ) or self.Owner:SuitPower() < self.Drain ) then

			if self.CanAttack then
				self.CanAttack = false
				self.NextPrimFire = CurTime()+self.PrimFireDelay
				self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
				self:EndAttack( true )
			end

		end
		
	end

end



function SWEP:StartAttack()

	self.Weapon:EmitSound( sndPowerUp )
	self.Weapon:EmitSound( sndAttackLoop )
	
	if (SERVER) then
		
		if (!self.Beam) then
			self.Beam = ents.Create( "egon_beam" )
			if IsValid(self.Beam) then
				self.Beam:SetPos( self.Owner:GetShootPos() )
				self.Beam:Spawn()
			end
		end
		
		self.Beam:SetParent( self.Owner )
		self.Beam:SetOwner( self.Owner )
	
	end

	self:UpdateAttack()

end

function SWEP:UpdateAttack()
	
	if ( self.Timer && self.Timer > CurTime() ) then return end
	
	self.Timer = CurTime() + 0.05
	
	if SERVER and self.DrainTimer < CurTime() then
		self.Owner:SetSuitPower(self.Owner:SuitPower()-self.Drain)
		self.DrainTimer = CurTime()+self.DrainDelta			
	end
	
	if self.Owner:SuitPower() < self.Drain then return end
	
	// We lag compensate here. This moves all the players back to the spots where they were
	// when this player fired the gun (a ping time ago).
	self.Owner:LagCompensation( true )
	
	local trace = {}
		trace.start = self.Owner:GetShootPos()
		trace.endpos = trace.start + (self.Owner:GetAimVector() * 4096)
		trace.filter = { self.Owner, self.Weapon }
		
	local tr = util.TraceLine( trace )
	
	if (SERVER && self.Beam) then
		self.Beam:GetTable():SetEndPos( tr.HitPos )
	end
	
	util.BlastDamage( self.Weapon, self.Owner, tr.HitPos, 60, 4 )
	
	if ( tr.Entity && tr.Entity:IsPlayer() ) then
	
		local effectdata = EffectData()
			effectdata:SetEntity( tr.Entity )
			effectdata:SetOrigin( tr.HitPos )
			effectdata:SetNormal( tr.HitNormal )
		util.Effect( "bodyshot", effectdata )
	
	end
	
	self.Owner:LagCompensation( false )
	
end

function SWEP:EndAttack( shutdownsound )
	
	self.Weapon:StopSound( sndAttackLoop )
	self.Weapon:StopSound( sndPowerUp )
	
	if ( shutdownsound ) then
		self.Weapon:EmitSound( sndPowerDown )
	end
	
	if ( CLIENT ) then return end
	if ( !IsValid(self.Beam) ) then return end
	
	self.Beam:Remove()
	self.Beam = nil
	
end

function SWEP:OnHolster()
	self:EndAttack( false )
end

function SWEP:_OnRemove()
	self:EndAttack( false )
end


function SWEP:PrimaryAttack()
	if self.Owner:SuitPower() >= self.Drain*2 and self.NextPrimFire < CurTime() then
		self.CanAttack = true
		self:StartAttack()
	end
end

function SWEP:SecondaryAttack()
end

