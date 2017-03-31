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

if SERVER then AddCSLuaFile( "shared.lua" ) end

//Melee base
SWEP.Base = "iw_base_melee"

//Models paths
SWEP.Author = "Clavus"
SWEP.Instructions = "Swing at enemies. Disorients (read: fucks up screen) them on hit."

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

if CLIENT then

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
SWEP.IgnoreBonemerge = true
SWEP.RotateFingers = Angle(12,-35,0)
end

function SWEP:InitializeClientsideModels()
	
	self.VElements = {
		["crowbar"] = { type = "Model", model = "models/weapons/w_crowbar.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.456, 1.562, 1.044), angle = Angle(93.392, -34.156, 180), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} }
	}
	self.WElements = {
		["crowbar"] = { type = "Model", model = "models/Weapons/w_crowbar.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.467, 1.606, -5.575), angle = Angle(85.319, 160.675, -3.695), size = Vector(1, 1.212, 1.212), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} }
	}
	
end

//Name and fov
SWEP.PrintName = "Crowbar of Death"
SWEP.ViewModelFOV = 65

//Position
SWEP.Slot = 0
SWEP.SlotPos = 1

SWEP.HoldType = "melee"

SWEP.MeleeDamage = 30
SWEP.MeleeRange = 55
SWEP.MeleeSize = 0.575

SWEP.Primary.Delay = 1.15

SWEP.NoHitSoundFlesh = true 

//SWEP.HitDecal = "Manhackcut"

function SWEP:PlaySwingSound()
	self:EmitSound("Weapon_Crowbar.Single")
end

function SWEP:PlayHitSound()
	self:EmitSound("Weapon_Crowbar.Melee_HitWorld")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/flesh/flesh_impact_bullet"..math.random(1,5)..".wav")
end

//Killicon
if CLIENT then 
SWEP.IconLetter = "6"
killicon.AddFont("iw_und_crowbar", "HL2MPTypeDeath", SWEP.IconLetter, Color(255, 80, 0, 255 ))
end

if CLIENT then
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		draw.SimpleText( "6", "HL2MPTypeDeath", x + wide/2, y + tall*0.3, Color( 255, 210, 0, 255 ), TEXT_ALIGN_CENTER )
		// Draw weapon info box
		self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )
	end
end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)
	if SERVER then
		if hitent:IsPlayer() and hitent:Team() ~= self.Owner:Team() then
			hitent:SendLua("StalkerFuck(5)") -- >:3
		end
		local phys = hitent:GetPhysicsObject()
		if phys:IsValid() then
			phys:ApplyForceOffset(self.Owner:GetForward() * 9000, tr.HitPos)
		end

	end
end
 

function SWEP:Precache()
	util.PrecacheSound("weapons/knife/knife_slash1.wav")
	util.PrecacheSound("weapons/knife/knife_slash2.wav")
end
