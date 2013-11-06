-- ProbablyEngine Rotation Packager
-- Custom Frost Mage Rotation
-- Created on Nov 2nd 2013 6:08 am

local rootFrost = { }

rootFrost.dots = { }
rootFrost.blacklist = { }

rootFrost.tempNum = 0

rootFrost.eventHandler = function(self, event, ...)
	if event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_REGEN_DISABLED" then
		if #rootFrost.dots > 0 then rootFrost.dots = {} end
    if #rootFrost.blacklist > 0 then rootFrost.blacklist = {} end
	end
  if event == "COMBAT_LOG_EVENT_UNFILTERED" then
    local subEvent		= select(2, ...)
		local source		= select(5, ...)
		local destGUID		= select(8, ...)
		local spellID		= select(12, ...)
    local failedType = select(15, ...)
    
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
end

ProbablyEngine.listener.register("rootFrost", "COMBAT_LOG_EVENT_UNFILTERED", rootFrost.eventHandler)
--not yet ProbablyEngine.library.register("rootFrost", rootFrost)

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

function rootFrost.useGloves()
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

function rootFrost.usePot()
	if not (UnitBuff("player", 2825) or
			UnitBuff("player", 32182) or 
			UnitBuff("player", 80353) or
			UnitBuff("player", 90355)) then
		return false
	end
	if GetItemCount(76093) < 1 then return false end
	if GetItemCooldown(76093) ~= 0 then return false end
	if not ProbablyEngine.condition["modifier.cooldowns"] then return false end
	if UnitLevel("target") ~= -1 then return false end
	if ProbablyEngine.module.combatTracker.enemy[UnitGUID('target')] then
		local ttdest = ProbablyEngine.module.combatTracker.enemy[UnitGUID('target')]['ttdest']
		local ttdsamp = ProbablyEngine.module.combatTracker.enemy[UnitGUID('target')]['ttdsamples']
		if (ttdest / ttdsamp) > 30 then return false end
	end
	return true 
end

function rootFrost.needsManagem()
	if IsPlayerSpell(56383) then
		if GetItemCount(81901, nil, true) < 10 then return true end
	end
	if GetItemCount(36799, nil, true) < 3 then return true end
end

function rootFrost.useManagem()
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

function rootFrost.needsPet()
	if not IsPlayerSpell(31687) then return false end
	if IsFalling() or IsFlying() then return false end
	if not UnitExists("pet") then
		return true
	end
end

function rootFrost.dotTime(unit, spellId)
  local debuffTime = select(7,UnitDebuff(unit,GetSpellInfo(spellId)))
  if debuffTime then
    return debuffTime - GetTime()
  end
  return 0
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

function rootFrost.bossDotCheck(i, spellId)
  local bossUnit = "boss"..i
  if not rootFrost.validTarget(bossUnit) then return false end
  if not rootFrost.dotCheck(bossUnit, spellId) then return false end
  return true
end

function rootFrost.interruptEvents(unit)
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

