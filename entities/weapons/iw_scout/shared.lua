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
	SWEP.PrintName = "Scout Sniper"
	SWEP.Author	= "ClavusElite"
	SWEP.Slot = 3
	SWEP.SlotPos = 1
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = true
	
	SWEP.IconLetter = "n"
	killicon.AddFont("iw_scout", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255 ))
end

function SWEP:InitializeClientsideModels()
	
	self.VElements = {
		["ammo"] = { type = "Quad", bone = "v_weapon.scout_Parent", rel = "", pos = Vector(-0.575, 2.418, 5.425), angle = Angle(0, 0, 178.13), size = 0.012, draw_func = function(wep) DrawWeaponInfo(wep) end}
	}

	self.WElements = {}
	
end

SWEP.Base				= "iw_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_snip_scout.mdl"
SWEP.WorldModel			= "models/weapons/w_snip_scout.mdl"

SWEP.Weight				= 6
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("Weapon_Scout.Single")
SWEP.Primary.Recoil			= 3.0
SWEP.Primary.Damage			= 40
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 6
SWEP.Primary.Delay			= 1.8
SWEP.Primary.DefaultClip	= 22
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "XBowBolt"
SWEP.Primary.ReloadDelay	= 1.5
SWEP.Primary.Cone			= 0.11
SWEP.Primary.ConeMoving		= 0.17
SWEP.Primary.ConeCrouching	= 0.08
SWEP.Primary.OrigCone		= SWEP.Primary.Cone
SWEP.Primary.OrigConeMoving	= SWEP.Primary.ConeMoving
SWEP.Primary.OrigConeCrouching = SWEP.Primary.ConeCrouching
SWEP.Primary.ZoomedCone		= 0.01
SWEP.Primary.ZoomedConeMoving = 0.06
SWEP.Primary.ZoomedConeCrouching = 0

SWEP.MuzzleEffect			= "rg_muzzle_rifle"
SWEP.ShellEffect			= "rg_shelleject_rifle" 
SWEP.EjectDelay				= 0.53

SWEP.Secondary.Delay = 0.5

SWEP.NextReload = 0

SWEP.ZoomSound = Sound("weapons/sniper/sniper_zoomin.wav")
SWEP.DeZoomSound = Sound("weapons/sniper/sniper_zoomout.wav")
SWEP.ZoomFOV = 20

SWEP.IronSightsPos 			= Vector (4.9906, -9.5434, 2.5078)
SWEP.IronSightsAng 			= Vector (0, 0, 0)

function SWEP:Reload()
	self.Weapon:DefaultReload(ACT_VM_RELOAD)

	-- unzoom while reloading
	self:SetZoom(false)
end

function SWEP:OnDeploy()
	if SERVER then
		self.OldFOV = self.Owner:GetFOV()
	end
end

function SWEP:OnInitialize()
	//self:SetWeaponHoldType(self.HoldType)
	
	self.dt.ironsights = false
	self.dt.zoomed = false
end

function SWEP:SetupDataTables()

	self:DTVar( "Bool", 0, "zoomed" )
	self:DTVar( "Bool", 1, "ironsights" )

end


function SWEP:SecondaryAttack()
	self.Weapon.NextZoom = self.Weapon.NextZoom or CurTime()
	if CurTime() < self.Weapon.NextZoom then return end
	self.Weapon.NextZoom = CurTime() + self.Secondary.Delay

	local zoomed = !self.dt.zoomed
	
	self:SetZoom(zoomed)
end

