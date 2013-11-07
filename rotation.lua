-- ProbablyEngine Rotation Packager
-- Custom Frost Mage Rotation
-- Created on Nov 2nd 2013 6:08 am

ProbablyEngine.rotation.register_custom(64, "rootFrost54", {
  -- Combat
  -- Interrupts
  { "Counterspell", "modifier.interrupts", "target" },
  { "Deep Freeze", "modifier.interrupts", "target" },
  
	-- AoE
  {{
    { "Flamestrike", "modifier.rshift", "ground" },
    { "Blizzard", "modifier.rshift", "ground" },
  }, "@rootFrost.interruptEvents" },

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
      "@rootFrost.itemCooldown(5512)"
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
    { "Summon Water Elemental", "!pet.exists" },
    
    { "Evocation",
      {
        "modifier.ralt",
        "player.spell(Evocation).casted < 1",
      }
    },
    { "Rune of Power",
      {
        "modifier.ralt",
        "player.spell(Rune of Power).casted < 1",
      },
      "ground"
    },
    {{
      { "Evocation",
        {
          "!player.buff(Invoker's Energy)",
          "player.spell(Evocation).casted < 1"
        }
      },
      { "Evocation",
        {
          "player.mana < 20",
          "!player.spell.cooldown(Icy Veins)",
          "!player.buff(Alter Time)",
          "player.spell(Evocation).casted < 1"
        }
      },
      { "Evocation",
        {
          "player.buff(Invoker's Energy).duration < 1",
          "!player.spell.cooldown(Icy Veins)",
          "!player.buff(Alter Time)",
          "player.spell(Evocation).casted < 1"
        }
      },
    },
      {
        "!player.moving",
        "player.spell(Evocation).casted < 1"
      }
    },
  }, "@rootFrost.interruptEvents" },

	{ "!/use Potion of the Jade Serpent", "@rootFrost.usePot" },
	{ "!/use Mana Gem", "@rootFrost.useManagem" },
  
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
      "@rootFrost.useGloves"
      
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
        "player.buff(Brain Freeze)",
        "!player.buff(Alter Time)",
        "modifier.cooldowns",
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
  }, "@rootFrost.immuneEvents" },

  -- Dots
  { "Nether Tempest", "!target.debuff(Nether Tempest)" },
  { "Nether Tempest",
    {
      "modifier.lcontrol",
      "!mouseover.debuff(Nether Tempest)",
      "@rootFrost.immuneEvents(target)"
    },
    "mouseover"
  },
  { "Frost Bomb", "@rootFrost.validTarget"  },
  { "Frost Bomb",
    {
      "modifier.lcontrol",
      "@rootFrost.validTarget(target)"
    },
    "mouseover"
  },
  { "Living Bomb",
    {
      "player.spell(Living Bomb).casted < 1",
      "@rootFrost.dotCheck(target, 44457)"
    }, "target"
  },
  { "Living Bomb",
    {
      "modifier.lcontrol",
      "player.spell(Living Bomb).casted < 1",
      "@rootFrost.dotCheck(target, 44457)"
    },
    "mouseover"
  },

  
  -- Boss Dots
  { "Living Bomb",
    {
      "modifier.multitarget",
      "@rootFrost.bossDotCheck(target, 44457)"
    },
    "boss1"
  },
  { "Living Bomb",
    {
      "modifier.multitarget",
      "@rootFrost.bossDotCheck(target, 44457)"
    },
    "boss2"
  },
  { "Living Bomb",
    {
      "modifier.multitarget",
      "@rootFrost.bossDotCheck(target, 44457)"
    },
    "boss3"
  },
  { "Living Bomb",
    {
      "modifier.multitarget",
      "@rootFrost.bossDotCheck(target, 44457)"
    },
    "boss4"
  },
  { "Nether Tempest",
    {
      "modifier.multitarget",
      "@rootFrost.bossDotCheck(target, 114923)"
    },
    "boss1"
  },
  { "Nether Tempest",
    {
      "modifier.multitarget",
      "@rootFrost.bossDotCheck(target, 114923)"
    },
    "boss2"    
  },
  { "Nether Tempest",
    {
      "modifier.multitarget",
      "@rootFrost.bossDotCheck(target, 114923)"
    },
    "boss3"
  },
  { "Nether Tempest",
    {
      "modifier.multitarget",
      "@rootFrost.bossDotCheck(target, 114923)"
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
  },"@rootFrost.immuneEvents(target)"},

  {{
    { "Ice Lance",
      {
        "player.buff(Fingers of Frost)",
        "player.buff(Fingers of Frost).duration < 2"
      }
    },
    { "Fire Blast", "player.moving" },
    { "Ice Lance", "player.moving" },
  }, "@rootFrost.immuneEvents(target)" },

  -- Filler
  {{
    { "Frostbolt", "!player.moving" },
    { "Frostbolt",
      {
        "player.moving",
        "player.buff(Ice Floes)"
      }
    },
  }, "@rootFrost.validTarget" },
},
{
  -- Out of Combat
  { "Arcane Brilliance", "!player.buff(Arcane Brilliance)" },
  {{
    { "Evocation", "modifier.ralt" },
    { "Frost Armor", "!player.buff(Frost Armor)" },
    { "Conjure Mana Gem", "@rootFrost.needsManagem" },
    { "Summon Water Elemental", "!pet.exists" }
  }, "!player.moving" }
}
)