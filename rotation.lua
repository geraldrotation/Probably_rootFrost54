-- ProbablyEngine Rotation Packager
-- Custom Frost Mage Rotation
-- Created on Nov 2nd 2013 6:08 am

ProbablyEngine.rotation.register_custom(64, "rootFrost54", {
  -- Combat
  -- Interrupts
  { "2139", "modifier.interrupts", "target" },
  { "44572", "modifier.interrupts", "target" },
  
  -- Queued Spells
  { "1953", "@rootWind.checkQueue(1953)", "player" },
  { "66", "@rootWind.checkQueue(66)", "player" },
  { "2139", "@rootWind.checkQueue(2139)" },
  { "30449", "@rootWind.checkQueue(30449)" },
  { "45438", "@rootWind.checkQueue(45438)", "player" },
  { "12051", "@rootWind.checkQueue(12051)", "player" },
  { "44572", "@rootWind.checkQueue(44572)" },
  { "113724", "@rootWind.checkQueue(113724)", "ground" },
  
  -- AoE
  {{
    { "2120", "modifier.rshift", "ground" },
    { "10", "modifier.rshift", "ground" },
  }, "@rootFrost.interruptEvents" },

  { "33395", "modifier.lshift", "ground" },
  { "113724", "modifier.rcontrol" },
  
  { "#77589",
    {
      "modifier.multitarget",
      "@rootFrost.checkShark"
    }
  },
  
  -- Support
  { "pause", "modifier.lalt" },
  { "45438", "player.health < 20" },
  { "11958",
    {
      "player.spell(11958).exists",
      "player.spell(45438).cooldown > 0"
    }
  },
  { "#5512",
    {
      "player.health < 40"
    }
  },
  { "11426",
    {
      "!player.buff(110909)",
      "!player.buff",
      "player.spell(11426).exists"
    }
  },
  { "12051",
    {
      "modifier.ralt",
      "player.spell(12051).casted < 1"
    }
  },
  {{
    { "31687", "!pet.exists" },
    { "116011",
      {
        "modifier.ralt",
        "player.spell(116011).casted < 1",
      },
      "ground"
    },
    {{
      { "12051",
        {
          "!player.buff(116257)",
          "player.spell(12051).casted < 1"
        }
      },
      { "12051",
        {
          "player.mana < 20",
          "!player.spell.cooldown(131078)",
          "!player.buff(110909)",
          "player.spell(12051).casted < 1"
        }
      },
      { "12051",
        {
          "player.buff(116257).duration < 1",
          "!player.spell.cooldown(131078)",
          "!player.buff(110909)",
          "player.spell(12051).casted < 1"
        }
      },
    },
      {
        "player.spell(114003).exists",
        "!player.moving",
        "player.spell(12051).casted < 1"
      }
    },
  }, "@rootFrost.interruptEvents" },

  { "#36799", "@rootFrost.useManagem" },
  
  --Cooldowns
  { "108978",
    {
      "player.buff",
      "player.moving"
    }
  },
  {{
    { "12043", "player.spell(12043).exists" },
    { "55342" },  
    { "121279", "player.spell(121279).exists" },
    { "26297", "player.spell(26297).exists" },
    { "20572", "player.spell(20572).exists" },
    { "33697", "player.spell(33697).exists" },
    { "33702", "player.spell(33702).exists" },
    { "123904", "player.spell(123904).exists" },
    { "#76093", "@rootFrost.usePot" },
    { "#gloves",
      {
        "!player.buff(110909)",
        "!player.moving",
        "@rootFrost.useGloves"
      }
    },
    {{
      { "84714",
        {
          "!player.moving",
        }
      },
      { "131078",
        {
          "player.buff(57761)",
          "!player.buff(110909)",
          "!player.moving",
        }
      },
      { "131078",
        {
          "player.buff(44544)",
          "!player.buff(110909)",
          "!player.moving",
        }
      },
      { "108978", 
        {
          "!player.buff",
          "player.buff(131078)",
          "player.buff(57761)",
          "!player.moving",
        }
      },
      { "108978", 
        {
          "!player.buff",
          "player.buff(131078)",
          "player.buff(44544).count > 1",
          "!player.moving",
        }
      },
    }, "@rootFrost.immuneEvents" }
  }, "modifier.cooldowns" },

  -- Dots
  {{
    { "114923", "!target.debuff" },
    { "114923",
      {
        "modifier.lcontrol",
        "!mouseover.debuff",
        "@rootFrost.immuneEvents"
      },
      "mouseover"
    },
  }, "player.spell(114923).exists" },
  {{
    { "112948", "@rootFrost.validTarget"  },
    { "112948",
      {
        "modifier.lcontrol",
        "@rootFrost.validTarget(target)"
      },
      "mouseover"
    },
  }, "player.spell(112948).exists" },
  {{
    { "44457",
      {
        "player.spell(44457).casted < 1",
        "@rootFrost.dotCheck(target, 44457)"
      }, "target"
    },
    { "44457",
      {
        "modifier.lcontrol",
        "player.spell(44457).casted < 1",
        "@rootFrost.dotCheck(target, 44457)"
      },
      "mouseover"
    },
  }, "player.spell(44457).exists" },

  
  -- Boss Dots
  {{
    { "44457",
      {
        "modifier.multitarget",
        "@rootFrost.bossDotCheck(target, 44457)"
      },
      "boss1"
    },
    { "44457",
      {
        "modifier.multitarget",
        "@rootFrost.bossDotCheck(target, 44457)"
      },
      "boss2"
    },
    { "44457",
      {
        "modifier.multitarget",
        "@rootFrost.bossDotCheck(target, 44457)"
      },
      "boss3"
    },
    { "44457",
      {
        "modifier.multitarget",
        "@rootFrost.bossDotCheck(target, 44457)"
      },
      "boss4"
    },
  }, "player.spell(44457).exists" },
  {{
    { "114923",
      {
        "modifier.multitarget",
        "@rootFrost.bossDotCheck(target, 114923)"
      },
      "boss1"
    },
    { "114923",
      {
        "modifier.multitarget",
        "@rootFrost.bossDotCheck(target, 114923)"
      },
      "boss2"    
    },
    { "114923",
      {
        "modifier.multitarget",
        "@rootFrost.bossDotCheck(target, 114923)"
      },
      "boss3"
    },
    { "114923",
      {
        "modifier.multitarget",
        "@rootFrost.bossDotCheck(target, 114923)"
      },
      "boss4"
    },
  }, "player.spell(114923).exists" },
  
  -- Actions
  {{
    { "44614",
      {
        "player.buff(57761)",
        "!modifier.cooldowns"
      }
    },
    { "44614",
      {
        "player.buff(57761)",
        "player.buff(110909)",
      }
    },
    { "30455",
      {
        "player.buff(44544)",
        "player.buff(110909)",
      }
    },
    { "44614",
      {
        "player.buff(57761)",
        "player.spell(131078).cooldown > 3",
      }
    },
    { "30455",
      {
        "player.buff(44544)",
        "player.buff(110909)"
      }
    },
    { "30455",
      {
        "player.buff(44544)",
        "player.buff(146557)",
      }
    },
    { "30455",
      {
        "player.buff(44544).count > 1",
        "!modifier.cooldowns",
      }
    },
    { "30455",
      {
        "player.buff(44544).count > 1",
        "player.spell(131078).cooldown > 2",
      }
    },
    { "30455",
      {
        "player.buff(44544)",
        "player.buff(44544).duration < 2",
      }
    },
    { "108839",
      {
        "player.moving",
        "player.spell(108839).exists"
      }
    },
  },"@rootFrost.immuneEvents(target)"},

  {{
    { "30455",
      {
        "player.buff(44544)",
        "player.buff(44544).duration < 2"
      }
    },
    { "2136", "player.moving" },
    { "30455", "player.moving" },
  }, "@rootFrost.immuneEvents(target)" },

  -- Filler
  {{
    { "116", "!player.moving" },
    { "116",
      {
        "player.moving",
        "player.buff(108839)"
      }
    },
  }, "@rootFrost.validTarget" },
},
{
  -- Out of Combat
  { "1459", -- Arcane Brilliance
    {
      "!player.buff(116781).any",
      "!player.buff(17007).any",
      "!player.buff(1459).any",
      "!player.buff(61316).any",
      "!player.buff(24604).any",
      "!player.buff(90309).any",
      "!player.buff(126373).any",
      "!player.buff(126309).any"
    }
  },
  {{
    { "12051", "modifier.ralt" },
    { "7302", "!player.buff" },
    { "759", "@rootFrost.needsManagem" },
    { "31687", "!pet.exists" }
  }, "!player.moving" }
}
)