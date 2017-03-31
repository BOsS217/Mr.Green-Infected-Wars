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
-- Shared

local meta = FindMetaTable( "Player" )
if (!meta) then return end

function meta:HasBought( str )
	if not self.DataTable or (SERVER and self:IsBot()) then return false end
	if not self.DataTable["shopitems"] then return false end
	return self.DataTable["shopitems"][str]
end

function meta:GetScore( stat, amount )
	if not PLAYER_STATS then return 0 end
	return self.DataTable[stat]
end

function meta:PlayDeathSound()
	local cls = self:GetPlayerClass()
	local nr = 0
	if self:Team() == TEAM_UNDEAD then
		nr = #UndeadClass[cls].DeathSounds
		if nr > 0 then
			self:EmitSound(UndeadClass[cls].DeathSounds[math.random(1,nr)])
		end
	elseif self:Team() == TEAM_HUMAN then
		nr = #HumanClass[cls].DeathSounds
		if nr > 0 then
			self:EmitSound(HumanClass[cls].DeathSounds[math.random(1,nr)])
		end	
	end
end

function meta:PlayPainSound()
	local cls = self:GetPlayerClass()
	local nr = 0
	if self:Team() == TEAM_UNDEAD then
		nr = #UndeadClass[cls].PainSounds
		if nr > 0 then
			self:EmitSound(UndeadClass[cls].PainSounds[math.random(1,nr)])
		end
	elseif self:Team() == TEAM_HUMAN then
		nr = #HumanClass[cls].PainSounds
		if nr > 0 then
			self:EmitSound(HumanClass[cls].PainSounds[math.random(1,nr)])
		end	
	end
end

function meta:GetAchvProgress()
	local subnumber = 0
	local totnumber = 0
	for k, v in pairs(self.DataTable["achievements"]) do
		totnumber = totnumber + 1
		if v == true then
			subnumber = subnumber + 1
		end
	end
	return subnumber/totnumber*100
end

function meta:HasUnlocked( code )
	for k, v in pairs(unlockData[code]) do
		if not self.DataTable["achievements"][v] then
			return false
		end
	end
	return true
end

-- Serverside validation of unlocked loadout
function meta:ValidateLoadout( plteam, class, nr )
	if plteam and class and nr then
		if plteam == TEAM_UNDEAD then
			if (self:HasUnlocked(UndeadClass[class].SwepLoadout[nr].UnlockCode)) then
				return nr
			else
				return 1
			end
		elseif plteam == TEAM_HUMAN then
			if (self:HasUnlocked(HumanClass[class].SwepLoadout[nr].UnlockCode)) then
				return nr
			else
				return 1
			end	
		end
	end
	return nil
end

function meta:GetPlayerClass()
	return self.Class or 0
end

function meta:TraceLine( distance, direction )
	local dir
	if direction then
		dir = direction:GetNormal()
	else
		dir = self:GetAimVector()
	end
	local start = self:GetShootPos()
	local trace = {}
	trace.start = start
	trace.endpos = start + dir * distance
	trace.filter = self
	return util.TraceLine(trace)
end

function meta:EyeTraceLine( distance )
	local start = self:EyePos()
	local trace = {}
	trace.start = start
	trace.endpos = start + self:GetAimVector() * distance
	trace.filter = self
	return util.TraceLine(trace)
end

function meta:Gib( dmginfo )

	if not GORE_MOD then return end

	/*local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() )
		if dmginfo:IsBulletDamage() then
			effectdata:SetNormal( (self:GetPos()-dmginfo:GetInflictor():GetPos()):GetNormal() )
		else
			effectdata:SetNormal( dmginfo:GetDamageForce() )
		end
	util.Effect( "gib_player", effectdata )*/
	local effectdata = EffectData()
	effectdata:SetEntity(self)
	effectdata:SetOrigin(self:GetPos())
	effectdata:SetNormal(self:GetVelocity():Normalize())
	effectdata:SetScale(0)
	util.Effect( "gib_player", effectdata, true, true )

end