function SWEP:SetZoom( b )
	
	if SERVER then self.Owner.IsUsingScope = b end
	
	if ( self.dt.zoomed == b ) then return end
	
	if (b == false) then
		if SERVER then
			self.Owner:SetFOV(self.OldFOV or 75, 0.5)
			self.Weapon:EmitSound(self.DeZoomSound, 50, 100)
			self.Owner:DrawViewModel(true)
		else
			self.FadeAlpha = 255
			self.Scoped = false
			DrawCrHair = true
			surface.PlaySound(self.DeZoomSound)
		end
		self.Primary.Cone			= self.Primary.OrigCone
		self.Primary.ConeMoving		= self.Primary.OrigConeMoving
		self.Primary.ConeCrouching	= self.Primary.OrigConeCrouching
		
		self:SetIronsights(false)
	else
		if SERVER then
			self.Owner:SetFOV(self.ZoomFOV, 0.5)
			self.Weapon:EmitSound(self.ZoomSound, 50, 100)
			timer.Simple(0.45,function()
				if not IsValid(self.Owner) then return end
				self.Owner:DrawViewModel(false)
			end)
		else
			timer.Simple(0.5,function()
				self.Scoped = true
			end)
			DrawCrHair = false
			surface.PlaySound(self.ZoomSound)
		end
		self.Primary.Cone			= self.Primary.ZoomedCone
		self.Primary.ConeMoving		= self.Primary.ZoomedConeMoving
		self.Primary.ConeCrouching	= self.Primary.ZoomedConeCrouching
		
		self:SetIronsights(true)
	end
	
	self.dt.zoomed = b
end

function SWEP:OnHolster()
	if SERVER then
		if self.Owner then
			self.Owner:SetFOV(self.OldFOV or 75, 0.5)
		end
	end
	self:SetZoom(false)
	return !self.dt.zoomed
end

function SWEP:_OnRemove()
	self:SetZoom(false)
end

if CLIENT then

	function SWEP:AdjustMouseSensitivity()
		if self.dt.zoomed then return 0.4 end
	end
	
	SWEP.Scoped = false
	SWEP.FadeAlpha = 0
	SWEP.FadeSpeed = 800
	
	-- Replaces the DrawHUD function because I want to draw my HUD in front of the scope
	local scope = surface.GetTextureID("sprites/scope")
	function SWEP:DrawScope()
		if self.dt.zoomed then
			if self.Scoped then
				if self.FadeAlpha > 0 then
					self.FadeAlpha = math.max(0,self.FadeAlpha-FrameTime()*self.FadeSpeed)
					surface.SetDrawColor(0, 0, 0, self.FadeAlpha)
					surface.DrawRect(0, 0, w, h)
				end
				
						surface.SetDrawColor( 0, 0, 0, 255 )
						
				        local x = ScrW() / 2.0
						local y = ScrH() / 2.0
						local scope_size = ScrH()

						-- crosshair
						local gap = 80
						local length = scope_size
						surface.DrawLine( x - length, y, x - gap, y )
						surface.DrawLine( x + length, y, x + gap, y )
						surface.DrawLine( x, y - length, x, y - gap )
						surface.DrawLine( x, y + length, x, y + gap )

						gap = 0
						length = 50
						surface.DrawLine( x - length, y, x - gap, y )
						surface.DrawLine( x + length, y, x + gap, y )
						surface.DrawLine( x, y - length, x, y - gap )
						surface.DrawLine( x, y + length, x, y + gap )


						-- cover edges
						local sh = scope_size / 2
						local w = (x - sh) + 2
						surface.DrawRect(0, 0, w, scope_size)
						surface.DrawRect(x + sh - 2, 0, w, scope_size)

						surface.SetDrawColor(255, 0, 0, 255)
						surface.DrawLine(x, y, x + 1, y + 1)

						-- scope
						surface.SetTexture(scope)
						surface.SetDrawColor(255, 255, 255, 255)

						surface.DrawTexturedRectRotated(x, y, scope_size, scope_size, 0)

						local dist = 0
				
						local tr = MySelf:GetEyeTrace()
				
						if tr.Hit then
							dist = math.Round(MySelf:GetShootPos():Distance(tr.HitPos))
							draw.SimpleTextOutlined("Distance: "..dist, "ChatFont",ScrW()/2+100,ScrH()/2,Color(255,255,255,255),TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,0.1, Color(0,0,0,255))
						end	
			else
				if self.FadeAlpha <= 255 then
					self.FadeAlpha = math.min(255,self.FadeAlpha+FrameTime()*self.FadeSpeed)
					surface.SetDrawColor(0, 0, 0, self.FadeAlpha)
					surface.DrawRect(0, 0, w, h)
				end
			end
		else
			if self.FadeAlpha > 0 then
				self.FadeAlpha = math.max(0,self.FadeAlpha-FrameTime()*self.FadeSpeed)
				surface.SetDrawColor(0, 0, 0, self.FadeAlpha)
				surface.DrawRect(0, 0, w, h)
			end
		end
	end
end
