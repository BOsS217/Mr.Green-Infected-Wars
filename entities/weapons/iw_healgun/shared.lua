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

SWEP.Base = "iw_base_dummy"

SWEP.HoldType = "pistol"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_toolgun.mdl"
SWEP.WorldModel			= "models/weapons/w_toolgun.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("items/medshot4.wav")
SWEP.Primary.Recoil			= 1
SWEP.Primary.Unrecoil		= 1
SWEP.Primary.Damage			= 1
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= -1
SWEP.Primary.Delay			= 0.25
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Cone			= 0
SWEP.Primary.ConeMoving		= 0
SWEP.Primary.ConeCrouching	= 0

if CLIENT then
	
	/*SWEP.PlayerModelBones = {}
	
	SWEP.PlayerModelBones["ValveBiped.Bip01_L_Upperarm"] 	= "Bip01_L_Upperarm"
	SWEP.PlayerModelBones["ValveBiped.Bip01_L_Forearm"] 	= "Bip01_L_Forearm"
	SWEP.PlayerModelBones["ValveBiped.Bip01_L_Hand"] 		= "Bip01_L_Hand"

	SWEP.PlayerModelBones["ValveBiped.Bip01_L_Finger4"] 	= "Bip01_L_Finger4"
	SWEP.PlayerModelBones["ValveBiped.Bip01_L_Finger41"] 	= "Bip01_L_Finger41"
	SWEP.PlayerModelBones["ValveBiped.Bip01_L_Finger42"] 	= "Bip01_L_Finger42"
	SWEP.PlayerModelBones["ValveBiped.Bip01_L_Finger3"] 	= "Bip01_L_Finger3"
	SWEP.PlayerModelBones["ValveBiped.Bip01_L_Finger31"] 	= "Bip01_L_Finger31"
	SWEP.PlayerModelBones["ValveBiped.Bip01_L_Finger32"] 	= "Bip01_L_Finger32"
	SWEP.PlayerModelBones["ValveBiped.Bip01_L_Finger2"] 	= "Bip01_L_Finger2"
	SWEP.PlayerModelBones["ValveBiped.Bip01_L_Finger21"] 	= "Bip01_L_Finger21"
	SWEP.PlayerModelBones["ValveBiped.Bip01_L_Finger22"] 	= "Bip01_L_Finger22"
	SWEP.PlayerModelBones["ValveBiped.Bip01_L_Finger1"] 	= "Bip01_L_Finger1"
	SWEP.PlayerModelBones["ValveBiped.Bip01_L_Finger11"] 	= "Bip01_L_Finger11"
	SWEP.PlayerModelBones["ValveBiped.Bip01_L_Finger12"] 	= "Bip01_L_Finger12"
	SWEP.PlayerModelBones["ValveBiped.Bip01_L_Finger0"] 	= "Bip01_L_Finger0"
	SWEP.PlayerModelBones["ValveBiped.Bip01_L_Finger01"] 	= "Bip01_L_Finger01"
	SWEP.PlayerModelBones["ValveBiped.Bip01_L_Finger02"] 	= "Bip01_L_Finger02"
	
	//SWEP.PlayerModelBones["ValveBiped.Bip01_R_Forearm"] 	= "Arm"
	//SWEP.PlayerModelBones["ValveBiped.Bip01_R_Hand"] 		= "Hand"

	SWEP.OverrideAngle = {}
	
	//SWEP.OverrideAngle["Arm"] = Angle(-90,0,90)
	SWEP.OverrideAngle["Bip01_L_Forearm"] = Angle(0,0,0)
	SWEP.OverrideAngle["Bip01_L_Hand"] = Angle(0,0,0)
	
	SWEP.OverrideTranslation = {}
	SWEP.OverrideTranslation["Bip01_L_Forearm"] = Vector(3,0,0)
	*/

end

--SWEP.IronSightsPos = Vector(-4.5, -9.6, 3.1)
--SWEP.IronSightsAng = Vector(1.1, 0.6, -3.3)

SWEP.Drain = 2

SWEP.HealDistance = 80

local restoretimer = 0

function SWEP:OnInitialize()
	self.HealTime = 0
	self.HealSound = CreateSound(self.Weapon,"items/medcharge4.wav")
	self.EmptySound = Sound("items/medshotno1.wav")
end

function SWEP:FindPlayer( dis )
	local trace = self.Owner:TraceLine(dis)
	if trace.HitNonWorld then
		local target = trace.Entity
		if target:IsPlayer() then
			return target
		end
	end
	return
end

function SWEP:HealStart()
	self.Primary.Automatic = true
	self.Weapon:EmitSound(self.Primary.Sound)
	if SERVER then
		self.HealSound:Play()
	end			
end

function SWEP:HealStop()
	self.HealTime = CurTime()+self.Primary.Delay*2 -- prohibits heal button smashing
	self.Primary.Automatic = false
	self.Weapon:EmitSound(self.EmptySound)
	if SERVER then
		self.HealSound:Stop()
	end		
end

SWEP.target = nil
SWEP.healstack = 0

function SWEP:PrimaryAttack()

	local ply = self.Owner
	if (ply.EquipedSuit == "suppliesboosterpack") then
		self.Weapon:SetNextPrimaryFire(CurTime() + (self.Primary.Delay*0.666))
	else
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	end
	if not self:CanPrimaryAttack() then return end

	self.target = self.target or self:FindPlayer(self.HealDistance)
	
	if self.target ~= nil and self.target:IsValid() and self.target:Team() == self.Owner:Team()
		and self.target:GetPos():Distance(self.Owner:GetShootPos()) < self.HealDistance*1.5 and self.target:Alive() then
		if self.target:Health() < self.target:GetMaximumHealth() then -- and if it doesn't have full hp
			local prevhp = self.target:Health()
			self.target:SetHealth(math.min(self.target:Health()+2,self.target:GetMaximumHealth()))
			local drain = self.Drain
			if ply:HasBought("efficientexchange") then
				drain = drain * 0.7
			end
			ply:SetSuitPower(ply:SuitPower()-drain)
			if CLIENT then -- Emit some nice looking particles...
				local pos = self.target:GetPos()+Vector(0,0,50)
				self:EmitHealParticles( pos )
			end				
			if SERVER then
				self:UpdateHealScore( self.target, prevhp )
			end
		elseif self.Primary.Automatic then
			if CLIENT then
				self.Owner:PrintMessage(HUD_PRINTTALK,"Target player is full")
			end
			self:HealStop()
		end
	else
		self.target = nil
		self:HealStop()
	end
	
	if CLIENT then
		//self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end

end

local fired = false

function SWEP:OnThink()
 
	local ply = self.Owner
	   
	if ply:KeyPressed(IN_ATTACK) and self:CanPrimaryAttack() then
		local target = self:FindPlayer(self.HealDistance)
		if target ~= nil then
			if target:Health() < target:GetMaximumHealth() then
				self:HealStart()
			elseif self.Primary.Automatic then
				if CLIENT then
					self.Owner:PrintMessage(HUD_PRINTTALK,"Target player is full")
				end
				self:HealStop()
			end			
		else
			self:HealStop()
		end
	end
	
	if ply:KeyReleased(IN_ATTACK) and SERVER then
		self.Primary.Automatic = true
		self.HealSound:Stop()
	end

end 

function SWEP:CanPrimaryAttack()
	local ply = self.Owner
	if ply:SuitPower() <= self.Drain and self.HealTime < CurTime() then
		self.Weapon:EmitSound(self.EmptySound)
		return false
	end
	return true
end

function SWEP:SecondaryAttack()

end