function meta:SetPower( pow )

	if CLIENT then
		RunConsoleCommand("set_power",tostring(pow))
		return
	end

	if ((pow > (#HumanPowers)) or self.CurPower == pow or pow < 0) then return end
	
	self.CurPower = pow or 0
	umsg.Start( "SetPower" , self)
		umsg.Short( self.CurPower ) -- Vision gets activated client side
	umsg.End()
	
	if (self:Team() ~= TEAM_HUMAN) then return end
	
	-- Activate player speed when Speed power is activated
	if (pow == 1) then
		local runmultiplier = 1
		if (self.EquipedSuit == "scoutsspeedpack") then
			runmultiplier = 1.2
		end
		GAMEMODE:SetPlayerSpeed( self, HumanClass[self:GetPlayerClass()].WalkSpeed*SPEED_MULTIPLIER , HumanClass[self:GetPlayerClass()].RunSpeed*SPEED_MULTIPLIER*runmultiplier )
	else
		GAMEMODE:SetPlayerSpeed( self, HumanClass[self:GetPlayerClass()].WalkSpeed, HumanClass[self:GetPlayerClass()].RunSpeed)
	end
	--self:PrintMessage(HUD_PRINTCONSOLE,"Power set to "..HumanPowers[pow].Name..".")
end

function meta:GetPower( pow )
	return self.CurPower
end

function meta:GetMaximumHealth()
	if SERVER then
		return self.MaxHP or 100
	else
		if self:GetPlayerClass() == 0 then
			return 0
		else
			if self.MaxHP then
				return self.MaxHP
			elseif self:Team() == TEAM_HUMAN then
				return HumanClass[self:GetPlayerClass()].Health
			elseif self:Team() == TEAM_UNDEAD then
				return UndeadClass[self:GetPlayerClass()].Health
			end
		end
	end
	return 100
end

function meta:GetMaxSuitPower()
	return self.MaxSP	
end

function meta:SetSuitPower(pow)
	if CLIENT then return end
	pow = math.Clamp(pow,0,self:GetMaxSuitPower())
	if (self:SuitPower() ~= pow) then
		self:SetDTInt(0,pow)
		/*self.SP = pow
		umsg.Start( "SetSP" , self)
			umsg.Short( pow )
		umsg.End()*/
	end
end

function meta:SuitPower()
	return self:GetDTInt(0) or 0
	//return self.SP	
end

function meta:Title()
	return self.TitleText or "Guest"
end

function meta:GetSuit()
	return self:GetDTEntity(1)
end

function meta:DistanceToGround()
	local start = self:GetPos()
	local trace = {}
	trace.start = start
	trace.endpos = start + Vector(0,0,-1) * 999999
	trace.filter = self
	trace.mask = MASK_SOLID_BRUSHONLY
	
	local result = util.TraceLine(trace)
	if (result.Hit) then
		return (result.HitPos-start):Length()
	else
		return 999999
	end
end

function meta:TraceLine2 ( distance, _mask, filter )
	local vStart = self:GetShootPos()
	if filter then 
		return util.TraceLine({start=vStart, endpos = vStart + self:GetAimVector() * distance, filter = self, mask = _mask, filter = filter })
	else
		return util.TraceLine({start=vStart, endpos = vStart + self:GetAimVector() * distance, filter = self, mask = _mask })
	end
end

function meta:GetMeleeFilter()
	return team.GetPlayers(self:Team())
end

function meta:TraceHull(distance, mask, size, filter, start)
	start = start or self:GetShootPos()
	return util.TraceHull({start = start, endpos = start + self:GetAimVector() * distance, filter = filter or self, mask = mask, mins = Vector(-size, -size, -size), maxs = Vector(size, size, size)})
end

function meta:DoubleTrace(distance, mask, size, mask2, filter)
	local tr1 = self:TraceLine2(distance, mask, filter)
	if tr1.Hit then return tr1 end
	if mask2 then
		local tr2 = self:TraceLine2(distance, mask2, filter)
		if tr2.Hit then return tr2 end
	end

	local tr3 = self:TraceHull(distance, mask, size, filter)
	if tr3.Hit then return tr3 end
	if mask2 then
		local tr4 = self:TraceHull(distance, mask2, size, filter)
		if tr4.Hit then return tr4 end
	end

	return tr1
end

function meta:MeleeViewPunch(damage)
	local maxpunch = (damage + 25) * 0.5
	local minpunch = -maxpunch
	self:ViewPunch(Angle(math.Rand(minpunch, maxpunch), math.Rand(minpunch, maxpunch), math.Rand(minpunch, maxpunch)))
end


function meta:MeleeTrace(distance, size, filter, start)
	return self:TraceHull(distance, MASK_SOLID, size, filter, start)
end


local meta = FindMetaTable("Weapon")
if not meta then return end

function meta:SetNextReload(fTime)
	self.m_NextReload = fTime
end

function meta:GetNextReload()
	return self.m_NextReload or 0
end


