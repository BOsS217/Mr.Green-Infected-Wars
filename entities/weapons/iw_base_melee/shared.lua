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
	AddCSLuaFile("cl_init.lua")
end

SWEP.ViewModel = "models/weapons/v_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"
SWEP.DrawCrosshair = false
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 1


SWEP.MeleeDamage = 30
SWEP.MeleeRange = 62
SWEP.MeleeSize = 1.5
SWEP.MeleeKnockBack = 0

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.WalkSpeed = 200

SWEP.IsMelee = true

SWEP.HoldType = "melee"
SWEP.SwingHoldType = "grenade"

SWEP.DamageType = DMG_SLASH

SWEP.BloodDecal = "Blood"
SWEP.HitDecal = "Impact.Concrete"

SWEP.HitAnim = ACT_VM_HITCENTER
SWEP.MissAnim = ACT_VM_MISSCENTER

SWEP.SwingTime = 0
SWEP.SwingRotation = Angle(0, 0, 0)
SWEP.SwingOffset = Vector(0, 0, 0)

function SWEP:InitializeClientsideModels()
	
	self.VElements = {}
	self.WElements = {} 
	
end


function SWEP:Initialize()
	self:SetDeploySpeed(1.1)
	self:SetWeaponHoldType(self.HoldType)
	self:SetWeaponSwingHoldType(self.SwingHoldType)
	
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
	if !self.VElements then
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

function SWEP:SetWeaponSwingHoldType(t)
	local old = self.ActivityTranslate
	self:SetWeaponHoldType(t)
	local new = self.ActivityTranslate
	self.ActivityTranslate = old
	self.ActivityTranslateSwing = new
end

function SWEP:TranslateActivity(act)
	if self:GetSwingEnd() ~= 0 and self.ActivityTranslateSwing[act] ~= nil then
		return self.ActivityTranslateSwing[act]
	end

	if self.ActivityTranslate[act] ~= nil then
		return self.ActivityTranslate[act]
	end

	return -1
end

function SWEP:IsMelee()
	return true
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim ( ACT_VM_DRAW )
	
	self:OnDeploy()
	
	//self.Owner:StopAllLuaAnimations()
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	return true
end

function SWEP:OnRemove()
	
	// other onremove code goes here
	RemoveNewArms(self)
	if CLIENT then
		self:RemoveModels()
		if self and IsValid(self.Owner) then
			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				vm:SetMaterial("")
			end
		end
		//RestoreViewmodel(self.Owner)
	end
	
end

function SWEP:Equip ( NewOwner )
end

function SWEP:Think()
	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		//self:SendWeaponAnim(ACT_VM_IDLE)
	end

	if self:IsSwinging() and self:GetSwingEnd() <= CurTime() then
		self:StopSwinging()
		self:MeleeSwing()
	end

	--[[if self:GetNetworkedBool("Defending") and not self.Owner:KeyDown(IN_RELOAD) then
		self:SetDefending(false)
	end]]
end

function SWEP:OnDeploy()
//MakeNewArms(self)
end
function SWEP:OnDrop()
//RemoveNewArms(self)
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
	--[[if self.DefendPos and self:GetNextPrimaryFire() <= CurTime() then
		self:SetDefending(true)
	end]]

	return false
end

--[[function SWEP:SetDefending(onoff)
	self:SetNetworkedBool("Defending", onoff)

	if onoff then
		self.DefendingLerp = CurTime() + 0.2
	else
		self.DefendingLerp = CurTime() + 0.2
	end
end

function SWEP:GetDefending()
	return self:GetNetworkedBool("Defending")
end]]

function SWEP:CanPrimaryAttack()
	return not self:IsSwinging()//self:GetNextPrimaryFire() <= CurTime() and
end

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
end

function SWEP:PlayStartSwingSound()
	--[[local snd = "npc/combine_soldier/gear"..math.random(6)..".wav"
	self:EmitSound(snd, 60, math.Clamp((SoundDuration(snd) / self.SwingTime) * 100, 50, 240))]]
end

function SWEP:PlayHitSound()
	
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if not self:CanPrimaryAttack() then return end

	if self.SwingTime == 0 then
		self:MeleeSwing()
	else
		self:StartSwinging()
	end
end

function SWEP:Holster()
	--RemoveNewArms(self)
	 if CLIENT then
		
		RestoreViewmodel(self.Owner)
    end
	return CurTime() >= self:GetSwingEnd()
end

