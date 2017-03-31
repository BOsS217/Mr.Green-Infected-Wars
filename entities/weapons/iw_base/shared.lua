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

SWEP.Author = ""
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

--SWEP.Base = "iw_base_dummy"

SWEP.Spawnable = true
SWEP.AdminSpawnable	= true

SWEP.Primary.Sound = Sound("Weapon_Pistol.Single")
SWEP.Primary.Damage = 30
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.15
SWEP.Cone = 0.02
SWEP.ConeMoving = 0.03
SWEP.ConeCrouching = 0.013
SWEP.ConeIron = 0.018
SWEP.ConeIronCrouching = 0.01

SWEP.Primary.Cone			= 0.005
SWEP.Primary.ConeMoving		= 0.01
SWEP.Primary.ConeCrouching	= 0.002
SWEP.Primary.Delay			= 0.8

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "CombineCannon"

SWEP.HoldType = "pistol"
SWEP.IronSightsHoldType = "ar2"

SWEP.Tracer 				= "AR2Tracer"

SWEP.IronSightMultiplier    = 0.5

SWEP.IronSightsPos = Vector(0,0,0)
SWEP.IronSightsAng = Vector(0,0,0)

SWEP.MuzzleAttachment		= "1" -- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment	= "2" -- Should be "2" for CSS models or "1" for hl2 models
SWEP.MuzzleEffect			= "none" -- This is an extra muzzleflash effect
-- Available muzzle effects: rg_muzzle_grenade, rg_muzzle_highcal, rg_muzzle_hmg, rg_muzzle_pistol, rg_muzzle_rifle, rg_muzzle_silenced, none
SWEP.ShellEffect			= "none" -- This is a shell ejection effect
-- Available shell eject effects: rg_shelleject, rg_shelleject_rifle, rg_shelleject_shotgun, none
SWEP.EjectDelay 			= 0.01

function SWEP:SetFleshMaterial( apply )

end

function SWEP:InitializeClientsideModels()
	
	self.VElements = {}
	self.WElements = {} 
	
end

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	//self:SetDeploySpeed(1.1)

	if CLIENT then
	
		self:InitializeClientsideModels()
		self:CreateViewModelElements()
		self:CreateWorldModelElements()   
		
    end
	
	self:OnInitialize() 
	
end

function SWEP:CreateViewModelElements()
	
	self:CreateModels(self.VElements)
	
	 self.BuildViewModelBones = function( s )
		if LocalPlayer():GetActiveWeapon() == self and self.ViewModelBoneMods then
			for k, v in pairs( self.ViewModelBoneMods ) do
				local bone = s:LookupBone(k)
				if (!bone) then continue end
				local m = s:GetBoneMatrix(bone)
				if (!m) then continue end
				m:Scale(v.scale)
				m:Rotate(v.angle)
				m:Translate(v.pos)
				s:SetBoneMatrix(bone, m)
			end
		end
	end   

	MakeNewArms(self)
	
end

function SWEP:CreateWorldModelElements()
	self:CreateModels(self.WElements)
end

function SWEP:CheckModelElements()
	if !self.VElements or !self.WElements then
		timer.Simple(0,function()
			self:InitializeClientsideModels()
			self:CreateViewModelElements()
			self:CreateWorldModelElements()
		end)
	end
end

function SWEP:CheckWorldModelElements()
	if !self.WElements then
		timer.Simple(0,function()
			self:InitializeClientsideModels()
			self:CreateWorldModelElements()
		end)
	end
end

function SWEP:OnInitialize()

end

