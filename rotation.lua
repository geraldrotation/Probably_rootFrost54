-- ProbablyEngine Rotation Packager
-- Custom Frost Mage Rotation
-- Created on Nov 2nd 2013 6:08 am

rootFrost = { }

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
		print("ttdest:" .. ttdest .. " ttdsamp:" .. ttdsamp)
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
		if GetItemCount(81901, nil, true) > 1 then
			if GetItemCooldown(81901) == 0 then return true end
		end
		if GetItemCount(36799, nil, true) < 3 then
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
	{ "Flamestrike", "modifier.shift", "ground" },
	{ "Blizzard", "modifier.shift", "ground" },
	
	-- Support
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
    
    --Rotation
	{ "Alter Time",
		{
			"player.buff(Alter Time)",
			"player.moving"
		}
	},
    { "Living Bomb", "!target.debuff(Living Bomb)" },
	{ "Living Bomb", "target.debuff(Living Bomb).duration < 2" },

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
	  { "Arcane Brilliance", "!player.buff(Arcane Brilliance)" },
	  { "Frost Armor", "!player.buff(Frost Armor)" },
	  { "Conjure Mana Gem", (function() return rootFrost.needsManagem() end) },
	  { "Summon Water Elemental", (function() return rootFrost.needsPet() end) }
  }
)