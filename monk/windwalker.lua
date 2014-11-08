-- ProbablyEngine Rotation Packager
-- NO CARRIER's Windwalker Monk Rotation

local onLoad = function()
  ProbablyEngine.toggle.create('chistacker', 'Interface\\Icons\\ability_monk_expelharm', 'Stack Chi', 'Keep Chi at full even OoC...')
  ProbablyEngine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automatically target the nearest enemy when target dies or does not exist')
  ProbablyEngine.toggle.create('fof', 'Interface\\Icons\\monk_ability_fistoffury', 'Fists of Fury', 'Enable use of Fists of Fury')
  ProbablyEngine.toggle.create('autosef', 'Interface\\Icons\\spell_sandstorm', 'Auto SEF', 'Automatically cast SEF on mouseover targets')
end

local ooc = {
  -- Buffs
  { "Legacy of the White Tiger", {
    "!player.buff(Legacy of the White Tiger).any",
    "!player.buff(17007).any",
    "!player.buff(1459).any",
    "!player.buff(61316).any",
    "!player.buff(24604).any",
    "!player.buff(90309).any",
    "!player.buff(126373).any",
    "!player.buff(126309).any"
  }},
  { "Expel Harm", "player.health < 100" },
  { "Expel Harm", "toggle.chistacker" },
}

local aoe = {
  { "Chi Explosion", "player.chi >= 4" },

  { "Rushing Jade Wind" }, -- Rushing Jade Wind

  { "Rising Sun Kick", "player.chidiff = 0" },

  { "Fists of Fury", {
     "!player.moving",
     "player.lastmoved > 1",
     "player.spell(Rushing Jade Wind).exists",
     "player.timetomax > 4",
     "player.buff(Tiger Power).duration > 4",
     "target.debuff(Rising Sun Kick).duration > 4",
     "toggle.fof" }},

  { "Hurricane Strike", {
    "player.spell(Rushing Jade Wind).exists",
    "talent(7,3)",
    "player.timetomax > 2",
    "target.debuff(Rising Sun Kick).duration > 2",
    "!player.buff(Energizing Brew)" }},

  {{
    { "Chi Wave" },
    { "Zen Sphere", { "!player.buff(Zen Sphere)" }, "target" },
    { "Chi Burst", { "!player.moving", "talent(2,3)" }},
  }, { "player.timetomax > 2", "!player.buff(Serenity)" }},

  {{
    { "Blackout Kick", "player.buff(Combo Breaker: Blackout Kick)" },
    { "Blackout Kick", "player.buff(Serenity).duration > 0" },
  },{ "talent(6,1)", "!talent(7,2)" }},

  { "Tiger Palm", { "player.spell(Rushing Jade Wind).exists", "player.buff(Combo Breaker: Tiger Palm)", "player.buff(Combo Breaker: Tiger Palm).duration <= 2" }},

  { "Blackout Kick", { "talent(6,1)", "!talent(7,2)", "player.chidiff < 2" }},

  { "Spinning Crane Kick", "!player.spell(Rushing Jade Wind).exists" },

  { "Jab", { "player.spell(Rushing Jade Wind).exists", "player.chidiff >= 2" }},
}