ProbablyEngine.rotation.register_custom(64, "rootFrost54", {
  -- Combat
  -- Interrupts
  { "Counterspell", "modifier.interrupts", "target" },
  
	-- AoE
  {{
    { "Flamestrike", "modifier.rshift", "ground" },
    { "Blizzard", "modifier.rshift", "ground" },
  },(function() return rootFrost.interruptEvents() end)},

  { "Freeze", "modifier.lshift", "ground" },
  { "Ring of Frost", "modifier.rcontrol" },
	
	-- Support
  { "pause", "modifier.lalt" },
  { "Ice Block", "player.health < 35" },
  { "Cold Snap", "player.health <= 30" },
  { "Arcane Torrent", "player.mana < 92" },
  { "!/use healthstone",
    {
      "player.health < 40",
      (function()return GetItemCooldown(5512) end)
    }
  },
	{ "Ice Barrier",
		{
			"!player.buff(Alter Time)",
			"!player.buff(Ice Barrier)"
		}
	},

  {{
    { "Healing Touch", "player.health < 40" },
    { "Summon Water Elemental", (function() return rootFrost.needsPet() end) },
    
    { "Evocation",
      {
        "modifier.ralt",
        "player.spell(Evocation).casted < 1",
        (function() return IsPlayerSpell(114003) end),
      }
    },
    { "Rune of Power",
      {
        "modifier.ralt",
        "player.spell(Rune of Power).casted < 1",
        (function() return IsPlayerSpell(116011) end),
      },
      "ground"
    },
    { "Evocation",
      {
        "!player.buff(Invoker's Energy)",
        "!player.moving",
        "player.spell(Evocation).casted < 1",
        (function() return IsPlayerSpell(114003) end),
      }
    },
    { "Evocation",
      {
        "player.mana < 20",
        "!player.moving",
        "!player.spell.cooldown(Icy Veins)",
        "!player.buff(Alter Time)",
        "player.spell(Evocation).casted < 1",
        (function() return IsPlayerSpell(114003) end),
      }
    },
    { "Evocation",
      {
        "player.buff(Invoker's Energy).duration < 1",
        "!player.moving",
        "!player.spell.cooldown(Icy Veins)",
        "!player.buff(Alter Time)",
        "player.spell(Evocation).casted < 1",
        (function() return IsPlayerSpell(114003) end),
      }
    },
  },(function() return rootFrost.interruptEvents() end)},

	{ "!/use Potion of the Jade Serpent", (function() return rootFrost.usePot() end) },
	{ "!/use Mana Gem", (function() return rootFrost.useManagem() end) },
  
  --Cooldowns
  { "Alter Time",
    {
      "player.buff(Alter Time)",
      "player.moving"
    }
  },
	{ "Presence of Mind", "modifier.cooldowns" },
  { "Lifeblood", "modifier.cooldowns" },
  { "Berserking", "modifier.cooldowns" },
  { "Blood Fury", "modifier.cooldowns" },
  { "Mirror Image", "modifier.cooldowns" },
  { "#gloves",
		{
			"modifier.cooldowns",
			"!player.buff(Alter Time)",
			"!player.moving",
      (function() return rootFrost.useGloves() end)
      
		}
	},
  {{
    { "Frozen Orb",
      {
        "!player.moving",
        "modifier.cooldowns",
      }
    },
    { "Icy Veins",
      {
        "modifier.cooldowns",
        "player.buff(Brain Freeze)",
        "!player.buff(Alter Time)",
        "!player.moving",
      }
    },
    { "Icy Veins",
      {
        "modifier.cooldowns",
        "player.buff(Fingers of Frost)",
        "!player.buff(Alter Time)",
        "!player.moving",
      }
    },
      { "Alter Time", 
      {
        "modifier.cooldowns",
        "!player.buff(Alter Time)",
        "player.buff(Icy Veins)",
        "player.buff(Brain Freeze)",
        "!player.moving",
      }
    },
    { "Alter Time", 
      {
        "modifier.cooldowns",
        "!player.buff(Alter Time)",
        "player.buff(Icy Veins)",
        "player.buff(Fingers of Frost).count > 1",
        "!player.moving",
      }
    },
    
    -- Dots
    { "Nether Tempest",
      {
        "!target.debuff(Nether Tempest)",
      }
    },
  },(function() return rootFrost.immuneEvents("target") end)},

  { "Nether Tempest",
    {
      "modifier.lcontrol",
      "!mouseover.debuff(Nether Tempest)",
      (function() return rootFrost.immuneEvents("mouseover") end)
    },
    "mouseover"
  },
  { "Frost Bomb",
    (function() return rootFrost.validTarget("target") end)
  },
  { "Frost Bomb",
    {
      "modifier.lcontrol",
      (function() return rootFrost.validTarget("mouseover") end)
    },
    "mouseover"
  },
	{ "Living Bomb",
    {
      "player.spell(Living Bomb).casted < 1",
      (function() return rootFrost.dotCheck("target", 44457) end)
    }
  },
	{ "Living Bomb",
    {
      "modifier.lcontrol",
      "player.spell(Living Bomb).casted < 1",
      (function() return rootFrost.dotCheck("mouseover", 44457) end)
    },
    "mouseover"
  },
  
  -- Boss Dots
  { "Living Bomb",
    {
      "modifier.multitarget",
      (function() return rootFrost.bossDotCheck(1, 44457) end)
    },
    "boss1"
  },
  { "Living Bomb",
    {
      "modifier.multitarget",
      (function() return rootFrost.bossDotCheck(2, 44457) end)
    },
    "boss2"
  },
  { "Living Bomb",
    {
      "modifier.multitarget",
      (function() return rootFrost.bossDotCheck(3, 44457) end)
    },
    "boss3"
  },
  { "Living Bomb",
    {
      "modifier.multitarget",
      (function() return rootFrost.bossDotCheck(4, 44457) end)
    },
    "boss4"
  },
  { "Nether Tempest",
    {
      "modifier.multitarget",
      (function() return rootFrost.bossDotCheck(1, 114923) end)
    },
    "boss1"
  },
  { "Nether Tempest",
    {
      "modifier.multitarget",
      (function() return rootFrost.bossDotCheck(2, 114923) end)
    },
    "boss2"    
  },
  { "Nether Tempest",
    {
      "modifier.multitarget",
      (function() return rootFrost.bossDotCheck(3, 114923) end)
    },
    "boss3"
  },
  { "Nether Tempest",
    {
      "modifier.multitarget",
      (function() return rootFrost.bossDotCheck(4, 114923) end)
    },
    "boss4"
  },
  
  -- Actions
  {{
    { "Frostfire Bolt",
      {
        "player.buff(Brain Freeze)",
        "!modifier.cooldowns",
      }
    },
    { "Frostfire Bolt",
      {
        "player.buff(Brain Freeze)",
        "player.spell(Icy Veins).cooldown > 2",
      }
    },
    { "Ice Lance",
      {
        "player.buff(Fingers of Frost)",
        "player.buff(Frozen Thoughts)",
      }
    },
    { "Ice Lance",
      {
        "player.buff(Fingers of Frost).count > 1",
        "!modifier.cooldowns",
      }
    },
    { "Ice Lance",
      {
        "player.buff(Fingers of Frost).count > 1",
        "player.spell(Icy Veins).cooldown > 2",
      }
    },
    { "Ice Lance",
      {
        "player.buff(Fingers of Frost)",
        "player.buff(Fingers of Frost).duration < 2",
      }
    },
    { "Ice Floes",
      {
        "player.moving",
      }
    },
  },(function() return rootFrost.immuneEvents("target") end)},

  {{
    { "Ice Lance",
      {
        "player.buff(Fingers of Frost)",
        "player.buff(Fingers of Frost).duration < 2"
      }
    },
    { "Fire Blast", "player.moving" },
    { "Ice Lance", "player.moving" },
  },(function() return rootFrost.immuneEvents("target") end)},

  -- Filler
  {{
    { "Frostbolt", "!player.moving" },
    { "Frostbolt",
      {
        "player.moving",
        "player.buff(Ice Floes)"
      }
    },
  }, (function() return rootFrost.validTarget("target") end) },
},
  {
	  -- Out of Combat
	  { "Arcane Brilliance", "!player.buff(Arcane Brilliance)" },
	  {{
      { "Evocation", "modifier.ralt" },
      { "Frost Armor", "!player.buff(Frost Armor)" },
      { "Conjure Mana Gem", (function() return rootFrost.needsManagem() end) },
      { "Summon Water Elemental", (function() return rootFrost.needsPet() end) }
    },"!player.moving"},
  }
)