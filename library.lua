local rootFrost = { }

rootFrost.dots = { }
rootFrost.blacklist = { }
rootFrost.items = { }
rootFrost.flagged = GetTime()
rootFrost.unflagged = GetTime()
rootFrost.tempNum = 0
rootFrost.queueSpell = nil
rootFrost.queueTime = 0

function rootFrost.returnTrue()
  print(true)
  return true
end

SLASH_ROOTF1 = "/rootFrost"
function SlashCmdList.ROOTF(msg, editbox)		
	local command = msg:match("^(.*)$")
	if command == "Blink" or command == 1953 then
		rootFrost.queueSpell = 1953
	elseif command == "Invisibility" or command == 66 then
    rootFrost.queueSpell = 66
  elseif command == "Counterspell" or command == 2139 then
    rootFrost.queueSpell = 2139
  elseif command == "Spellsteal" or command == 30449 then
    rootFrost.queueSpell = 30449
  elseif command == "Ice Block" or command == 45438 then
    rootFrost.queueSpell = 45438
  elseif command == "Evocation" or command == 12051 then
    rootFrost.queueSpell = 12051
  elseif command == "Deep Freeze" or command == 44572 then
    rootFrost.queueSpell = 44572
  elseif command == "Ring of Frost" or command == 113724 then
    rootFrost.queueSpell = 113724
  elseif command == "Frozen Orb" or command == 84714 then
    rootFrost.queueSpell = 84714
  else
    rootFrost.queueSpell = nil
  end
  if rootFrost.queueSpell ~= nil then rootFrost.queueTime = GetTime() end
end

rootFrost.checkQueue = function (spellId)
  if (GetTime() - rootFrost.queueTime) > 4 then
    rootFrost.queueTime = 0
    rootFrost.queueSpell = nil
    return false
  else
    if rootFrost.queueSpell then
      if rootFrost.queueSpell == spellId then
        if ProbablyEngine.parser.lastCast == GetSpellName(spellId) then
          rootFrost.queueSpell = nil
          rootFrost.queueTime = 0
        end
        return true
      end
    end
  end
  return false
end

rootFrost.resetLists = function (self, ...)
  if #rootFrost.dots > 0 then rootFrost.dots = {} end
  if #rootFrost.blacklist > 0 then rootFrost.blacklist = {} end
end

rootFrost.setFlagged = function (self, ...)
  rootFrost.flagged = GetTime()
end

rootFrost.setUnflagged = function (self, ...)
  rootFrost.unflagged = GetTime()
  if rootFrost.items[77589] then
    rootFrost.items[77589].exp = rootFrost.unflagged + 60
  end
end

rootFrost.eventHandler = function(self, ...)
  local subEvent		= select(1, ...)
  local source		= select(4, ...)
  local destGUID		= select(7, ...)
  local spellID		= select(11, ...)
  local failedType = select(14, ...)
  
  if subEvent == "UNIT_DIED" then
    if #rootFrost.dots > 0 then
      for i=1,#rootFrost.dots do
        if rootFrost.dots[i].guid == destGUID then
          tremove(rootFrost.dots, i)
          return true
        end
      end
    end
  end
  
  if UnitName("player") == source then
    if subEvent == "SPELL_CAST_SUCCESS" then
      if spellID == 6262 then -- Healthstone
        rootFrost.items[6262] = { lastCast = GetTime() }
      end
      if spellID == 124199 then -- Landshark (itemId 77589)
        rootFrost.items[77589] = { lastCast = GetTime(), exp = 0 }
      end
    end
    
    if subEvent == "SPELL_AURA_REMOVED" then
      if spellID == 44457 then
        for i=1,#rootFrost.dots do
          if rootFrost.dots[i].guid == destGUID then
            tremove(rootFrost.dots, i)
            return true
          end
        end
      end
    end
  
    if subEvent == "SPELL_AURA_APPLIED" then
      local existingDot = false
      if spellID == 44457 then
          for i=1,#rootFrost.dots do
            if rootFrost.dots[i].guid == destGUID and rootFrost.dots[i].spellID == spellID then
              rootFrost.dots[i].spellTime = GetTime()
              existingDot = true
            end
          end
          if not existingDot then
            table.insert(rootFrost.dots, {guid = destGUID, spellID = spellID, spellTime = GetTime()})
          end
      end
    end
    
    if subEvent == "SPELL_CAST_FAILED" then
      if failedType and failedType == "Invalid target" then
        if spellID == 44457 or spellID == 114923 then
          rootFrost.blacklist[destGUID] = spellTime
        end
      end 
    end
  end