local combat = {
  -- Pause
  { "pause", "modifier.lshift" },
  { "pause", "@NOC.pause()"},

   -- AutoTarget
  { "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
  { "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } },

  -- Keyboard modifiers
  { "Leg Sweep", "modifier.lcontrol" },              -- Leg Sweep
  { "Touch of Karma", "modifier.lalt" },              -- Touch of Karma

  -- SEF on mouseover
  {{
    { "Storm, Earth, and Fire", { "!mouseover.debuff(138130)", "!player.buff(137639).count = 2", "@NOC.mouseNotEqualTarget()" }, "mouseover" },
    { "/cancelaura Storm, Earth, and Fire", { "target.debuff(Storm, Earth, and Fire)" }}
  }, "toggle.autosef" },

  -- Interrupts
  {{
    { "Paralysis", { -- Paralysis when SHS, and Quaking Palm are all on CD
       "!target.debuff(Spear Hand Strike)",
       "player.spell(Spear Hand Strike).cooldown > 0",
       "player.spell(Quaking Palm).cooldown > 0",
       "!modifier.last(Spear Hand Strike)"
    }},
    { "Ring of Peace", { -- Ring of Peace when SHS is on CD
       "!target.debuff(Spear Hand Strike)",
       "player.spell(Spear Hand Strike).cooldown > 0",
       "!modifier.last(Spear Hand Strike)"
    }},
    { "Leg Sweep", { -- Leg Sweep when SHS is on CD
       "player.spell(116705).cooldown > 0",
       "target.range <= 5",
       "!modifier.last(116705)"
    }},
    { "Charging Ox Wave", { -- Charging Ox Wave when SHS is on CD
       "player.spell(116705).cooldown > 0",
       "target.range <= 30",
       "!modifier.last(116705)"
    }},
    { "Quaking Palm", { -- Quaking Palm when SHS is on CD
       "!target.debuff(Spear Hand Strike)",
       "player.spell(Spear Hand Strike).cooldown > 0",
       "!modifier.last(Spear Hand Strike)"
    }},
    { "Spear Hand Strike" }, -- Spear Hand Strike
  }, "target.interruptAt(30)" }, -- Interrupt when 30% into the cast time

  -- Queued Spells
  { "!122470", "@NOC.checkQueue(122470)" }, -- Touch of Karma
  { "!116845", "@NOC.checkQueue(Ring of Peace)" }, -- Ring of Peace
  { "!119392", "@NOC.checkQueue(119392)" }, -- Charging Ox Wave
  { "!119381", "@NOC.checkQueue(119381)" }, -- Leg Sweep
  { "!Tiger's Lust", "@NOC.checkQueue(Tiger's Lust)" }, -- Tiger's Lust
  { "!Dampen Harm", "@NOC.checkQueue(Dampen Harm)" }, -- Dampen Harm
  { "!Diffuse Magic", "@NOC.checkQueue(Diffuse Magic)" }, -- Diffuse Magic
  --{ "!115460", "@NOC.checkQueue(115460)", "ground" }, -- Healing Sphere

{{
  -- Survival
  { "Expel Harm", { "player.health <= 80", "player.chidiff >= 2" }},
  --{ "Surging Mist", { "player.health <= 70", "!player.moving" }},
  { "Chi Wave", "player.health <= 75" },

  { "Fortifying Brew", { -- Forifying Brew at < 30% health and when DM & DH buff is not up
    "player.health < 30",
    "!player.buff(Diffuse Magic)", --DM
    "!player.buff(Dampen Harm)" --DH
  }},
  { "#5512", "player.health < 40" }, -- Healthstone

  { "Detox", "player.dispellable(Detox)", "player" }, -- Detox yourself if you can be dispelled
  { "Nimble Brew", "@NOC.noControl()" },
  { "Tiger's Lust", "@NOC.noControl()" },

  -- Shared
  { "Chi Sphere", { "player.spell(Power Strikes).exists", "player.buff(Chi Sphere)", "player.chi < 4" }},
  {{
     -- Cooldowns/Racials
     { "Lifeblood" },
     { "Berserking" },
     { "Blood Fury" },
     { "Bear Hug" },
     { "Invoke Xuen, the White Tiger" },
  }, "modifier.cooldowns" },

  -- Melee range only
  {{
    { "Touch of Death", "player.buff(Death Note)" },

    {{
      { "Chi Brew", { "!modifier.last(Chi Brew)", "player.spell(Chi Brew).charges = 2" }},
      { "Chi Brew", "target.ttd < 10" },
      { "Chi Brew", { "player.spell(Chi Brew).charges = 1", "player.spell(Chi Brew).recharge <= 10", "!modifier.last(Chi Brew)" }},
    }, {"player.chidiff >= 2", "player.buff(Tigereye Brew).count <= 16" }},

    -- Tiger Palm
    { "Tiger Palm", "player.buff(Tiger Power).duration <= 3" },
    -- Tigereye Brew
    {{
      { "116740", "player.buff(125195).count = 20" },
      { "116740", { "player.buff(125195).count >= 10", "player.buff(Serenity).duration > 0" }},
      {{
        {{
          { "116740", "player.spell(Fists of Fury).cooldown = 0" },
          { "116740", { "player.spell(Hurricane Strike).cooldown > 0", "talent(7,1)" }},
        },{ "player.chi >= 3", "player.buff(125195).count >= 10" }},
        {{
          { "116740", { "player.buff(125195).count >= 16" }},
          { "116740", { "target.ttd < 40" }},
        },{ "player.chi >= 2" }},
      },{ "target.debuff(Rising Sun Kick)", "player.buff(Tiger Power)" }},
    },{ "!player.buff(116740)", "!modifier.last(116740)" }},

    { "Rising Sun Kick", "!target.debuff(Rising Sun Kick)" },
    { "Rising Sun Kick", "target.debuff(Rising Sun Kick).duration < 3" },

    { "Tiger Palm", { "!player.buff(Tiger Power)", "target.debuff(Rising Sun Kick).duration > 1", "player.timetomax > 1" }},

    { "Serenity", { "talent(7,3)", "player.chi >= 2", "target.debuff(Rising Sun Kick)", "player.buff(Tiger Power)" }},

    -- AoE
    { aoe, { "toggle.multitarget", "modifier.enemies >= 3" }},

    -- Single

    -- Fists of Fury
    { "Fists of Fury", {
       "!player.moving",
       "player.lastmoved > 1",
       "target.debuff(Rising Sun Kick).duration > 4",
       "!player.buff(Serenity)",
       "toggle.fof" }},

    { "Hurricane Strike", {
      "talent(7,3)",
      "player.timetomax > 2",
      "target.debuff(Rising Sun Kick).duration > 2",
      "!player.buff(Energizing Brew)" }},

    {{
      { "Energizing Brew", "!talent(7,3)" },
      { "Energizing Brew", { "!player.buff(Serenity)", "player.spell(Serenity).cooldown > 4" }},
    },{ "player.spell(Fists of Fury).cooldown > 6", "player.timetomax > 5" }},

    { "Rising Sun Kick", "!talent(7,2)" },

    {{
      { "Chi Wave" },
      { "Zen Sphere", { "!player.buff(Zen Sphere)" }, "target" },
      { "Chi Burst", { "!player.moving", "talent(2,3)" }},
    }, { "player.timetomax > 2", "!player.buff(Serenity)" }},

    {{
      { "Blackout Kick", "player.buff(Combo Breaker: Blackout Kick)" },
      { "Blackout Kick", "player.buff(Serenity)" },
    }, "!talent(7,2)" },

    { "Chi Explosion", { "talent(7,2)", "player.chi >= 3", "player.buff(Combo Breaker: Chi Explosion)" }},

    { "Tiger Palm", { "player.buff(Combo Breaker: Tiger Palm)", "player.buff(Combo Breaker: Tiger Palm).duration <= 2" }},

    { "Blackout Kick", { "!talent(7,2)", "player.chidiff < 2" }},

    { "Chi Explosion", { "talent(7,2)", "player.chi >= 3" }},

    { "Jab", "player.chidiff >= 2" },

  }, { "target.exists", "target.alive", "player.alive", "target.range <= 5", "!player.casting" }},


  -- Ranged
  {{
    -- Tiger's Lust if the target is at least 15 yards away and we are moving for at least 1 second
    { "Tiger's Lust", { "target.range >= 15", "player.movingifor > 1", "target.alive" }},

    { "Zen Sphere", "!target.debuff(Zen Sphere)" },
    { "Chi Wave" },
    { "Chi Burst" },

    -- Crackling Jade Lightning
    --{"/stopcasting", { "target.range < 5" }},
    { "Crackling Jade Lightning", { "target.range > 5", "target.range <= 40", "!player.moving" }},

    { "Expel Harm", "player.chi < 4" }, -- Expel Harm
  }},
}, "@NOC.immuneEvents('target')" },
}

ProbablyEngine.rotation.register_custom(269, "|cFF32ff84NOC Windwalker Monk 6.0|r", combat, ooc, onLoad)
