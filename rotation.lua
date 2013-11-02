-- ProbablyEngine Rotation Packager
-- Custom Frost Mage Rotation
-- Created on Nov 2nd 2013 6:08 am

local rootFrost = { }

rootFrost.dots = { }

rootFrost.tempNum = 0

function rootFrost.eventHandler(self, event, ...)
	if event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_REGEN_DISABLED" then
		if #rootFrost.dots > 0 then rootFrost.dots = {} end
	end
  if event == "COMBAT_LOG_EVENT_UNFILTERED" then
    local subEvent		= select(2, ...)
		local source		= select(5, ...)
		local destGUID		= select(8, ...)
		local spellID		= select(12, ...)
    
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
                existingDot = true
              end
            end
            if not existingDot then
              table.insert(rootFrost.dots, {guid = destGUID, spellID = spellID})
            end
        end
      end 
    end
  end
end

rootFrost.eventFrame = CreateFrame("Frame")
rootFrost.eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
rootFrost.eventFrame:SetScript("OnEvent", rootFrost.eventHandler)
rootFrost.eventFrame:Show()

function rootFrost.numDots()
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

ProbablyEngine.rotation.register_custom(64, "rootFrost54", {
	-- AOE
	{ "Flamestrike", "modifier.rshift", "ground" },
	{ "Blizzard", "modifier.rshift", "ground" },
  { "Freeze", "modifier.lshift", "ground" },
	
	-- Support
  { "pause", "modifier.lalt" },
  { "Evocation", "modifier.ralt" },
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
	{ "Evocation",
		{
			"!player.buff(Invoker's Energy)",
			"!player.moving",
			"player.spell(Evocation).casted < 1"
		}
	},
	{ "Evocation",
		{
			"player.mana < 20",
			"!player.moving",
			"!player.spell.cooldown(Icy Veins)",
			"!player.buff(Alter Time)",
			"player.spell(Evocation).casted < 1"
		}
	},
	{ "Evocation",
		{
			"player.buff(Invoker's Energy).duration < 1",
			"!player.moving",
			"!player.spell.cooldown(Icy Veins)",
			"!player.buff(Alter Time)",
			"player.spell(Evocation).casted < 1"
		}
	},

	{ "!/use Potion of the Jade Serpent", (function() return rootFrost.usePot() end) },
	{ "!/use Mana Gem", (function() return rootFrost.useManagem() end) },
  
  --Cooldowns
	{ "Presence of Mind", "modifier.cooldowns" },
  { "Mirror Image", "modifier.cooldowns" },
	{ "Frozen Orb",
		{
			"!player.moving",
			"modifier.cooldowns"
		}
	},
	{ "#gloves",
		{
			"modifier.cooldowns",
			"!player.buff(Alter Time)",
			"!player.moving"
		}
	},
    { "Icy Veins",
		{
			"modifier.cooldowns",
			"player.buff(Brain Freeze)",
			"!player.buff(Alter Time)",
			"!player.moving"
		}
	},
	{ "Icy Veins",
		{
			"modifier.cooldowns",
			"player.buff(Fingers of Frost)",
			"!player.buff(Alter Time)",
			"!player.moving"
		}
	},
    { "Alter Time", 
		{
			"modifier.cooldowns",
			"!player.buff(Alter Time)",
			"player.buff(Icy Veins)",
			"player.buff(Brain Freeze)",
			"!player.moving"
		}
	},
	{ "Alter Time", 
		{
			"modifier.cooldowns",
			"!player.buff(Alter Time)",
			"player.buff(Icy Veins)",
			"player.buff(Fingers of Frost).count > 1",
			"!player.moving"
		}
	},
	{ "Alter Time",
		{
			"player.buff(Alter Time)",
			"player.moving"
		}
	},
  
  -- Dots
  { "Nether Tempest", "!target.debuff(Nether Tempest)" },
  { "Nether Tempest",
    {
      "modifier.lcontrol",
      "!mouseover.debuff(Nether Tempest)"
    },
    "mouseover"
  },
  { "Frost Bomb" },
  { "Frost Bomb",
    {
      "modifier.lcontrol"
    },
    "mouseover"
  },
  { "Living Bomb",
    {
      "!target.debuff(Living Bomb)",
      (function() return #rootFrost.dots<3 end)
    }
  },
	{ "Living Bomb",
    {
      "target.debuff(Living Bomb)",
      "target.debuff(Living Bomb).duration < 1",
      (function() return #rootFrost.dots<=3 end)
    }
  },
  { "Living Bomb",
    {
      "modifier.lcontrol",
      "!mouseover.debuff(Living Bomb)",
      (function() return #rootFrost.dots<3 end)
    },
    "mouseover"
  },
	{ "Living Bomb",
    {
      "modifier.lcontrol",
      "mouseover.debuff(Living Bomb)",
      "mouseover.debuff(Living Bomb).duration < 1",
      (function() return #rootFrost.dots<=3 end)
    },
    "mouseover"
  },
  
  -- Boss Dots
  { "Living Bomb",
    {
      "!boss1.debuff(Living Bomb)",
      (function() return #rootFrost.dots<3 end)
    },
    "boss1"
  },
	{ "Living Bomb",
    {
      "boss1.debuff(Living Bomb)",
      "boss1.debuff(Living Bomb).duration < 1",
      (function() return #rootFrost.dots<=3 end)
    },
    "boss1"
  },
  { "Living Bomb",
    {
      "!boss2.debuff(Living Bomb)",
      (function() return #rootFrost.dots<3 end)
    },
    "boss2"
  },
	{ "Living Bomb",
    {
      "boss2.debuff(Living Bomb)",
      "boss2.debuff(Living Bomb).duration < 1",
      (function() return #rootFrost.dots<=3 end)
    },
    "boss2"
  },
  { "Living Bomb",
    {
      "!boss3.debuff(Living Bomb)",
      (function() return #rootFrost.dots<3 end)
    },
    "boss3"
  },
	{ "Living Bomb",
    {
      "boss3.debuff(Living Bomb)",
      "boss3.debuff(Living Bomb).duration < 1",
      (function() return #rootFrost.dots<=3 end)
    },
    "boss3"
  },
  { "Living Bomb",
    {
      "!boss4.debuff(Living Bomb)",
      (function() return #rootFrost.dots<3 end)
    },
    "boss4"
  },
	{ "Living Bomb",
    {
      "boss4.debuff(Living Bomb)",
      "boss4.debuff(Living Bomb).duration < 1",
      (function() return #rootFrost.dots<=3 end)
    },
    "boss4"
  },
  { "Nether Tempest", "!boss1.debuff(Nether Tempest)", "boss1" },
  { "Nether Tempest", "!boss1.debuff(Nether Tempest)", "boss2" },
  { "Nether Tempest", "!boss1.debuff(Nether Tempest)", "boss3" },
  { "Nether Tempest", "!boss1.debuff(Nether Tempest)", "boss4" },  
  
  -- Actions
  { "Frostfire Bolt",
		{
			"player.buff(Brain Freeze)",
			"!modifier.cooldowns"
		}
	},
  { "Frostfire Bolt",
		{
			"player.buff(Brain Freeze)",
			"player.spell(Icy Veins).cooldown > 2"
		}
	},
	{ "Ice Lance",
		{
			"player.buff(Fingers of Frost)",
			"player.buff(Frozen Thoughts)"
		}
	},
  { "Ice Lance",
		{
			"player.buff(Fingers of Frost).count > 1",
			"!modifier.cooldowns"
		}
	},
  { "Ice Lance",
		{
			"player.buff(Fingers of Frost).count > 1",
			"player.spell(Icy Veins).cooldown > 2"
		}
	},
  { "Ice Lance",
		{
			"player.buff(Fingers of Frost)",
			"player.buff(Fingers of Frost).duration < 2"
		}
	},
	{ "Frostbolt" },
	{ "Ice Lance", "player.buff(Fingers of Frost).duration < 2" },
	{ "Ice Floes", "player.moving" },
	{ "Fire Blast", "player.moving" },
    { "Ice Lance", "player.moving" }
  },
  {
	  -- Buffs
    { "Evocation", "modifier.ralt" },
    { "Rune of Power", "modifier.ralt", "ground" },
	  { "Arcane Brilliance", "!player.buff(Arcane Brilliance)" },
	  { "Frost Armor", "!player.buff(Frost Armor)" },
	  { "Conjure Mana Gem", (function() return rootFrost.needsManagem() end) },
	  { "Summon Water Elemental", (function() return rootFrost.needsPet() end) }
  }
)