end

ProbablyEngine.listener.register("rootFrost", "COMBAT_LOG_EVENT_UNFILTERED", rootFrost.eventHandler)
ProbablyEngine.listener.register("rootFrost", "PLAYER_REGEN_DISABLED", rootFrost.setFlagged)
ProbablyEngine.listener.register("rootFrost", "PLAYER_REGEN_DISABLED", rootFrost.resetLists)
ProbablyEngine.listener.register("rootFrost", "PLAYER_REGEN_DISABLED", rootFrost.setUnflagged)
ProbablyEngine.listener.register("rootFrost", "PLAYER_REGEN_ENABLED", rootFrost.resetLists)

function rootFrost.spellCooldown(spell)
  local spellName = GetSpellInfo(spell)
  if spellName then
    local spellCDstart,spellCDduration,_ = GetSpellCooldown(spellName)
    if spellCDduration == 0 then
      return 0
    elseif spellCDduration > 0 then
      local spellCD = spellCDstart + spellCDduration - GetTime()
      return spellCD
    end
  end
  return 0
end

function rootFrost.useGloves(target)
  local hasEngi = false
  for i=1,9 do
    if select(7,GetProfessionInfo(i)) == 202 then hasEngi = true end
  end
  if hasEngi == false then return false end
  if GetItemCooldown(GetInventoryItemID("player", 10)) > 0 then return false end
  
  local ATCD = rootFrost.spellCooldown(108978)
  if ATCD > 10 and ATCD < 46 then
    return false
  end
  if IsPlayerSpell(12051) then
    local INVOB = select(7, UnitAura("player",116257))
    if INVOB then
      if (INVOB - GetTime()) < 21 then
        return false
      end
    end
  end
  if IsUsableSpell(55342) then
    local MICD = rootFrost.spellCooldown(55342)
    if MICD < 40 then 
      return false
    end
  end
  return true
end

function rootFrost.numDots()
  local removes = { }
  for i=1,#rootFrost.dots do
    if (GetTime() - rootFrost.dots[i].spellTime) >= 13 then
      table.insert(removes, { id = i } )
    end
  end
  
  if #removes > 0 then
    for i=1,#removes do
      tremove(rootFrost.dots, removes[i].id)
    end
  end
  
  for k,v in pairs(rootFrost.blacklist) do
    if (GetTime() - v) >= 13 then
      tremove(rootFrost.blacklist, k)
    end
  end
  

  
  if #rootFrost.dots ~= rootFrost.tempNum then
    rootFrost.tempNum = #rootFrost.dots
  end
  return #rootFrost.dots
end

function rootFrost.usePot(target)
	if not (UnitBuff("player", 2825) or
			UnitBuff("player", 32182) or 
			UnitBuff("player", 80353) or
			UnitBuff("player", 90355)) then
		return false
	end
	if GetItemCount(76093) < 1 then return false end
	if GetItemCooldown(76093) ~= 0 then return false end
	if not ProbablyEngine.condition["modifier.cooldowns"] then return false end
	if UnitLevel(target) ~= -1 then return false end
  if rootFrost.t2d(target) > 30 then return false end
	return true 
end

function rootFrost.t2d(target)
  if ProbablyEngine.condition["deathin"](target) then
    return ProbablyEngine.condition["deathin"](target)
	end
  return 600
end

function rootFrost.needsManagem(target)
	if IsPlayerSpell(56383) then
		if GetItemCount(81901, nil, true) < 10 then return true end
	end
	if GetItemCount(36799, nil, true) < 3 then return true end
end

function rootFrost.useManagem(target)
	local Max = UnitPowerMax("player")
	local Mana = 100 * UnitPower("player") / Max
	if Mana < 70 then
		if GetItemCount(81901, nil, true) >= 1 then
			if GetItemCooldown(81901) == 0 then return true end
		end
		if GetItemCount(36799, nil, true) >= 1 then
		    if GetItemCooldown(36799) == 0 then return true end
		end
	end
end

function rootFrost.dotTime(unit, spellId)
  local debuff, count, expires, caster = rootFrost.unitDebuff(unit, spellId)
  if expires and caster == "player" then
    return expires - GetTime()
  end
  return 0
end

