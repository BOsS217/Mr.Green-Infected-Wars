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

local textureBullet = surface.GetTextureID("infectedwars/bullet")
local turretTexture = surface.GetTextureID("killicon/infectedwars/turret")
local timeblock = surface.GetTextureID( "infectedwars/timeblock" )
local timeborder = surface.GetTextureID( "infectedwars/HUD/HUDtimer_rev2" )
local undlogo = surface.GetTextureID( "infectedwars/undeadlegion" )
local humlogo = surface.GetTextureID( "infectedwars/specialforces" )

/*---------------------------------------------------------
   Name: gamemode:HUDPaint( )
   Desc: Use this section to paint your HUD
---------------------------------------------------------*/
local undwin = UNDEADWINLIST[math.random(#UNDEADWINLIST)]
local humwin = HUMANWINLIST[math.random(#HUMANWINLIST)]
DrawCrHair = true

local hring = surface.GetTextureID( "infectedwars/display_ring" )
local timerback = surface.GetTextureID( "infectedwars/HUD/timerback" )
local timertop = surface.GetTextureID( "infectedwars/HUD/timertop" )

local z_bg = surface.GetTextureID( "infectedwars/HUD/z_timer_bg" )
local z_und = surface.GetTextureID( "infectedwars/HUD/z_timer_und" )
local z_hum = surface.GetTextureID( "infectedwars/HUD/z_timer_hum" )
local z_fill = surface.GetTextureID( "infectedwars/HUD/z_timer_fill" )
local z_crack = surface.GetTextureID( "infectedwars/HUD/z_timer_crack" )
local z_overlay = surface.GetTextureID( "infectedwars/HUD/z_timer_overlay" )
local z_misc = surface.GetTextureID( "infectedwars/HUD/z_misc" )

HUDActivateInitialize = false
HUDInitialized = false

HUD = {}
HUD[0] = {Enabled = false,Msg = "Welcome to the Power Suit. Please wait...",cache = 1,font = "ArialB_26"}
HUD[1] = {Enabled = false,Msg = "Connecting to the ClavusNet Systems...",cache = 1}
HUD[2] = {Enabled = false,Msg = "Initializing energy management...",cache = 1}
HUD[3] = {Enabled = false,Msg = "Calculating health status...",cache = 1}
HUD[4] = {Enabled = false,Msg = "Analyzing avalaible weaponry...",cache = 1}
HUD[5] = {Enabled = false,Msg = "Receiving info about units...",cache = 1}
HUD[6] = {Enabled = false,Msg = "Initialization completed!",cache = 1}

local showU = 0
local showH = 0
local showT = 0

function GM:HUDPaint()
	
	if not HUD_ON then return end
	
	local MySelf = LocalPlayer()
	
	/*--------------------------------------------------
				Draw teammate/identified locations
	---------------------------------------------------*/

	local idList = {}
	for k, v in pairs(player.GetAll()) do
		if (IsValid(v) and (v:Team() == TEAM_HUMAN or v.Detectable) and v:IsValid() and v:Alive() and v ~= LocalPlayer()) then
			idList[#idList+1] = { Obj = v, ID = v:Name() }
		end
	end
	
	if (MySelf:Team() == TEAM_HUMAN and MySelf:IsValid() and MySelf:Alive() and not ENDROUND) then
		
		
		//initialize everything
		
		if not HUDActivateInitialize and not HUDInitialized then
			HUDActivateInitialize = true
			CurIn = 0
			NextIn = CurTime()+3
		end
		
		if HUDActivateInitialize and not HUDInitialized then
		
			if NextIn <= CurTime() then
				CurIn = math.Clamp(CurIn+1,0,#HUD+1)
				
				if HUD[CurIn-1] then
					HUD[CurIn-1].Enabled = true
					if (CurIn-1) ~= 0 then
						HUD[CurIn-1].Msg = HUD[CurIn-1].Msg.." Done!"
					end
				end
				
				local delay = 2
				if CurIn == #HUD-1 then
					delay = 1
				end
				
				NextIn = CurTime()+delay
			end
				
				if CurIn == #HUD+1 then 
					HUDInitialized = true 
				else
					for i=0, CurIn do
											
						HUD[i].NextCache = HUD[i].NextCache or CurTime()+0.015
						
						if HUD[i].NextCache <= CurTime() then
							HUD[i].cache = math.Clamp(HUD[i].cache+1,1,string.len(HUD[i].Msg))
							HUD[i].NextCache = CurTime()+0.015
						end
						
						local x1,y1 = 0,0
						
						if AngDiff then
							x1 = AngDiff.x/1.5 or 0
							y1 = AngDiff.y/1.5 or 0
						end
						
						DrawDisplayTextBox(string.sub(HUD[i].Msg, 1, HUD[i].cache ),HUD[i].font or "ArialB_20",w/2+x1,h/2+43*i-y1,Color(255, 255, 255, 255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
					end
				end
		end
		
		
		
		local target
		local pos
		local pl
		local dis
		local disToMiddle
		local alpha
		local mypos = MySelf:GetPos()
		local hp
		local maxhp
		local col = COLOR_GREEN
		local ratio = 1
		local enemy
		
		function ScaleAlpha( color, amount )
			return Color(color.r, color.g, color.b, amount)
		end
		
		if HUD[5].Enabled then
			for k=1, #idList do
				target = idList[k].Obj:GetPos()+Vector(0,0,50)
				pl = idList[k].Obj
				hp = pl:Health()
				maxhp = pl:GetMaximumHealth()
				enemy = (idList[k].Obj:Team() ~= MySelf:Team())

				pos = target:ToScreen()
				dis = math.floor(target:Distance(mypos))
				disToMiddle = Vector(pos.x-w/2,pos.y-h/2,0):Length()
				alpha = math.min(255,math.max(0,255*50/disToMiddle))
				if (dis < 900) then
					SCALEBLACK = ScaleAlpha(COLOR_BLACK,alpha)
					
					if enemy then
						local xpos,ypos,wd,hg = pos.x,pos.y
						draw.SimpleTextOutlined("-[[UNDEAD TARGET]]-","ArialB1_23",xpos,ypos,Color(200,20,20, alpha),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,alpha))
					else
						local xpos,ypos,wd,hg = pos.x,pos.y-30,115,10
						DrawHUDGradientBar(xpos-wd/2,ypos,wd,hg,math.min(hp / maxhp,1) * wd,4,nil,disToMiddle)
						draw.SimpleText(idList[k].ID,"ArialB_18",xpos,ypos+17,Color(255, 255, 255, alpha),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
					end
		
				end
			end
		end

	end
	
	/*--------------- Draw endround -----------*/
	if ENDROUND then 
	
		GAMEMODE:DrawDeathNotice( 0.82, 0.04 )
		
		local toDraw = ""
		local displayCol = team.GetColor( self.TeamThatWon )
		
		local tab = {}
		tab[1] = { StatsUndKiller, "Most undead killed by ", "No undead were harmed this round" }
		tab[2] = { StatsHumKiller, "Most humans killed by ", "No humans died this round (wtf O_o)" }
		tab[3] = { StatsUndDmg, "Most damage done to undead by ", "Pussy humans failed to damage the undead" }
		tab[4] = { StatsHumDmg, "Most damage done to humans by ", "Undead couldn't even scratch the humans" }
		tab[5] = { StatsMostSocial, "Most social player was ", "No social player, you're all egocentric dicks" }
		tab[6] = { StatsMostScary, "Most scary player was ", "There were no scary players, you're all pussies" }
		tab[7] = { StatsMostUnlucky, "Most unlucky player was ", "You were all lucky" }
		
		local adv = stattimer-CurTime()
		if (statsreceived) then
			for k=1, #tab do
				if adv < (#tab)-k then
					local str = tab[k][2]..tab[k][1]
					if tab[k][1] == "-" then
						str = tab[k][3]
					end
					draw.SimpleTextOutlined(str, "EndRoundStats", w/2, h/2-270+k*30, displayCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, COLOR_BLACK)
				end
			end
		end
		
		local tab = {}
		tab[1] = { StatsRoundKills, "Total kills this round: " }
		tab[2] = { StatsRoundDamage, "Total damage this round: " }
		
		if (statsreceived) then
			for k=1, #tab do
				if adv < (#tab)-k then
					draw.SimpleTextOutlined(tab[k][2]..tab[k][1], "DoomMedium", w/2, h/2+12+k*30, displayCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, COLOR_BLACK)
				end
			end
		end
		
		if (self.TeamThatWon == TEAM_UNDEAD) then
			toDraw = undwin
		else
			toDraw = humwin
		end
		
		draw.SimpleTextOutlined(toDraw, "DoomLarge", w/2, h/2, displayCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, COLOR_BLACK)
		
		// Show voting thingies
		if not self.ShowVoting then return end
		
		local m_x, m_y = gui.MouseX(), gui.MouseY()
		local mousepressed = input.IsMouseDown(MOUSE_LEFT)
		local hasvoted = ((MySelf.Voted or 1) > 0)
		
		local initBox = false
		if not VoteBox then
			initBox = true
			VoteBox = {}
		end
		
		local drawCol = COLOR_GRAY
		
		local str = "VOTE (click one)"
		if hasvoted then
			str = "NOW WAIT"
		end
		draw.SimpleTextOutlined(str, "DoomSmall", w/2, h/2+90, drawCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, COLOR_BLACK)
		
		local y = 0
		local vx, vy
		if self.CanRestart then
			str = "Restart round"
			if MySelf.Voted == 1 then
				str = "-> "..str.." <-"
			end
			if initBox then
				vx, vy = surface.GetTextSize( str )
				table.insert(VoteBox,{ x = (w/2-vx/2), y = (h/2+115+y*40), w = vx, h = vy }) 
			end
			if (VoteBox[1].x < m_x and VoteBox[1].x+VoteBox[1].w > m_x and VoteBox[1].y < m_y and VoteBox[1].y+VoteBox[1].h > m_y) then
				drawCol = COLOR_WHITE
				if mousepressed and not hasvoted then
					print("Voting for restart round")
					MySelf.Voted = 1
					RunConsoleCommand("vote_map_choice",1)
				end
			end
			draw.SimpleTextOutlined(str, "InfoSmall", w/2, h/2+115+y*40, drawCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, COLOR_BLACK)
			draw.SimpleTextOutlined(string.rep("X",MapVotes.curMap), "InfoSmall", w/2, h/2+134+y*40, drawCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, COLOR_BLACK)
			y = y+1
			drawCol = COLOR_GRAY
		else
			// quick hacky solution so it doesn't complain about indices further on
			if initBox then
				table.insert(VoteBox,{})
			end
		end
		
		str = "Map "..self.NextMap
		if MySelf.Voted == 2 then
			str = "-> "..str.." <-"
		end
		if initBox then
			vx, vy = surface.GetTextSize( str )
			table.insert(VoteBox,{ x = (w/2-vx/2), y = (h/2+115+y*40), w = vx, h = vy }) 
		end
		if (VoteBox[2].x < m_x and VoteBox[2].x+VoteBox[2].w > m_x and VoteBox[2].y < m_y and VoteBox[2].y+VoteBox[2].h > m_y) then
			drawCol = COLOR_WHITE
			if mousepressed and not hasvoted then
				//print("Voting for next map")
				MySelf.Voted = 2
				RunConsoleCommand("vote_map_choice",2)
			end
		end
		draw.SimpleTextOutlined(str, "InfoSmall", w/2, h/2+115+y*40, drawCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, COLOR_BLACK)
		draw.SimpleTextOutlined(string.rep("X",MapVotes.nextMap), "InfoSmall", w/2, h/2+134+y*40, drawCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, COLOR_BLACK)
		y = y+1
		drawCol = COLOR_GRAY
		
		str = "Map "..self.SecondNextMap
		if MySelf.Voted == 3 then
			str = "-> "..str.." <-"
		end
		if initBox then
			vx, vy = surface.GetTextSize( str )
			table.insert(VoteBox,{ x = (w/2-vx/2), y = (h/2+115+y*40), w = vx, h = vy }) 
		end
		if (VoteBox[3].x < m_x and VoteBox[3].x+VoteBox[3].w > m_x and VoteBox[3].y < m_y and VoteBox[3].y+VoteBox[3].h > m_y) then
			drawCol = COLOR_WHITE
			if mousepressed and not hasvoted then
				//print("Voting for second next map")
				MySelf.Voted = 3
				RunConsoleCommand("vote_map_choice",3)
			end
		end
		draw.SimpleTextOutlined(str, "InfoSmall", w/2, h/2+115+y*40, drawCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, COLOR_BLACK)
		draw.SimpleTextOutlined(string.rep("X",MapVotes.secondNextMap), "InfoSmall", w/2, h/2+134+y*40, drawCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, COLOR_BLACK)
		y = y+1
		drawCol = COLOR_GRAY
		
		// Show what is winning the vote
		local winner = "Restarting round"
		if (MapVotes.nextMap > MapVotes.curMap or not self.CanRestart) and MapVotes.nextMap >= MapVotes.secondNextMap then
			winner = "Changing to "..self.NextMap
		elseif MapVotes.secondNextMap > MapVotes.curMap then
			winner = "Changing to "..self.SecondNextMap
		end
		draw.SimpleTextOutlined(winner.." in "..math.floor(self:RoundTimeLeft()).." seconds", "DoomSmall", w/2, h/2+115+y*40, COLOR_GRAY, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, COLOR_BLACK)
		
		return 
	end
	
	/*---------- Draw logos and counter stuff -------*/
	if MySelf:Team() == TEAM_UNDEAD then		
		
		local diff = 0.8
		
		local tW,tH = surface.GetTextureSize(z_bg)
		
		tW,tH = tW*diff,tH*diff
		
		local tX,tY = -20,-40
	
		//background
		surface.SetTexture( z_bg )
		surface.SetDrawColor( 250,250,250,255 )
		surface.DrawTexturedRect( tX,tY, tW,tH )
		
		
		//Undead reinsforcements
		surface.SetTexture( z_und )
		surface.SetDrawColor( 215,215,215,250 )
		
		local curU = self.Reinforcements
		local totalU = math.max(self.MaxReinforcements,self.Reinforcements)	

		local amountU = math.min(curU / totalU,1)*117
		showU = math.Approach(showU, amountU, FrameTime()*117)
		
		//188, 40, 117,16
		
		render.SetScissorRect( 188,40,188+showU,56, true )
		surface.DrawTexturedRect( tX,tY, tW,tH )
		render.SetScissorRect( 188,40,188+showU,56, false )
		
		
		//Human reinsforcements
		surface.SetTexture( z_hum )
		surface.SetDrawColor( 215,215,215,250 )
		
		local curH = team.NumPlayers(TEAM_HUMAN)
		local totalH = #player.GetAll()	

		local amountH = math.min(curH / totalH,1)*117
		showH = math.Approach(showH, amountH, FrameTime()*117)
		
		//188, 67, 117,16
		render.SetScissorRect( 188,68,188+showH,68+15.5, true )
		surface.DrawTexturedRect( tX,tY, tW,tH )
		render.SetScissorRect( 188,68,188+showH,68+15.5, false )
		
		//actual timer
		surface.SetTexture( z_fill )
		surface.SetDrawColor( 255,255,255,250 )
		//22,18,85,85
		
		local curT = GAMEMODE:RoundTimeLeft()
		local totalT = ROUNDLENGTH
		
		local amountT = math.min(curT / totalT,1)*85
		showT = math.Approach(showT, amountT, FrameTime()*85)
		
		render.SetScissorRect( 22,18+(85-showT),22+85,(18+(85-showT))+showT, true )
		surface.DrawTexturedRect( tX,tY, tW,tH )
		render.SetScissorRect( 22,18+(85-showT),22+85,(18+(85-showT))+showT, false )
		
		//Draw a text before crack :v
		draw.SimpleTextOutlined(string.ToMinutesSeconds(curT),"ArialB_22",64,60,Color(235,235,235,250),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,Color(0,0,0,250))
		
		//crack
		surface.SetTexture( z_crack )
		surface.SetDrawColor( 255,255,255,255 )
		surface.DrawTexturedRect( tX,tY, tW,tH )
		
		//overlay
		surface.SetTexture( z_overlay )
		surface.SetDrawColor( 255,255,255,255 )
		surface.DrawTexturedRect( tX,tY, tW,tH )
		
		//draw counters
		draw.SimpleTextOutlined(self.Reinforcements,"ArialB_18",315,48,Color(235,235,235,250),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,2,Color(0,0,0,250))
		draw.SimpleTextOutlined(team.NumPlayers(TEAM_HUMAN),"ArialB_18",315,75,Color(235,235,235,250),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,2,Color(0,0,0,250))
		
		local diff = 0.5
		local gw,gh = surface.GetTextureSize(z_misc)
		gw,gh = gw*diff,gh*diff
		
		local gx,gy = 1,90
		
		surface.SetTexture( z_misc )
		surface.SetDrawColor( 0,0,0,255 )
		surface.DrawTexturedRect( gx,gy,gw,gh )
		
		draw.SimpleTextOutlined("Green-Coins: "..(MySelf:GreenCoins() or 0),"ArialB_16",gx+21,gy+gh/2,Color(235,235,235,250),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,2,Color(0,0,0,250))
		
	else
	
		if HUD[5].Enabled then
			local vertextable = {{}}
			local tim = GAMEMODE:RoundTimeLeft()
			local steps = 36-math.Round((tim/ROUNDLENGTH)*36)
			local clockx = 60
			local clocky = 60
			local clockstart = 31
			local clocklength = 45
			
			if AngDiff then
				clockx = clockx + (AngDiff.x/1.5 or 0)
				clocky = clocky - (AngDiff.y/1.5 or 0)
			end
			
			local function lengthdirx(length, dir)
				return length*math.cos(math.rad(dir))
			end 
			local function lengthdiry(length, dir)
				return length*math.sin(math.rad(dir))
			end
			
			surface.SetTexture( timerback )	
			surface.SetDrawColor( 255, 255, 255, 240 )
			surface.DrawTexturedRect( clockx-51.5,clocky-50.5, 100, 100 )
			
			surface.SetTexture( timeblock )
			surface.SetDrawColor( 3, 172, 228, 130 )
			
			//change timer a bit
			if steps > 0 then 
				for k=1, steps do		
					vertextable = {}
					vertextable[1] = {}
					vertextable[2] = {}
					vertextable[3] = {}
					vertextable[4] = {}
					vertextable[1]["x"] = clockx+lengthdirx(clockstart,(k-1)*10-90)
					vertextable[1]["y"] = clocky+lengthdiry(clockstart,(k-1)*10-90)
					vertextable[1]["u"] = 0
					vertextable[1]["v"] = 0
					vertextable[2]["x"] = clockx+lengthdirx(clocklength,(k-1)*10-90)
					vertextable[2]["y"] = clocky+lengthdiry(clocklength,(k-1)*10-90)
					vertextable[2]["u"] = 1
					vertextable[2]["v"] = 0
					vertextable[3]["x"] = clockx+lengthdirx(clocklength,k*10-90)
					vertextable[3]["y"] = clocky+lengthdiry(clocklength,k*10-90)
					vertextable[3]["u"] = 0
					vertextable[3]["v"] = 1
					vertextable[4]["x"] = clockx+lengthdirx(clockstart,k*10-90)
					vertextable[4]["y"] = clocky+lengthdiry(clockstart,k*10-90)
					vertextable[4]["u"] = 1
					vertextable[4]["v"] = 1
					surface.DrawPoly( vertextable )			
				end
			end
			
			surface.SetTexture( timertop )	
			surface.SetDrawColor( 255, 255, 255, 200 )
			
			draw.SimpleText(string.ToMinutesSeconds(tim),"BrdB_19",clockx,clocky,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			
			DrawDisplayBox(clockx+50,clocky-24,233,24)
			DrawDisplayBox(clockx+50,clocky+4,233,24)
			
			//undead
			
			
			draw.SimpleText("UNDEAD","ArialB_20",clockx+53,clocky-12,Color(255,255,255,200),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			draw.SimpleText(self.Reinforcements,"ArialB_20",clockx+50+233-3,clocky-12,Color(255,255,255,200),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
			
			local ux,uy,uw,uh = clockx+50+200-2-10,clocky-24+2,10,20
			for i=1, 10 do
				
				surface.SetDrawColor( 0,0, 0, 150 )
				surface.DrawOutlinedRect(ux,uy,uw,uh)
				
				ux = ux-2-10
				
			end
		
			//since we are creating from right to left - we can fill them in other direction easily

			ux = ux+2+10
			
			local curU = self.Reinforcements
			local totalU = math.max(self.MaxReinforcements,self.Reinforcements)		
			
			local amount = math.ceil((curU*10)/totalU)
			
			for i=1, amount do
				
				surface.SetDrawColor( 0,0, 0, 150 )
				surface.DrawOutlinedRect(ux,uy,uw,uh)
				surface.SetDrawColor( 200,20,20, 160 )
				surface.DrawRect(ux,uy,uw,uh)
				
				ux = ux+2+10
				
			end
			
			
			//humans
			
			draw.SimpleText("HUMANS","ArialB_20",clockx+53,clocky+16,Color(255,255,255,200),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			draw.SimpleText(team.NumPlayers(TEAM_HUMAN),"ArialB_20",clockx+50+233-3,clocky+16,Color(255,255,255,200),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
			local hx,hy,hw,hh = clockx+50+200-2-10,clocky+4+2,10,20
			for i=1, 10 do
				
				surface.SetDrawColor( 0,0, 0, 150 )
				surface.DrawOutlinedRect(hx,hy,hw,hh)
				
				hx = hx-2-10
				
			end
			
			hx = hx+2+10
			
			local curH = team.NumPlayers(TEAM_HUMAN)
			local totalH = #player.GetAll()		
			
			local amount = math.ceil((curH*10)/totalH)
			
			for i=1, amount do
				
				surface.SetDrawColor( 0,0, 0, 150 )
				surface.DrawOutlinedRect(hx,hy,hw,hh)
				surface.SetDrawColor( 3, 172, 228, 160 )
				surface.DrawRect(hx,hy,hw,hh)
				
				hx = hx+2+10
				
			end
			
		end
		
	
	end
	
	-- Rest isn't drawn if player is not alive
	if (MySelf:IsValid() and MySelf:Alive() and MySelf.Class and MySelf.Class ~= 0) then

		/* ------------ Weapon info drawing ---------------*/
		if MySelf:Team() == TEAM_UNDEAD then
			local clip_left = 0
			local clip_reserve = 0
			if (MySelf:GetActiveWeapon():IsValid()) then
				-- Amount of ammo in clip
				clip_left = MySelf:GetActiveWeapon():Clip1() or 0
				-- Amount of ammunition left
				clip_reserve = MySelf:GetAmmoCount(MySelf:GetActiveWeapon():GetPrimaryAmmoType()) or 0
			end
			
			if (clip_left ~= -1) then  -- mostly meaning user is holding knife or something
			
				clip_type = "none"
				if MySelf:GetActiveWeapon().Primary then
					clip_type = MySelf:GetActiveWeapon().Primary.Ammo
				end
				local clipline = clip_left.."/"..clip_reserve
				
				if (clip_type == "none" or clip_type == "grenade" or clip_type == "slam") then
					clipline = "Amount: "..math.max(clip_left,clip_reserve)
				end
			
				local w1,h1 = surface.GetTextureSize(z_misc)
				
				local x1,y1 = w-w1-20,h-h1-8
				
				surface.SetTexture( z_misc )
				surface.SetDrawColor( 0,0,0,255 )
				surface.DrawTexturedRect( x1,y1, w1,h1 )
				
				draw.SimpleTextOutlined(clipline, "ArialB_36", x1+w1/2, y1+h1/2, Color(235,235,235,250), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,200))
			end			
		end
		
		-- Draw team specific HUD elements	
		if MySelf:Team() == TEAM_UNDEAD then
			self:UndeadHUD()
		elseif MySelf:Team() == TEAM_HUMAN then
			self:HumanHUD()
		end
	end
	
	-- Draw target ID
	GAMEMODE:HUDDrawTargetID()
	-- Draw pickup history
	GAMEMODE:HUDDrawPickupHistory()
	-- Draw death notice
	GAMEMODE:DrawDeathNotice( 0.82, 0.04 )
	
	-- Draw crosshair
	if MySelf and MySelf:IsValid() and MySelf:Alive() and MySelf:Team() ~= TEAM_UNASSIGNED and DrawCrHair then
		GAMEMODE:DrawCrosshair()
	end
	
end

local showsuitpower = 0
local showhealth = 0

local zhud = surface.GetTextureID( "infectedwars/HUD/ZHUD" )

local zback = surface.GetTextureID( "infectedwars/HUD/z_healthbg" )
local zfill = surface.GetTextureID( "infectedwars/HUD/z_healthfill" )
local zover = surface.GetTextureID( "infectedwars/HUD/z_healthoverlay" )

local NextSmell = 0
	
function GM:UndeadHUD()

	local MySelf = LocalPlayer()
	local myhealth = 0
	local mymaxhealth = MySelf:GetMaximumHealth() or 100
	if (MySelf:IsValid() and MySelf:Alive()) then
		myhealth = math.max(MySelf:Health(), 0)	
	end
	
	/*-------- Warghoul smell ----------*/
	if NextSmell < CurTime() then
		NextSmell = CurTime() + math.Rand(0.1,0.2)
		for v, ply in pairs(player.GetAll()) do
			if ply:Team() == TEAM_HUMAN and ply:Alive() and (ply.Detectable or MySelf:GetPlayerClass() == 5)then
				local pos = ply:GetPos() + Vector(0,0,50)
				if pos:Distance(pos) < 2000 then
					local vel = ply:GetVelocity() * 0.6
					local emitter = ParticleEmitter(pos)
					for i=1, math.random(2,3) do
						local par = emitter:Add("Sprites/light_glow02_add_noz.vmt", pos)
						par:SetVelocity(vel + Vector(math.random(-25, 25),math.random(-25, 25), math.Rand(-20, 20)))
						par:SetDieTime(0.5)
						par:SetStartAlpha(4)
						par:SetEndAlpha(2)
						par:SetStartSize(math.random(1, 17))
						par:SetEndSize(math.random(1,10))
						if ply.Detectable then
							par:SetColor(250, math.random(220,240), 0)
						else
							par:SetColor(255, math.random(10,20), 10)
						end
					end
					emitter:Finish()
				end
			end
		end
	end
	/*--------------- Draw healthbar ----------------*/
	
	local w1,h1 = surface.GetTextureSize(zback)
	
	local x1,y1 = -20,h-h1/1.3
	
	
	//background
	surface.SetTexture( zback )
	surface.SetDrawColor( 0,0,0,255 )
	surface.DrawTexturedRect( x1,y1, w1,h1 )
	
	//bar
	if myhealth > 25 then
		surface.SetDrawColor( 205,205,205,250 )
	else
		surface.SetDrawColor(205,205,205, (math.sin(RealTime() * 6) * 100) + 150)
	end
	
	
	//surface.SetDrawColor( 205,205,205,250 )
	surface.SetTexture( zfill )
	
	local targethealth = math.min(myhealth / mymaxhealth,1) * 306
	showhealth = math.Approach(showhealth, targethealth, FrameTime()*306)
	
	//fucking scissorrect function using x+w values :<
	render.SetScissorRect( 125,y1+115,125+showhealth,y1+115+33, true )
	surface.DrawTexturedRect( x1,y1, w1,h1 )
	render.SetScissorRect( 125,y1+115,125+showhealth,y1+115+33, false )
	
	//surface.DrawOutlinedRect( 125,y1, showhealth,h1 )
	
	//overlay
	surface.SetTexture( zover )
	surface.SetDrawColor( 200,200,200,255 )
	surface.DrawTexturedRect( x1,y1, w1,h1 )
	
	draw.SimpleTextOutlined(myhealth, "ArialB_50", 72, y1+131, Color(148,2,2), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,200))
	
	/*local barcolor = Color(255,66,66,255)
	
	-- Make the health flash when low on HP
	if myhealth > 25 then
		surface.SetDrawColor( barcolor )
	else
		surface.SetDrawColor(barcolor.r, barcolor.g, barcolor.b, (math.sin(RealTime() * 6) * 100) + 155)
	end
	
	-- Draw bars for below healthbar
	surface.SetDrawColor( COLOR_BLACK )
	surface.DrawRect(160, h - 48, 202, 26)	
	surface.SetDrawColor( Color(255,90,90) )
	
	local targethealth = math.min(myhealth / mymaxhealth,1) * 202
	showhealth = math.Approach(showhealth, targethealth, FrameTime()*202)
	surface.DrawRect(160, h - 48, showhealth, 26)

	surface.SetTexture( zhud )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( 0, h-200, 400, 200 )
		
	draw.SimpleTextOutlined(myhealth.."/"..mymaxhealth, "DoomSmall", 360, h - 48, Color(255,0,0), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(75,0,0))*/
		
end

local hhud = surface.GetTextureID( "infectedwars/HUD/HHUD" )

local gradcenter = surface.GetTextureID( "gui/center_gradient" )

local gradup = surface.GetTextureID( "gui/gradient_up" )
local graddown = surface.GetTextureID( "gui/gradient_down" )

//global vars
DisplayRing = {x=(ScrW()/2-120/2), y=(ScrH()-120-15), wd=120, hg=120}
HealthBar = {x=ScrW()/4-110, y=(DisplayRing.y+DisplayRing.hg/2-15), wd=220, hg=30,Approach = ScrW()/4-110 }
SuitBar = {x=3*ScrW()/4-110, y=(DisplayRing.y+DisplayRing.hg/2-15), wd=220, hg=30,Approach = 3*ScrW()/4-110,col={255,255,255}}

PowerTexture = {}
for i=0,#HumanPowers do
	PowerTexture[i] = surface.GetTextureID(HumanPowers[i].HUDfile)
end

function GM:HumanHUD()
	/*--------------- Draw suit power ----------------*/
	local MySelf = LocalPlayer()
	local barcolor = Color (0, 255, 255, 200)
	local suitpower = MySelf:SuitPower()
	local maxsuitpower = MySelf:GetMaxSuitPower()
	local powername = HumanPowers[MySelf:GetPower()].Name
	local myhealth = 0
	
	local clampX,clampY = 45 , 35
	
	local mymaxhealth = MySelf:GetMaximumHealth() or 100
	if (MySelf:IsValid() and MySelf:Alive()) then
		myhealth = math.max(MySelf:Health(), 0)	
	end
	
	//make HUD jiggle a bit (thanks to Clavus :O)
	CurAng = EyeAngles()
	
	if not OldAng then
		OldAng = CurAng
	end
	
	if not AngDiff then
		AngDiff = { x=0, y=0 }
	end
	
	AngDiff.x = math.Approach(AngDiff.x,math.Clamp((CurAng.y - OldAng.y)/(FrameTime()/2.1),-clampX,clampX),FrameTime()*65)
	AngDiff.y = math.Approach(AngDiff.y,math.Clamp((CurAng.p - OldAng.p)/(FrameTime()/2.1),-clampY,clampY),FrameTime()*65)
	
	OldAng = CurAng	
	
	//draw healthbar
	
	HealthBar.x = math.Approach(HealthBar.x,HealthBar.Approach, FrameTime()*390)
	
	local targethealth = math.min(myhealth / mymaxhealth,1) * HealthBar.wd
	showhealth = math.Approach(showhealth, targethealth, FrameTime()*HealthBar.wd)
	
	if HUD[3].Enabled then
		local col = {255,255,255}
		
		if myhealth <= 35 then
			col = {155,11,11}
		end
		
		DrawHUDGradientBar(HealthBar.x+AngDiff.x,HealthBar.y-AngDiff.y,HealthBar.wd, HealthBar.hg,showhealth,4,col)
		
		surface.SetDrawColor(Color(col[1],col[2],col[3],150))
		surface.DrawOutlinedRect(HealthBar.x+AngDiff.x,HealthBar.y-AngDiff.y,HealthBar.wd, HealthBar.hg,showhealth)
		
		draw.SimpleText("TRAUMA STATUS "..math.Round(math.min(myhealth / mymaxhealth,1)*100).."%","Arial1_18",HealthBar.x+HealthBar.wd-2+AngDiff.x,HealthBar.y+HealthBar.hg+4-AngDiff.y,Color(col[1], col[2], col[3], 200),TEXT_ALIGN_RIGHT,TEXT_ALIGN_TOP)
	end
	//draw suit
	
	SuitBar.x = math.Approach(SuitBar.x,SuitBar.Approach, FrameTime()*390)
	
	local targetsuitpower = math.min(suitpower / maxsuitpower,1) * SuitBar.wd
	showsuitpower = math.Approach(showsuitpower, targetsuitpower, FrameTime()*SuitBar.wd)
	
	if HUD[2].Enabled then
		DrawHUDGradientBar(SuitBar.x+AngDiff.x,SuitBar.y-AngDiff.y,SuitBar.wd,SuitBar.hg,showsuitpower,4,SuitBar.col)
		
		surface.SetDrawColor(Color(SuitBar.col[1],SuitBar.col[2],SuitBar.col[3],150))
		surface.DrawOutlinedRect(SuitBar.x+AngDiff.x,SuitBar.y-AngDiff.y,SuitBar.wd,SuitBar.hg,showsuitpower)
		draw.SimpleText("SUIT ENERGY "..math.Round(math.min(suitpower / maxsuitpower,1)*100).."%","Arial1_18",SuitBar.x+2+AngDiff.x,SuitBar.y+SuitBar.hg+4-AngDiff.y,Color(SuitBar.col[1], SuitBar.col[2], SuitBar.col[3], 200),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
	end
	
	//draw current power
	
	if HUD[1].Enabled then
		surface.SetTexture( PowerTexture[MySelf:GetPower()] )
		surface.SetDrawColor( SuitBar.col[1], SuitBar.col[2], SuitBar.col[3], 255 )
		
		local rotation = math.NormalizeAngle(RealTime()*25)
		if MySelf:GetPower() == 3 then
			surface.DrawTexturedRectRotated( ScrW()/2+AngDiff.x, ScrH()-60-15-AngDiff.y, 80, 80,rotation)
		else
			surface.DrawTexturedRect( ScrW()/2-80/2+AngDiff.x, ScrH()-100-15-AngDiff.y, 80, 80)
		end
		
		//draw the ring
		surface.SetTexture( hring )
		surface.SetDrawColor( SuitBar.col[1], SuitBar.col[2], SuitBar.col[3], 255 )
		surface.DrawTexturedRect( DisplayRing.x+AngDiff.x, DisplayRing.y-AngDiff.y, DisplayRing.wd, DisplayRing.hg )
	end	
	
	//coins
	if HUD[5].Enabled then
		surface.SetFont("InfoSmall")
		
		local coins = MySelf:GreenCoins() or 0
		
		local gx,gy = 20,114
		if AngDiff then
			gx = gx + (AngDiff.x/1.5 or 0)
			gy = gy - (AngDiff.y/1.5 or 0)
		end

		local gw,gh = surface.GetTextSize("Green-Coins: "..coins)
		
		gw,gh = gw+3,gh+2
		
		DrawDisplayBox(gx,gy,gw,gh)
		
		draw.SimpleText("Green-Coins: "..coins, "InfoSmall", gx+1.5, gy+gh/2, Color(255,255,255,200), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	
	//turret
	
	if MySelf:GetPlayerClass() == 5 and MySelf:Team() == TEAM_HUMAN and HUD[4].Enabled then
		
			self.TurTabTargetW = self.TurTabTargetW or 78
			self.TurTabCurrentW = self.TurTabCurrentW or 78
			
			local x1,y1 = 20,136
			
			if AngDiff then
				x1 = x1 + (AngDiff.x/1.5 or 0)
				y1 = y1 - (AngDiff.y/1.5 or 0)
			end
			
		
			-- nice transition effect
			if (self.TurTabTargetW != self.TurTabCurrentW) then
				self.TurTabCurrentW = math.Approach(self.TurTabCurrentW,self.TurTabTargetW,math.abs(self.TurTabCurrentW-self.TurTabTargetW)*2*FrameTime())
			end
		
			DrawDisplayBox(x1,y1, self.TurTabCurrentW, 60)
			//draw.RoundedBox(16, 4, 146, self.TurTabCurrentW, 60, Color(0,0,0,180))
			
			local turcol = Color(3, 172, 228, 160)//COLOR_HUMAN
			
			if MySelf.TurretStatus == TurretStatus.active then
				if IsValid(MySelf.Turret.Entity) then
					self.TurTabTargetW = 190
					local turhp = MySelf.Turret:GetTable():GetHealth()
					local turmaxhp = MySelf.Turret:GetTable():GetMaxHealth()
					local mode = MySelf.Turret:GetTable():GetMode()
					local st = { FOLLOWING = 1, TRACKING = 2, LOST = 3, DEFEND = 4, SHUTDOWN = 5 }
					local kills = 0
					
					kills = MySelf.Turret:GetTable():Kills()
					draw.SimpleText("Kills: "..kills, "InfoSmall", x1+78, y1+4, Color(255,255,255,200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
					
					local modestr = "* Following owner"
					local modestr2 = ""
					if (mode == st.TRACKING) then
						modestr = "* Lost owner!"
						modestr2 = "* Tracking..."
					elseif (mode == st.LOST) then
						modestr = "* Lost track"
						modestr2 = "* Waiting for owner"
					elseif (mode == st.DEFEND) then
						modestr = "* Defending point"
						modestr2 = ""
					end
					draw.SimpleText(modestr, "InfoSmall", x1+78, y1+24, Color(255,255,255,200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
					draw.SimpleText(modestr2, "InfoSmall", x1+78, y1+40, Color(255,255,255,200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
					
					//surface.SetDrawColor( COLOR_DARKGRAY )
					//surface.DrawRect(10,186,70,10)

					
					local col = Color(3, 172, 228, 160)//COLOR_HURT1
					if (turhp <= 0.25*turmaxhp) then col = COLOR_HURT4
					elseif (turhp <= 0.5*turmaxhp) then col = COLOR_HURT3
					elseif (turhp <= 0.75*turmaxhp) then col = COLOR_HURT2
					end
					surface.SetDrawColor( col )
					surface.DrawRect(x1+6,y1+40,70*turhp/turmaxhp,10)
					
					surface.SetDrawColor( 0,0, 0, 150 )
					surface.DrawOutlinedRect(x1+6,y1+40,70,10)
				end
			elseif MySelf.TurretStatus == TurretStatus.inactive then
				self.TurTabTargetW = 78
				draw.SimpleText("UNDEPLOYED", "InfoSmaller", x1+38, y1+40, COLOR_HUMAN_LIGHT, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			elseif MySelf.TurretStatus == TurretStatus.destroyed then
				self.TurTabTargetW = 78
				turcol = COLOR_GRAY
				draw.SimpleText("DESTROYED", "InfoSmaller", x1+38, y1+40, COLOR_HUMAN_LIGHT, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			end
			
			surface.SetTexture(turretTexture)
			surface.SetDrawColor(turcol.r, turcol.g, turcol.b, 255)
			surface.DrawTexturedRect( x1+6,y1-16, 64, 64 )

		end
	
	
end

function DrawHUDGradientBar(x,y,w1,h1,value,outline,col,alphascale)
	
	if not alphascale then
		alphascale = 50
	end
	
	//background
	surface.SetDrawColor(0, 0, 0, math.min(150,math.max(0,150*50/alphascale)))
	surface.DrawRect(x,y,w1,h1)
	
	local r,g,b = 255,255,255
	
	if col then
		r,g,b = col[1],col[2],col[3]
	end
	
	surface.SetDrawColor(r,g,b, math.min(120,math.max(0,120*50/alphascale)))
	
	//up
	surface.SetTexture(gradup)
	surface.DrawTexturedRect(x,y-outline+1,value,outline)
	
	//down
	surface.SetTexture(graddown)
	surface.DrawTexturedRect(x,y+h1-1,value,outline)
	
	surface.SetDrawColor(r,g,b, math.min(200,math.max(0,200*50/alphascale)))
	//bar
	surface.DrawRect(x,y,value,h1)
	
end
//Store texture
CornerSquare = surface.GetTextureID( "infectedwars/timeblock" )
//for weapons
function DrawDisplayBox(x,y,w1,h1,a)
	
	if not a then
		a = 25
	end
	
	//Draw background
	surface.SetDrawColor(14, 97, 167, a)
	
	surface.DrawRect(x,y,w1,h1)
	
	//Draw sexy corners  :P
	surface.SetDrawColor(21, 133, 217, 200)
	
	surface.SetTexture(CornerSquare)
	
	local size = 4
	
	surface.DrawTexturedRect(x-size/2,y-size/2,size,size)
	surface.DrawTexturedRect(x-size/2,y-size/2+h1,size,size)
	surface.DrawTexturedRect(x-size/2+w1,y-size/2,size,size)
	surface.DrawTexturedRect(x-size/2+w1,y-size/2+h1,size,size)
	
end

function DrawDisplayAmmoTextBox(txt,font,x,y)
	
	surface.SetFont(font)
	
	local tw,th = surface.GetTextSize("888")
	local gap = 2
	
	local bw,bh = tw+gap+1,th+gap
	
	DrawDisplayBox(x,y,bw,bh)
	
	draw.SimpleText(txt,font,x+tw,y+bh/2,Color(255, 255, 255, 200),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
	
end

function DrawDisplayTextBox(txt,font,x,y,col,align1,align2,a)
	
	surface.SetFont(font)
	
	local tw,th = surface.GetTextSize(txt)
	local gap = 2
	
	local bw,bh = tw+gap+1,th+gap
		
	if align1 == TEXT_ALIGN_CENTER then
		x=x-bw/2
	end
	
	a = a or nil
	
	DrawDisplayBox(x,y,bw,bh,a)
	
	if align1 == TEXT_ALIGN_CENTER then
		tw=tw/2
	end
	
	draw.SimpleText(txt,font,x+tw,y+bh/2,col,align1,align2)
	
end

function DisplayDoubleAmmoTextBox(txt1,font1,x,y,txt2,font2)

	surface.SetFont(font1)
	
	local tw,th = surface.GetTextSize("888")
	local gap = 2
	
	local bw,bh = tw+gap+1,th+gap
	
	DrawDisplayBox(x,y,bw,bh)
	
	draw.SimpleText(txt1,font1,x+tw,y+bh/2,Color(255, 255, 255, 200),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
	
	if txt2 ~= 0 then
		DrawDisplayAmmoTextBox(txt2,font2,x+tw-9,y+th-9)
	end
end



function DrawWeaponInfo(wep)
	
	if !IsValid(wep) then return end
	
	local clip_left = 0
	local clip_reserve = 0

	clip_left = wep:Clip1() or 0

	clip_reserve = MySelf:GetAmmoCount(wep:GetPrimaryAmmoType()) or 0
			
	if (clip_left ~= -1) then  -- mostly meaning user is holding knife or something	
		clip_type = "none"
		if wep.Primary then
			clip_type = wep.Primary.Ammo
		end
		
		if (clip_type == "none" or clip_type == "grenade" or clip_type == "slam") then
			clip_left = math.max(clip_left,clip_reserve)
			clip_reserve = 0
		end
		
		local x1,y1 = 0,0
		if AngDiff then
			x1,y1=(AngDiff.x or 0)/1.5,(AngDiff.y or 0)/1.5
		end
		
		if HUD[4].Enabled then
			cam.IgnoreZ(true)
			DisplayDoubleAmmoTextBox(clip_left,"ArialB_65",x1,-y1,clip_reserve,"ArialB_40")
			cam.IgnoreZ(false)
		end
		
	end
	

end

function DrawMiscInfo(wep)
	
	if !IsValid(wep) then return end
	
	

end


function PlugHealthBar(bl)
	if bl then
		HealthBar.Approach = ScrW()/2-220-DisplayRing.wd/2+10
	else
		HealthBar.Approach = ScrW()/4-110
	end
end

function PlugSuitBar(bl)
	if bl then
		SuitBar.Approach = ScrW()/2+DisplayRing.wd/2-10
	else
		SuitBar.Approach = 3*ScrW()/4-110
	end
end

function GM:DrawCrosshair()
	surface.SetTexture( surface.GetTextureID(CROSSHAIR[CurCrosshair]) )
	local col = CROSSHAIRCOLORS[CurCrosshairColor] or Color(255,255,255,255)
	local alph = GetConVarNumber("_iw_crosshairalpha")
	surface.SetDrawColor( col.r, col.g, col.b, alph )	
	surface.DrawTexturedRect( w/2-32, h/2-32, 64, 64 )
end

local lastStandTex = surface.GetTextureID("infectedwars/laststand")
local lastStandAlph = 255
function LastHumanPaint()

	local sizex = 512
	local sizey = 256
	
	if GAMEMODE.LastHumanStart+8 > CurTime() then
		lastStandAlph = 255
	else
		lastStandAlph = math.max(0,lastStandAlph-255*FrameTime()/2)
	end
	
	surface.SetTexture( lastStandTex )
	surface.SetDrawColor( 255,255,255,lastStandAlph )	
	surface.DrawTexturedRect( w/2-sizex/2, h/2-sizey/2+h/4, sizex, sizey )
	surface.SetDrawColor( 100,100,100, lastStandAlph/4 )	
	surface.DrawTexturedRect( w/2-sizex*4, h/2-sizey/2+h/4, sizex*8, sizey )
	
	local col = COLOR_RED
	col.a = lastStandAlph
	if LocalPlayer():Team() == TEAM_HUMAN then
		draw.SimpleTextOutlined("Survive!", "DoomSmall", w/2, h*3/4+sizey/4, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, COLOR_BLACK)
	else
		draw.SimpleTextOutlined("Kill the last human!", "DoomSmall", w/2, h*3/4+sizey/4, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, COLOR_BLACK)
	end
	
	if GAMEMODE.LastHumanStart != 0 and GAMEMODE.LastHumanStart+10 < CurTime() then
		hook.Remove("HUDPaint","LastHumanP")
	end
end


function ToggleHUD( pl,commandName,args )
	local MySelf = LocalPlayer()
	HUD_ON = util.tobool(args[1])
	if HUD_ON then 
		MySelf:PrintMessage( HUD_PRINTTALK, "HUD activated")
		RunConsoleCommand("r_viewmodel","1")
	else 
		MySelf:PrintMessage( HUD_PRINTTALK, "HUD deactivated")
		RunConsoleCommand("r_viewmodel","0")
	end
end
concommand.Add("iw_enablehud",ToggleHUD) 

/*---------------------------------------------------------
   Name: gamemode:HUDPaintBackground( )
   Desc: Same as HUDPaint except drawn before
---------------------------------------------------------*/
local armorHitOverlay = surface.GetTextureID("infectedwars/HUD/nanoscreen")
local armorHitAlpha = 0
function GM:HUDPaintBackground()

	if not HUD_ON then return end
	
	local MySelf = LocalPlayer()
	
	-- Call scope drawing before all the other HUD code
	if MySelf:GetActiveWeapon() and MySelf:GetActiveWeapon().DrawScope then
		MySelf:GetActiveWeapon():DrawScope()
	end
	
	if (armorHitAlpha <= 0) then return end
	
	armorHitAlpha = math.max(0,armorHitAlpha-FrameTime()*340)
	surface.SetTexture( armorHitOverlay )
	surface.SetDrawColor( 110,110,200,armorHitAlpha )	
	surface.DrawTexturedRect( 0, 0, w, h )
end

local hitSounds = { Sound("weapons/crossbow/hitbod1.wav"), Sound("weapons/crossbow/hitbod2.wav") }
function ShowArmorHit()
	surface.PlaySound(table.Random(hitSounds))
	armorHitAlpha = 230
end
usermessage.Hook("HUDArmorHit",ShowArmorHit)

/*---------------------------------------------------------
   Draw coin receival effect
---------------------------------------------------------*/
local amountAdded = 0
local yAddAdd = 40
local yAdd = 0
local cdrawx = 0
local cdrawstr = ""
function PaintCoinEffect()
	yAdd = yAdd + FrameTime()*yAddAdd
	yAddAdd = math.max(0,yAddAdd - FrameTime()*35)

	draw.DrawText(cdrawstr, "InfoSmall", 10+cdrawx, 124-yAdd, Color(115,160,150,255), TEXT_ALIGN_LEFT) 
end

function KillCoinPaint()
	amountAdded = 0
	cdrawstr = ""
	hook.Remove("HUDPaint","PaintCoinEffect")
end

local function CoinEffect(um)
	yAdd = 0
	yAddAdd = 40

	local add = um:ReadShort()
	if add then
		amountAdded = amountAdded + add
		hook.Add("HUDPaint","PaintCoinEffect",PaintCoinEffect)
		timer.Remove("CoinKillTimer")
		timer.Create("CoinKillTimer",2,1,KillCoinPaint)
		
		local MySelf = LocalPlayer()
		local coins = MySelf:GreenCoins()
		
		cdrawstr = "+"..amountAdded
		if amountAdded < 0 then
			cdrawstr = ""..amountAdded
		end
		
		surface.SetFont("InfoSmall")
		wi, he = surface.GetTextSize("Green-Coins: "..coins)
		wi2, he2 = surface.GetTextSize(cdrawstr)
		
		cdrawx = wi-wi2
	
	end
end
usermessage.Hook("CoinEffect", CoinEffect)


/*---------------------------------------------------------
   Name: gamemode:HUDShouldDraw( name )
   Desc: return true if we should draw the named element
---------------------------------------------------------*/
local NotToDraw = { "CHudHealth", "CHudSecondaryAmmo","CHudAmmo","CHudBattery" }
function GM:HUDShouldDraw( name )

	if not HUD_ON then 
		return false
	end

	if(name == "CHudDamageIndicator" and not LocalPlayer():Alive()) then
		return false
	end
	for k,v in pairs(NotToDraw) do
		if (v == name) then 
			return false
		end
	end
	return true
end