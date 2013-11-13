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
  
  { "!/use G91 Landshark",
    {
      "modifier.multitarget",
      "@rootFrost.checkShark"
    }
  },
  
  -- Support
  { "pause", "modifier.lalt" },
  { "Ice Block", "player.health < 20" },
  { "Cold Snap", "player.health <= 30" },
  { "Arcane Torrent", "player.mana < 92" },
  { "!/use Healthstone",
    {
      "player.health < 40",
      "@rootFrost.checkStone"
    }
  },
  { "Spellsteal", "target.dispellable" },
  { "Ice Barrier",
    {
      "!player.buff(Alter Time)",
      "!player.buff"
    }
  },
  { "Evocation",
    {
      "modifier.ralt",
      "player.spell(Evocation).casted < 1"
    }
  },
  {{
    { "Summon Water Elemental", "!pet.exists" },
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
        "player.spell(114003).exists",
        "!player.moving",
        "player.spell(Evocation).casted < 1"
      }
    },
  }, "@rootFrost.interruptEvents" },

  { "!/use Mana Gem", "@rootFrost.useManagem" },
  
  --Cooldowns
  { "Alter Time",
    {
      "player.buff",
      "player.moving"
    }
  },
  {{
    { "Presence of Mind", "modifier.cooldowns" },
    { "Mirror Image", "modifier.cooldowns" },  
    { "Lifeblood", "player.spell(121279).exists" },
    { "Berserking", "player.spell(26297).exists" },
    { "Blood Fury", "player.spell(33702).exists" },
    { "!/use Potion of the Jade Serpent", "@rootFrost.usePot" },
    { "#gloves",
      {
        "!player.buff(Alter Time)",
        "!player.moving",
        "@rootFrost.useGloves"
      }
    },
    {{
      { "Frozen Orb",
        {
          "!player.moving",
        }
      },
      { "Icy Veins",
        {
          "player.buff(Brain Freeze)",
          "!player.buff(Alter Time)",
          "!player.moving",
        }
      },
      { "Icy Veins",
        {
          "player.buff(Fingers of Frost)",
          "!player.buff(Alter Time)",
          "!player.moving",
        }
      },
      { "Alter Time", 
        {
          "!player.buff",
          "player.buff(Icy Veins)",
          "player.buff(Brain Freeze)",
          "!player.moving",
        }
      },
      { "Alter Time", 
        {
          "!player.buff",
          "player.buff(Icy Veins)",
          "player.buff(Fingers of Frost).count > 1",
          "!player.moving",
        }
      },
    }, "@rootFrost.immuneEvents" }
  }, "modifier.cooldowns" },

  -- Dots
  { "Nether Tempest", "!target.debuff" },
  { "Nether Tempest",
    {
      "modifier.lcontrol",
      "!mouseover.debuff",
      "@rootFrost.immuneEvents"
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
        "player.buff(Alter Time)",
      }
    },
    { "Ice Lance",
      {
        "player.buff(Fingers of Frost)",
        "player.buff(Alter Time)",
      }
    },
    { "Frostfire Bolt",
      {
        "player.buff(Brain Freeze)",
        "player.spell(Icy Veins).cooldown > 3",
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
  { "Arcane Brilliance", "!player.buff" },
  {{
    { "Evocation", "modifier.ralt" },
    { "Frost Armor", "!player.buff" },
    { "Conjure Mana Gem", "@rootFrost.needsManagem" },
    { "Summon Water Elemental", "!pet.exists" }
  }, "!player.moving" }
}
)