function SWEP:StartSwinging()
	if self.StartSwingAnimation then
		self:SendWeaponAnim(self.StartSwingAnimation)
		self.IdleAnimation = CurTime() + self:SequenceDuration()
	end
	self:PlayStartSwingSound()
	self:SetSwingEnd(CurTime() + self.SwingTime)
end

function SWEP:MeleeSwing()
	local owner = self.Owner

	//owner:DoAttackEvent()
	owner:SetAnimation(PLAYER_ATTACK1)
	local filter = owner:GetMeleeFilter()

	owner:LagCompensation(true)

	local tr = owner:MeleeTrace(self.MeleeRange, self.MeleeSize, filter)
	if tr.Hit then
		local damage = self.MeleeDamage * (owner.HumanMeleeDamageMultiplier or 1)
		local hitent = tr.Entity
		local hitflesh = tr.MatType == MAT_FLESH or tr.MatType == MAT_BLOODYFLESH or tr.MatType == MAT_ANTLION or tr.MatType == MAT_ALIENFLESH

		if self.HitAnim then
			self.Weapon:SendWeaponAnim(self.HitAnim)
		end
		self.IdleAnimation = CurTime() + self:SequenceDuration()*2

		if hitflesh then
			util.Decal(self.BloodDecal, tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
			self:PlayHitFleshSound()
			if SERVER and not (hitent:IsValid() and hitent:IsPlayer() and hitent:Team() == owner:Team()) and math.random(1,2) == 1 then
				//util.Blood(tr.HitPos, math.Rand(damage * 0.25, damage * 0.6), (tr.HitPos - owner:GetShootPos()):Normalize(), math.Rand(damage * 6, damage * 12), true)
			end
			if not self.NoHitSoundFlesh then
				self:PlayHitSound()
			end
		else
			util.Decal(self.HitDecal, tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
			self:PlayHitSound()
		end

		if self.OnMeleeHit and self:OnMeleeHit(hitent, hitflesh, tr) then
			owner:LagCompensation(false)
			return
		end

		if SERVER and hitent:IsValid() then
			if hitent:GetClass() == "func_breakable_surf" then
				hitent:Fire("break", "", 0)
			else
				local dmginfo = DamageInfo()
				dmginfo:SetDamagePosition(tr.HitPos)
				dmginfo:SetDamage(damage)
				dmginfo:SetAttacker(owner)
				dmginfo:SetInflictor(self.Weapon)
				--dmginfo:SetDamageType(DMG_BULLET)
				dmginfo:SetDamageType(self.DamageType)
				dmginfo:SetDamageForce(self.MeleeDamage * 200 * owner:GetAimVector())
				if hitent:IsPlayer() then
					hitent:MeleeViewPunch(damage)
				end//else
					hitent:TakeDamageInfo(dmginfo)
				//end
				--hitent:TakeDamageInfo(dmginfo)

				local phys = hitent:GetPhysicsObject()
				if hitent:GetMoveType() == MOVETYPE_VPHYSICS and phys:IsValid() and phys:IsMoveable() then
					hitent:SetPhysicsAttacker(owner)
				end
			end
		end

		if self.PostOnMeleeHit then self:PostOnMeleeHit(hitent, hitflesh, tr) end

		if CLIENT then
			local tr2 = owner:DoubleTrace(self.MeleeRange, MASK_SHOT, self.MeleeSize, filter)
			if tr2.HitPos == tr.HitPos then
				owner:FireBullets({Num = 1, Src = owner:GetShootPos(), Dir = (tr2.HitPos - owner:GetShootPos()):Normalize(), Spread = Vector(0, 0, 0), Tracer = 0, Force = self.MeleeDamage * 200, Damage = damage, HullSize = self.MeleeSize * 2})
			end
		end
	else
		if self.MissAnim then
			self.Weapon:SendWeaponAnim(self.MissAnim)
		end
		self.IdleAnimation = CurTime() + self:SequenceDuration()
		self:PlaySwingSound()

		if self.PostOnMeleeMiss then self:PostOnMeleeMiss(tr) end
	end

	owner:LagCompensation(false)
end

function SWEP:StopSwinging()
	self:SetSwingEnd(0)
end

function SWEP:IsSwinging()
	return self:GetSwingEnd() > 0
end

function SWEP:SetSwingEnd(swingend)
	self:SetDTFloat(0, swingend)
end

function SWEP:GetSwingEnd()
	return self:GetDTFloat(0)
end

if CLIENT then

	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()
		
		
		if not self.Owner then return end
		if not self.Owner:IsValid() then return end
		if not self.Owner:IsPlayer() then return end
		local vm = self.Owner:GetViewModel()
		if !IsValid(vm) then return end
		
		if not self.OldShowViewModel then
			self.OldShowViewModel = self.ShowViewModel or true
		end
		
		if not self.OldViewModelFlip then
			self.OldViewModelFlip = self.ViewModelFlip or false
		end
		
		if util.tobool(GetConVarNumber("_iw_clhands")) then
			if self.AlwaysDrawViewModel then
				self.ShowViewModel = true
			else
				self.ShowViewModel = false
			end
			//self.ViewModelFlip = false
		else
			//self.ViewModelFlip = self.OldViewModelFlip or false
			self.ShowViewModel = self.OldShowViewModel or true
		end
		
		if (self.ShowViewModel == nil or self.ShowViewModel) then
			vm:SetColor(255,255,255,255)
		else
			// we set the alpha to 1 instead of 0 because else ViewModelDrawn stops being called
			vm:SetColor(255,255,255,1) 
		end
		
		if self.CheckModelElements then
			self:CheckModelElements()	
		end
		
		if self.Owner:Team() == TEAM_UNDEAD then
			if vm:GetMaterial() == "" then
				vm:SetMaterial("models/flesh")
			end
		else
			if vm:GetMaterial() != "" then
				vm:SetMaterial("")
			end
		end
		
		if vm.BuildBonePositions ~= self.BuildViewModelBones then
			vm.BuildBonePositions = self.BuildViewModelBones
		end
		
		UpdateArms(self)

		if (!self.VElements) then return end
		
		if (!self.vRenderOrder) then
			
			// we build a render order because sprites need to be drawn after models
			self.vRenderOrder = {}

			for k, v in pairs( self.VElements ) do
				if (v.type == "Model") then
					table.insert(self.vRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.vRenderOrder, k)
				end
			end
			
		end

		for k, name in ipairs( self.vRenderOrder ) do
		
			local v = self.VElements[name]
			if (!v) then self.vRenderOrder = nil break end
		
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (!v.bone) then continue end
			
			local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
			
			if (!pos) then continue end
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				model:SetModelScale(v.size)
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()
		
		if (self.ShowWorldModel == nil or self.ShowWorldModel) then
			self:DrawModel()
		end
		
		if self.CheckWorldModelElements then
			self:CheckWorldModelElements()	
		end
		
		if (!self.WElements) then return end
		
		if (!self.wRenderOrder) then

			self.wRenderOrder = {}

			for k, v in pairs( self.WElements ) do
				if (v.type == "Model") then
					table.insert(self.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.wRenderOrder, k)
				end
			end

		end
		
		if (IsValid(self.Owner)) then
			bone_ent = self.Owner
		else
			// when the weapon is dropped
			bone_ent = self
		end
		
		for k, name in pairs( self.wRenderOrder ) do
		
			local v = self.WElements[name]
			if (!v) then self.wRenderOrder = nil break end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (!pos) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				model:SetModelScale(v.size)
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel != "") then
			
			local v = basetab[tab.rel]
			
			if (!v) then return end
			
			// Technically, if there exists an element with the same name as a bone
			// you can get in an infinite loop. Let's just hope nobody's that stupid.
			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (!pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			bone = ent:LookupBone(bone_override or tab.bone)

			if (!bone) then return end
			
			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
			
			if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
				ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r // Fixes mirrored models
			end
		
		end
		
		return pos, ang
	end

	function SWEP:CreateModels( tab )

		if (!tab) then return end

		// Create the clientside models here because Garry says we can't do it in the render hook
		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
					string.find(v.model, ".mdl") and file.Exists ("../"..v.model) ) then
				
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) 
				and file.Exists ("../materials/"..v.sprite..".vmt")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				// make sure we create a unique name based on the selected options
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
				
			end
		end
		
	end

	function SWEP:OnRemove()
		self:RemoveModels()
	end

	function SWEP:RemoveModels()
		if (self.VElements) then
			for k, v in pairs( self.VElements ) do
				if (IsValid( v.modelEnt )) then v.modelEnt:Remove() end
			end
		end
		if (self.WElements) then
			for k, v in pairs( self.WElements ) do
				if (IsValid( v.modelEnt )) then v.modelEnt:Remove() end
			end
		end
		self.VElements = nil
		self.WElements = nil
	end

end

