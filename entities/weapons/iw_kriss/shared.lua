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
	SWEP.PrintName = "Kriss"			
	SWEP.Slot = 2
	SWEP.SlotPos = 1
	SWEP.IconLetter = "x"
	killicon.Add( "iw_kriss", "killicon/infectedwars/kriss", Color(255, 80, 0, 255 ) )
	--killicon.AddFont("iw_kriss", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255 ))
	
	//define our new bones!
	SWEP.PlayerModelBones = {}
	
	SWEP.PlayerModelBones["ValveBiped.Bip01_R_Forearm"] 	= "Bone02"
	SWEP.PlayerModelBones["ValveBiped.Bip01_R_Hand"] 		= "Bone03"

	SWEP.PlayerModelBones["ValveBiped.Bip01_R_Finger4"] 	= "Bone16"
	SWEP.PlayerModelBones["ValveBiped.Bip01_R_Finger41"] 	= "Bone17"
	SWEP.PlayerModelBones["ValveBiped.Bip01_R_Finger42"] 	= "Bone18"
	SWEP.PlayerModelBones["ValveBiped.Bip01_R_Finger3"] 	= "Bone12"
	SWEP.PlayerModelBones["ValveBiped.Bip01_R_Finger31"] 	= "Bone13"
	SWEP.PlayerModelBones["ValveBiped.Bip01_R_Finger32"] 	= "Bone14"
	SWEP.PlayerModelBones["ValveBiped.Bip01_R_Finger2"] 	= "Bone08"
	SWEP.PlayerModelBones["ValveBiped.Bip01_R_Finger21"] 	= "Bone09"
	SWEP.PlayerModelBones["ValveBiped.Bip01_R_Finger22"] 	= "Bone10"
	SWEP.PlayerModelBones["ValveBiped.Bip01_R_Finger1"] 	= "Bone04"
	SWEP.PlayerModelBones["ValveBiped.Bip01_R_Finger11"] 	= "Bone05"
	SWEP.PlayerModelBones["ValveBiped.Bip01_R_Finger12"] 	= "Bone06"
	SWEP.PlayerModelBones["ValveBiped.Bip01_R_Finger0"] 	= "Bone20"
	SWEP.PlayerModelBones["ValveBiped.Bip01_R_Finger01"] 	= "Bone21"
	SWEP.PlayerModelBones["ValveBiped.Bip01_R_Finger02"] 	= "Bone22"
	---------------
	SWEP.PlayerModelBones["ValveBiped.Bip01_L_Forearm"] 	= "Bone25"
	SWEP.PlayerModelBones["ValveBiped.Bip01_L_Hand"] 		= "Bone26"

	SWEP.PlayerModelBones["ValveBiped.Bip01_L_Finger4"] 	= "Bone43"
	SWEP.PlayerModelBones["ValveBiped.Bip01_L_Finger41"] 	= "Bone44"
	SWEP.PlayerModelBones["ValveBiped.Bip01_L_Finger42"] 	= "Bone45"
	SWEP.PlayerModelBones["ValveBiped.Bip01_L_Finger3"] 	= "Bone39"
	SWEP.PlayerModelBones["ValveBiped.Bip01_L_Finger31"] 	= "Bone40"
	SWEP.PlayerModelBones["ValveBiped.Bip01_L_Finger32"] 	= "Bone41"
	SWEP.PlayerModelBones["ValveBiped.Bip01_L_Finger2"] 	= "Bone35"
	SWEP.PlayerModelBones["ValveBiped.Bip01_L_Finger21"] 	= "Bone36"
	SWEP.PlayerModelBones["ValveBiped.Bip01_L_Finger22"] 	= "Bone37"
	SWEP.PlayerModelBones["ValveBiped.Bip01_L_Finger1"] 	= "Bone31"
	SWEP.PlayerModelBones["ValveBiped.Bip01_L_Finger11"] 	= "Bone32"
	SWEP.PlayerModelBones["ValveBiped.Bip01_L_Finger12"] 	= "Bone33"
	SWEP.PlayerModelBones["ValveBiped.Bip01_L_Finger0"] 	= "Bone27"
	SWEP.PlayerModelBones["ValveBiped.Bip01_L_Finger01"] 	= "Bone28"
	SWEP.PlayerModelBones["ValveBiped.Bip01_L_Finger02"] 	= "Bone29"
	
	SWEP.OverrideAngle = {}
	SWEP.OverrideAngle["Bone03"] = Angle(0,180,90)
	SWEP.OverrideAngle["Bone02"] = Angle(0,180,180)
	
	SWEP.OverrideAngle["Bone25"] = Angle(0,180,180)
	SWEP.OverrideAngle["Bone26"] = Angle(0,180,90)
	
	SWEP.OverrideTranslation = {}
	SWEP.OverrideTranslation["Bone26"] = Vector(0.3,0.4,0)
	
	SWEP.IgnoreThumbs = true
	
end

function SWEP:InitializeClientsideModels()
	
	self.VElements = {
		["ammo"] = { type = "Quad", bone = "body", rel = "", pos = Vector(-0.445, 1.105, 1.613), angle = Angle(0, 0, 91.267), size = 0.012, draw_func = function(wep) DrawWeaponInfo(wep) end}
	}

	self.WElements = {}
	
end

SWEP.Base				= "iw_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_smg_kriss.mdl"
SWEP.WorldModel			= "models/weapons/infectedwars/w_smg_kriss.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("Kriss.Single2")//Sound("weapons/Kriss/kriss-2.wav")
SWEP.Primary.Recoil			= 1.8
SWEP.Primary.Damage			= 16
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 28
SWEP.Primary.Delay			= 0.08
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize * 5
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"
SWEP.Primary.Cone			= 0.065
SWEP.Primary.ConeMoving		= 0.14
SWEP.Primary.ConeCrouching	= 0.045

SWEP.MuzzleEffect			= "rg_muzzle_rifle"
SWEP.ShellEffect			= "rg_shelleject" 

if CLIENT then
	local kriss = surface.GetTextureID("killicon/infectedwars/kriss")
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		 
		surface.SetDrawColor( Color( 255, 210, 0, 255 ))
		surface.SetTexture(kriss)
		surface.DrawTexturedRect(x+wide/2-(wide*0.5)/2,y+tall/2-(tall*0.7)/2,wide*0.5,tall*0.7)
		
		// Draw weapon info box
		self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )
	end
end

--SWEP.IronSightsPos = Vector(4.72,-2,1.86)
--SWEP.IronSightsAng = Vector(1.2,-.15,0)