function SWEP:PrimaryAttack()

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if not self:CanPrimaryAttack() then return end
	
	self:EmitFireSound()

	self:TakeAmmo()
	
	local Owner = self.Owner
	
	if Owner.ViewPunch then Owner:ViewPunch( Angle(math.Rand(-0.2,-0.1) * self.Primary.Recoil * 0.25, math.Rand(-0.1,0.1) * self.Primary.Recoil, 0) ) end
	if ( ( game.SinglePlayer() && SERVER ) || ( !game.SinglePlayer() && CLIENT && IsFirstTimePredicted() ) ) then
		local eyeang = self.Owner:EyeAngles()
		local recoil = math.Rand( 0.1, 0.2 )
		eyeang.pitch = eyeang.pitch - recoil
		self.Owner:SetEyeAngles( eyeang )
	end
	
	self:FireIWBullet()


	self.IdleAnimation = CurTime() + self:SequenceDuration()
	
	self:OnPrimaryAttack()
end

function SWEP:OnPrimaryAttack()

end

function SWEP:FireIWBullet()

	if self.Owner:GetVelocity():Length() > 30 then
		self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self.Primary.ConeMoving)
	else
		if self.Owner:Crouching() then
			self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self.Primary.ConeCrouching)
		else
			self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone)
		end
	end
end

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound)
end

function SWEP:SetIronsights(b)
	self:SetDTBool(0, b)

	if self.IronSightsHoldType then
		if b then
			self:SetWeaponHoldType(self.IronSightsHoldType)
		else
			self:SetWeaponHoldType(self.HoldType)
		end
	end
end

function SWEP:Deploy()
	DrawCrHair = true

	self:SetNextReload(0)
	self:SetIronsights(false)

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self.IdleAnimation = CurTime() + self:SequenceDuration()
	
	self.Weapon:SetNextSecondaryFire( CurTime() + 0.8 )
	
	if SERVER then
		//self.Owner:SetFOV(75, 0.5)
	end
	
	--self.Owner:StopAllLuaAnimations()
	
	self:OnDeploy()
	
	return true
end

function SWEP:OnDeploy()
//MakeNewArms(self)
end

function SWEP:Holster()
	//self:SetIronsights( false ) 
	--RemoveNewArms(self)
	if CLIENT then
		RestoreViewmodel(self.Owner)
    end
	
	self:OnHolster()
	
	return true
end

function SWEP:OnHolster()

end

function SWEP:OnRemove()
    RemoveNewArms(self)     
    if CLIENT then
        self:RemoveModels()
		RestoreViewmodel(self.Owner)
		
		if self and IsValid(self.Owner) then
			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				vm:SetMaterial("")
			end
		end
		
    end
     
end

function SWEP:Equip ( NewOwner )
end

function SWEP:OnDrop()

end

//disable double shell ejection (thanks to Clavus :v)
function SWEP:FireAnimationEvent( pos, ang, event )
	if (event == 20) then return true end
end


function SWEP:TranslateActivity(act)
	if self:GetIronsights() and self.ActivityTranslateIronSights then
		return self.ActivityTranslateIronSights[act] or -1
	end

	return self.ActivityTranslate[act] or -1
end

function SWEP:TakeAmmo()
	self:TakePrimaryAmmo(1)
end

function SWEP:Reload()
	if self:GetNextReload() <= CurTime() and self:DefaultReload(ACT_VM_RELOAD) then
		self.IdleAnimation = CurTime() + self:SequenceDuration()
		self:SetNextReload(self.IdleAnimation)
		self.Owner:DoReloadEvent()
		if self.ReloadSound then
			self:EmitSound(self.ReloadSound)
		end
	end
end

function SWEP:GetIronsights()
	return self:GetDTBool(0) or false
end

function SWEP:TakePrimaryAmmo( num )
 
	--Doesn't use clips
	if ( self.Weapon:Clip1() <= 0 ) then
		if ( self:Ammo1() <= 0 ) then return end
		self.Owner:RemoveAmmo( num, self.Weapon:GetPrimaryAmmoType() )
	return end

	self.Weapon:SetClip1( self.Weapon:Clip1() - num )
 
end 

