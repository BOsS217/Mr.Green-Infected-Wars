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

-- Clientside X-ray-Heat-Vision
-- Version 1.2
-- by Teta_Bonita

-- Edited by ClavusElite for the Infected Wars gamemode

-- console commands:
-- toggle_xrayvision			-toggles xrayvision on/off

if not CLIENT then return end -- Clientside only

local sndOn = Sound( "items/nvg_on.wav" )
local sndOff = Sound( "items/nvg_off.wav" )

DoXRay = false

local DefMats = {}
local DefClrs = {}

-- A most likely futile attempt to make things faster
local pairs = pairs
local string = string
local render = render

local ColorTab = 
{
	[ "$pp_colour_addr" ] 		= -0.9,
	[ "$pp_colour_addg" ] 		= -0.9,
	[ "$pp_colour_addb" ] 		= -0.2,
	[ "$pp_colour_brightness" ] = 0.3,
	[ "$pp_colour_contrast" ] 	= 0.7,
	[ "$pp_colour_colour" ] 	= 0,
	[ "$pp_colour_mulr" ] 		= 0,
	[ "$pp_colour_mulg" ] 		= 0,
	[ "$pp_colour_mulb" ] 		= 0.1
}

-- This is where we replace the entities' materials
-- This is so unoptimized it's almost painful : (
XRayTimer = 0

local function XRayMat()

	local function IsXrayFiltered( v )
		local mustfilter = v:IsWeapon() or v:IsNPC() or v:IsPlayer() 
			or v:GetClass() == "class C_BaseFlex" or v:GetClass() == "prop_ragdoll"
			or v:GetClass() == "class C_HL2MPRagdoll" or (v:GetClass() == "viewmodel" and not util.tobool(GetConVarNumber("_iw_clhands")))
			or v:GetClass() == "turret"
		
		return mustfilter
	end

	if XRayTimer <= CurTime() then
		XRayTimer = CurTime()+0.2
		
		for k,v in pairs( ents.GetAll() ) do
			if IsValid(v) and string.sub(v:GetModel() or "", -3) == "mdl" then
				-- Inefficient, but not TOO laggy I hope
				local col = v:GetColor()
				local entmat = v:GetMaterial()

				if IsXrayFiltered(v) then
					-- It's alive!
					if not (col.r == 255 and col.g == 255 and col.b == 255 and col.a == 255) then -- Has our color been changed? //255/255/255/255
						DefClrs[v] = Color(col.r, col.g, col.b, col.a)  -- Store it so we can change it back later
						v:SetColor(255, 255, 255, 255) -- Set it back to what it should be now
					end
					
					if entmat ~= "xray/living" then -- Has our material been changed?
						DefMats[v] = entmat -- Store it so we can change it back later
						v:SetMaterial( "xray/living" ) -- The xray materials are designed to show through walls
					end
				else
					-- It's a prop or something
					if not (col.r == 255 and col.g == 255 and col.b == 255 and col.a == 70) then --255/255/255/70
						DefClrs[ v ] = Color(col.r, col.g, col.b, col.a)
						v:SetColor(255, 255, 255, 70)
					end
					
					if entmat ~= "xray/prop" then
						DefMats[v] = entmat
						v:SetMaterial("xray/prop")
					end
				end
			end
		end
	end
	
	--if not SinglePlayer() then
	--	hook.Remove( "RenderScene", "XRay_ApplyMats" )
	--end	
end


-- This is where we do the post-processing effects.
local function XRayFX() 
	if not PP_ON then
		return
	end
	
	-- Colormod
	if PP_COLOR then 
		DrawColorModify(ColorTab)
	end
	
	if PP_BLOOM then
		-- Bloom
		DrawBloom(	0,  			-- Darken
	 				7,				-- Multiply
	 				0.06, 			-- Horizontal Blur
	 				0.06, 			-- Vertical Blur
	 				0, 				-- Passes
	 				0.25, 			-- Color Multiplier
	 				0, 				-- Red
	 				0, 				-- Green
	 				0.7 ) 			-- Blue
	end
end 


function XRayToggle()
	if DoXRay then
	
		hook.Remove( "RenderScene", "XRay_ApplyMats" )
		hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )

		DoXRay = false
		surface.PlaySound( sndOff )
		
		-- Set colors and materials back to normal
		for ent,mat in pairs( DefMats ) do
			if IsValid(ent) then
				if ent.IsGib then
					ent:SetMaterial( "models/flesh" )
				else
					ent:SetMaterial( mat )
				end
			end
		end
		
		for ent,clr in pairs( DefClrs ) do
			if IsValid(ent) then
				ent:SetColor( clr.r, clr.g, clr.b, clr.a )
			end
		end
		
		-- Clean up our tables- we don't need them anymore.
		DefMats = {}
		DefClrs = {}
		
	else
		local MySelf = LocalPlayer()
		-- Exit if we are out of suit power or not using the vision power at all
		if MySelf:GetPower() ~= 2 then return end
		if MySelf:SuitPower() <= 0 then
			MySelf:SetPower( 3 )
			return
		end
		
		hook.Add( "RenderScene", "XRay_ApplyMats", XRayMat ) -- We need to call this every frame in singleplayer, otherwise the server would make the materials reset
		hook.Add( "RenderScreenspaceEffects", "XRay_RenderModify", XRayFX )

		DoXRay = true
		surface.PlaySound( sndOn )
	end
end
concommand.Add("toggle_xrayvision", XRayToggle)

local Xtimer = 0
local Xstep = XRAY_TIMER

local function XRayThink()
	local MySelf = LocalPlayer()
	
	-- If your suit power is 0, turn of Xray
	if DoXRay then
		if (MySelf:SuitPower() <= 0) then
			MySelf:SetPower( 3 ) -- turn off the power
			surface.PlaySound(SOUND_WARNING)
			RunConsoleCommand("toggle_xrayvision")
		else
			-- Else, keep draining suit power
			if (Xtimer <= CurTime()) then
				Xtimer = CurTime()+Xstep
				local cost = HumanPowers[2].Cost
				if MySelf:HasBought("duracell") then 
					cost = cost * 0.75 
				end
				RunConsoleCommand("decrement_suit",tostring(cost))
			end
		end
	end
end
hook.Add("Think", "XRayCheck", XRayThink)