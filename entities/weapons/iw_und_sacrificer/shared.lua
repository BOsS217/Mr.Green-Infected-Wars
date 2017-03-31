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

if( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "melee"
SWEP.Base = "iw_base_dummy"
if( CLIENT ) then
	SWEP.PrintName = "Baby Sacrificer"
	SWEP.DrawCrosshair = false
	SWEP.Slot = 4
	SWEP.SlotPos = 1
	
	SWEP.IgnoreBonemerge = true
	SWEP.UseHL2Bonemerge = true
	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false 

	
end

function SWEP:InitializeClientsideModels()
	
	self.ViewModelBoneMods = {
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-1.67, -11.332, 44.681) },
		["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0.531, 5.425, -4.514), angle = Angle(-12.006, -12.763, 0) },
		["ValveBiped.Grenade_body"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 16.725, 0) }
	}
	
	self.VElements = {
		["eye1"] = { type = "Sprite", sprite = "effects/redflare", bone = "ValveBiped.Bip01", rel = "baby", pos = Vector(2.387, 0.619, 3.75), size = { x = 4.843, y = 4.843 }, color = Color(255, 255, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = true},
		["baby"] = { type = "Model", model = "models/props_c17/doll01.mdl", bone = "ValveBiped.Grenade_body", rel = "", pos = Vector(-0.057, 0.437, -0.812), angle = Angle(-150.681, 35.513, 10.23), size = Vector(0.805, 0.805, 0.805), color = Color(160, 160, 160, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["eye1+"] = { type = "Sprite", sprite = "effects/redflare", bone = "ValveBiped.Bip01", rel = "baby", pos = Vector(2.292, -0.663, 3.763), size = { x = 5.524, y = 5.524 }, color = Color(255, 255, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = true}
	}
	self.WElements = {
		["baby"] = { type = "Model", model = "models/props_c17/doll01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.767, 2.469, -0.812), angle = Angle(-12.231, -147.508, 180), size = Vector(0.755, 0.755, 0.755), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
end

SWEP.NoDeployDelay = true

------------------------------------------------------------------------------------------------------
SWEP.Author			= "" -- ClavusElite
SWEP.Instructions	= "Left click to place sacrifical baby. This will become your spawnpoint. Right click to kill your baby, in exchange for full health!" 
SWEP.NextPlant = 0
------------------------------------------------------------------------------------------------------
SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
------------------------------------------------------------------------------------------------------
SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.ViewModel = "models/Weapons/v_Grenade.mdl"
SWEP.WorldModel = "models/props_c17/doll01.mdl"

------------------------------------------------------------------------------------------------------
SWEP.Primary.Delay			= 1.5 	
SWEP.Primary.Recoil			= 0		
SWEP.Primary.Damage			= 7	
SWEP.Primary.NumShots		= 1		
SWEP.Primary.Cone			= 0 	
SWEP.Primary.ClipSize		= 1 -- You can't have more than 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic   	= false
SWEP.Primary.Ammo         	= "none"	
------------------------------------------------------------------------------------------------------
SWEP.Secondary.Delay		= 0.9
SWEP.Secondary.Recoil		= 0
SWEP.Secondary.Damage		= 6
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic   	= false
SWEP.Secondary.Ammo         = "none"
------------------------------------------------------------------------------------------------------

function SWEP:OnInitialize()
	self:SetDTEntity(0,nil)
end

function SWEP:OnDeploy()
	self.Owner:SetColor(255,255,255,255)
end

function SWEP:Precache()
	util.PrecacheSound("npc/fast_zombie/fz_alert_close1.wav")
	util.PrecacheModel("props_c17/doll01.mdl")
end

function SWEP:PrimaryAttack()
	if( CurTime() < self.NextPlant ) or not self:CanPrimaryAttack() then return end
	self.NextPlant = ( CurTime() + 0.1 )
	
	if not SERVER then return end
	
	local tur = self:GetDTEntity(0)
	if tur and tur:IsValid() and tur:Alive() then
		tur:GetTable():Eliminate()
	end
	
	self:SetDTEntity(0,nil)
	
	local trace = {}
	trace.start = self.Owner:GetShootPos()
	trace.endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 84
	trace.mask = MASK_NPCWORLDSTATIC
	trace.filter = self.Owner
	local tr = util.TraceLine( trace )
	
	if ( tr.Hit ) then
		
		local isFree = CheckCollisionBox(tr.HitPos+Vector(0,0,75), self.Owner:GetAimVector(),30,30,100,self.Owner)
		-- Check if there are no other babies near
		for k, v in pairs( ents.FindInSphere( tr.HitPos+Vector(0,0,20), 48 ) ) do
			if (v:GetClass() == "sacrifical_baby" and v:GetDTBool( 0 )) then
				isFree = false
				break
			end
		end
		
		if not isFree then
			self.Owner:PrintMessage(HUD_PRINTTALK,"Not enough free space to place sacrifical baby!")
		elseif self.Owner:WaterLevel() > 1 then
			self.Owner:PrintMessage(HUD_PRINTTALK,"You'll drown the baby smartass!")
		else
			local ent = ents.Create ("sacrifical_baby")
			if ( ent ~= nil and ent:IsValid() ) then
				ent:SetPos(tr.HitPos+Vector(0,0,20))
				ent:SetAngles(Angle(0,self.Owner:GetAimVector():Angle().y,0)) -- ?? Angle( roll, pitch, yaw) or Angle( pitch, yaw, roll) ??
				ent:SetOwner(self.Owner)
				ent:Spawn()
				ent:Activate()
				
				ent:GetTable():SetDrawPos(tr.HitPos)
				
				self.Owner.BabySpawn = ent
				
				self.Owner:EmitSound( "npc/fast_zombie/fz_alert_close1.wav" )
				
				self:TakePrimaryAmmo( 1 )
				
				self:SetDTEntity(0,ent)
			end
		end
	end
end

 function SWEP:Reload() 
	return false
 end  

function SWEP:SecondaryAttack()
	if ENDROUND then return end -- some kind of spamming exploit
	local baby = self:GetDTEntity(0)
	if baby and baby:IsValid() and SERVER and baby:GetTable():Alive() and baby:GetDTBool( 0, false ) then
		baby:GetTable():Eliminate()
		self.Owner:ChatPrint("Baby sacrificed, health regained!")
		self.Owner:SetHealth(self.Owner:GetMaximumHealth())
	end
end 

if CLIENT then

	function SWEP:DrawHUD()

		local trace = {}
		trace.start = self.Owner:GetShootPos()
		trace.endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 84
		trace.mask = MASK_NPCWORLDSTATIC
		trace.filter = self.Owner
		local tr = util.TraceLine( trace )
		
		if not tr.Hit then return end
		
		local aimv = self.Owner:GetAimVector()
		local startv = tr.HitPos+Vector(0,0,10)
		local forv = Vector(aimv.x,aimv.y,0):Normalize()*20
		local rotv = aimv -- rotating modifies the vector its applied to
		rotv:Rotate(Angle(0,270,0))
		local rightv = Vector(rotv.x,rotv.y,0):Normalize()*20
		for k, v in pairs( { {(forv-rightv),(-1*forv-rightv)},{(-1*forv+rightv),(forv+rightv)}, 
			{(forv+rightv),(forv-rightv)},{(-1*forv-rightv),(-1*forv+rightv)}} ) do
			local pos1 = (startv+v[1]):ToScreen()
			local pos2 = (startv+v[2]):ToScreen()
			surface.SetDrawColor( COLOR_RED )
			surface.DrawLine( pos1.x, pos1.y, pos2.x, pos2.y )
			draw.SimpleTextOutlined("o","InfoSmall",pos2.x,pos2.y,COLOR_GRAY, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, COLOR_BLACK)
		end
		/*local hitscreen = tr.HitPos:ToScreen()
		draw.SimpleTextOutlined("0.0","InfoSmall",hitscreen.x,hitscreen.y,COLOR_GRAY, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, COLOR_BLACK)
		
		local center = tr.HitPos+Vector(0,0,70)
		local width = 30
		local length = 30
		local height = 110
		local dir = self.Owner:GetAimVector()
		
		local points = {}
		local aimv = dir:Normalize()
		local startv = center-Vector(0,0,height/2)
		local forv = Vector(aimv.x,aimv.y,0):Normalize()*(length/2)
		local rotv = aimv -- rotating modifies the vector its applied to
		rotv:Rotate(Angle(0,270,0))
		local rightv = Vector(rotv.x,rotv.y,0):Normalize()*(width/2)
		local upv = Vector(0,0,height)
		
		for k, v in pairs( {(forv-rightv), (-1*forv-rightv), (forv+rightv), (-1*forv+rightv)} ) do
			table.insert(points, startv+v+upv)
			table.insert(points, startv+v)
		end

		local ignorePoints = {}
		
		for k, v in pairs(points) do
			table.insert(ignorePoints,v) -- avoid double tracing
			for i, j in pairs(points) do
				if not table.HasValue(ignorePoints,j) then
					local pos1 = v:ToScreen()
					local pos2 = j:ToScreen()
					surface.SetDrawColor( Color(255,0,0) )
					surface.DrawLine( pos1.x, pos1.y, pos2.x, pos2.y )
					draw.SimpleTextOutlined("o","InfoSmall",pos2.x,pos2.y,COLOR_GRAY, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, COLOR_BLACK)
				end
			end
		end
		*/
	end

	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		draw.SimpleText( "BABY", "DoomSmaller", x + wide/2, y + tall*0.3, Color( 255, 210, 0, 255 ), TEXT_ALIGN_CENTER )
		// Draw weapon info box
		self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )
	end
end