function SWEP:CanPrimaryAttack()

	if self:Clip1() <= 0 then
		self:EmitSound("Weapon_Pistol.Empty")
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		return false
	end

	return true//self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:SecondaryAttack()
	--[[if self:GetNextSecondaryFire() <= CurTime() and not (self.Owner.KnockedDown or self.Owner:GetNetworkedBool("IsHolding")) then
		self:SetIronsights(true)
	end]]
end

function SWEP:OnRestore()
	self:SetIronsights(false)
end

local tempknockback
function SWEP:StartBulletKnockback()
	tempknockback = {}
end

function SWEP:EndBulletKnockback()
	tempknockback = nil
end

function SWEP:DoBulletKnockback()
	for ent, prevvel in pairs(tempknockback) do
		local curvel = ent:GetVelocity()
		ent:SetVelocity(curvel * -1 + (curvel - prevvel) * 0.25 + prevvel)
	end
end

function GenericBulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	if not IsValid(ent) then
		return
	end

	if ent:IsPlayer() then
		if ent:Team() == TEAM_UNDEAD and tempknockback then
			tempknockback[ent] = ent:GetVelocity()
		end
	else
		local phys = ent:GetPhysicsObject()
		if ent:GetMoveType() == MOVETYPE_VPHYSICS and phys:IsValid() and phys:IsMoveable() then
			ent:SetPhysicsAttacker(attacker)
		end
	end
end


function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
end

function SWEP:AdditionalCallback(attacker, tr, dmginfo)
	
end

SWEP.BulletCallback = GenericBulletCallback

--[[function SWEP:BulletCallback(attacker, tr, dmginfo)
	GenericBulletCallback(attacker, tr, dmginfo)
	self:AdditionalCallback(attacker, tr, dmginfo)
end]]
function SWEP:ShootBullets(dmg, numbul, cone)
	local owner = self.Owner
	//self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)//SendWeaponAnimation()
	//owner:DoAttackEvent()
	//owner:SetAnimation(PLAYER_ATTACK1)

	self:StartBulletKnockback()
	owner:FireBullets({Num = numbul, 
					Src = owner:GetShootPos(), 
					Dir = owner:GetAimVector(), 
					Spread = Vector(cone, cone, 0), 
					Tracer = 1, TracerName = self.Tracer, 
					Force = dmg * 0.5, 
					Damage = dmg, 
					Callback = function(attacker, tr, dmginfo)//self.BulletCallback
						self:BulletCallback(attacker, tr, dmginfo)
						self:AdditionalCallback(attacker, tr, dmginfo)
					end
					})
	self:DoBulletKnockback()
	self:EndBulletKnockback()
	self:ShootEffects()
end

function SWEP:ShootEffects()

	local PlayerPos = self.Owner:GetShootPos()
	local PlayerAim = self.Owner:GetAimVector()

	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK) 		-- View model animation
	self.Owner:MuzzleFlash()								-- Crappy muzzle light
	self.Owner:SetAnimation(PLAYER_ATTACK1)					-- 3rd Person Animation
	
	if not IsFirstTimePredicted() then return end
	
	if self.MuzzleEffect ~= "none" and ((CLIENT and EFFECT_MUZZLE) or (SERVER and self.Owner.EFFECT_MUZZLE)) then
		local fx = EffectData()
		fx:SetEntity(self.Weapon)
		fx:SetOrigin(PlayerPos)
		fx:SetNormal(PlayerAim)
		fx:SetAttachment(self.MuzzleAttachment)
		util.Effect(self.MuzzleEffect,fx)						-- Additional muzzle effects
	end
	
	if self.ShellEffect ~= "none" and ((CLIENT and EFFECT_SHELL) or (SERVER and self.Owner.EFFECT_SHELL)) then
		timer.Simple( self.EjectDelay, function(aim)
			if self.ShellEffect then // check if we're not dead
				local fx = EffectData()
				fx:SetEntity(self.Weapon)
				fx:SetNormal(aim)
				fx:SetAttachment(self.ShellEjectAttachment)
				util.Effect(self.ShellEffect,fx)						-- Shell ejection
			end
		end,PlayerAim)
	end
	
end