function rootFrost.unitDebuff(target, spell)
  local debuff, count, caster, expires, spellID
  if tonumber(spell) then
    local i = 0; local go = true
    while i <= 40 and go do
      i = i + 1
      debuff,_,_,count,_,_,expires,caster,_,_,spellID = _G['UnitDebuff'](target, i)
      if spellID == tonumber(spell) and caster == "player" then go = false end
    end
  else
    debuff,_,_,count,_,_,expires,caster = _G['UnitDebuff'](target, spell)
  end
  return debuff, count, expires, caster
end

function rootFrost.dotCheck(unit, spellId)
  local destGUID = UnitGUID(unit)
  if rootFrost.blacklist[destGUID] then return false end
  if spellId == 44457 then  -- Living Bomb
    if IsPlayerSpell(spellId) then
      local bombExp = rootFrost.dotTime(unit, spellId)
      if bombExp then
        if bombExp > 1.6 then
          return false
        end
      end
      local numDots = rootFrost.numDots()
      if numDots >= 3 then
          return false
      end
    else
      return false
    end
  elseif spellId == 114923 then -- Nether Tempest
    if IsPlayerSpell(spellId) then
      local bombExp = rootFrost.dotTime(unit, spellId)
      if bombExp then
        if bombExp > 1.6 then
          return false
        end
      end
    else
      return false
    end
  end
  return true
end

function rootFrost.validTarget(unit)
  if not UnitIsVisible(unit) then return false end
  if not UnitExists(unit) then return false end
  if not (UnitCanAttack("player", unit) == 1) then return false end
  if UnitIsDeadOrGhost(unit) then return false end
  local inRange = IsSpellInRange(GetSpellInfo(116), unit) -- Frostbolt
  if not inRange then return false end
  if inRange == 0 then return false end
  if not rootFrost.immuneEvents(unit) then return false end
  if not rootFrost.interruptEvents(unit) then return false end
  return true
end

function rootFrost.bossDotCheck(unit, spellId)
  local bossUnit = unit
  if not rootFrost.validTarget(bossUnit) then return false end
  if not rootFrost.dotCheck(bossUnit, spellId) then return false end
  return true
end

rootFrost.UnitBuff = function(target, spell, owner)
  local buff, count, caster, expires, spellID
  if tonumber(spell) then
    local i = 0; local go = true
    while i <= 40 and go do
      i = i + 1
      buff,_,_,count,_,_,expires,caster,_,_,spellID = _G['UnitBuff'](target, i)
      if not owner then
        if spellID == tonumber(spell) and caster == "player" then go = false end
      elseif owner == "any" then
        if spellID == tonumber(spell) then go = false end
      end
    end
  else
    buff,_,_,count,_,_,expires,caster = _G['UnitBuff'](target, spell)
  end
  return buff, count, expires, caster
end

function rootFrost.interruptEvents(unit)
  -- local bossId = tonumber(UnitGUID("boss1"):sub(6,10), 16)
  -- if bossId
  local thokBuff, thokCount = rootFrost.UnitBuff("target", 143411, "any")
  if thokCount then
    if thokCount > 12 then return false end
  end
  if UnitBuff("player", 31821) then return true end -- Devo
  if not unit then unit = "boss1" end
  local spell = UnitCastingInfo(unit)
  local stop = false
  if spell == GetSpellInfo(138763) then stop = true end
  if spell == GetSpellInfo(137457) then stop = true end
  if spell == GetSpellInfo(143343) then stop = true end -- Thok
  if stop then
    if UnitCastingInfo("player") or UnitChannelInfo("player") then
      RunMacroText("/stopcasting")
      return false
    end
  end
  return true
end

function rootFrost.itemCooldown(itemID)
  return GetItemCooldown(itemID)
end

function rootFrost.immuneEvents(unit)
  if UnitAura(unit,GetSpellInfo(116994))
		or UnitAura(unit,GetSpellInfo(122540))
		or UnitAura(unit,GetSpellInfo(123250))
		or UnitAura(unit,GetSpellInfo(106062))
		or UnitAura(unit,GetSpellInfo(110945))
		or UnitAura(unit,GetSpellInfo(143593)) -- General Nazgrim: Defensive Stance
    or UnitAura(unit,GetSpellInfo(143574)) -- Heroic Immerseus: Swelling Corruption
		then return false end
  return true
end

function rootFrost.checkShark(target)
  if GetItemCount(77589, false, false) > 0 then
    if not rootFrost.items[77589] then return true end
    if rootFrost.items[77589].exp ~= 0 and
      rootFrost.items[77589].exp < GetTime() then return true end
  end
end

ProbablyEngine.library.register("rootFrost", rootFrost)