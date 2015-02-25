-- ProbablyEngine Rotation Packager
-- NO CARRIER's Windwalker Monk Rotation

local onLoad = function()
  ProbablyEngine.toggle.create('chistacker', 'Interface\\Icons\\ability_monk_expelharm', 'Stack Chi', 'Keep Chi at full even OoC...')
  --ProbablyEngine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automatically target the nearest enemy when target dies or does not exist')
  ProbablyEngine.toggle.create('rjw', 'Interface\\Icons\\ability_monk_rushingjadewind', 'RJW/SCK', 'Enable use of Rushing Jade Wind or Spinning Crane Kick when using Chi Explosion')
  ProbablyEngine.toggle.create('cjl', 'Interface\\Icons\\ability_monk_cracklingjadelightning', 'Crackling Jade Lightning', 'Enable use of automatic Crackling Jade Lightning when the target is in combat and at range')
  ProbablyEngine.toggle.create('dpstest', 'Interface\\Icons\\inv_misc_pocketwatch_01', 'DPS Test', 'Stop combat after 5 minutes in order to do a controlled DPS test')
  ProbablyEngine.toggle.create('autosef', 'Interface\\Icons\\spell_sandstorm', 'Auto SEF', 'Automatically cast SEF on mouseover targets')

  BaseStatsInit()

  C_Timer.NewTicker(0.25, (
      function()
          BaseStatsUpdate()
      end),
  nil)

end

local buffs = {
  { "Legacy of the White Tiger", { -- Legacy of the White Tiger
  "!player.buff(Legacy of the White Tiger).any",
  "!player.buff(17007).any",
  "!player.buff(1459).any",
  "!player.buff(61316).any",
  "!player.buff(24604).any",
  "!player.buff(90309).any",
  "!player.buff(126373).any",
  "!player.buff(126309).any",
  "!player.buff(117666).any",
  "!player.buff(1126).any",
  "!player.buff(20217).any",
  "!player.buff(90363).any"
  }},
}

local ooc = {
  -- Buffs
  { buffs, },

  { "Expel Harm", "player.health < 100" },
  {{
    { "Expel Harm" },
    { "Zen Sphere", "!player.buff(Zen Sphere)" },
    { "Zen Sphere", { "focus.exists", "!focus.buff(Zen Sphere)", "focus.range <= 40", }, "focus" },
    { "Zen Sphere", { "!focus.exists", "tank.exists", "!tank.buff(Zen Sphere)", "tank.range <= 40", }, "tank" },
  }, "toggle.chistacker" },
}

local aoe = {
  { "Chi Explosion", { "player.chi >= 4", "player.spell(Fists of Fury).cooldown > 4" }},

  { "Rising Sun Kick", { "player.chidiff = 0" }},

  -- Only use this is we have the RJW talent and there are more than 3 enemies and toggle enabled
  { "Rushing Jade Wind", { "talent(6,1)", "modifier.enemies > 3", "toggle.rjw" }},
  -- Otherwise, use it 'normally' if we aren't using chi explosion
  { "Rushing Jade Wind", { "talent(6,1)", "!talent(7,2)" }},

  {{
    { "Chi Wave" },
    --{ "Zen Sphere", { "!player.buff(Zen Sphere)" }, "target" },
    { "Chi Burst", { "!player.moving", "talent(2,3)" }},
  }, { "player.timetomax > 2", "!player.buff(Serenity)" }},

  { "Tiger Palm", { "player.buff(Combo Breaker: Tiger Palm)", "player.buff(Combo Breaker: Tiger Palm).duration <= 2" }},

  -- If we have RJW:
  {{
    {{
      { "Blackout Kick", "player.buff(Combo Breaker: Blackout Kick)" },
      { "Blackout Kick", "player.buff(Serenity).duration > 0" },
    },{ "!talent(7,2)" }},
    { "Blackout Kick", { "!talent(7,2)", "player.chidiff < 2", "player.spell(Fists of Fury).cooldown > 3"  }},
    { "Chi Torpoedo", "player.timetomax > 2" },
  }, { "talent(6,1)" }},

  -- If we do NOT have RJW
  {{
    { "Blackout Kick", { "!talent(7,2)", "player.chidiff < 2" }},
    { "Chi Torpoedo", "player.timetomax > 2" },

    -- Only do this if we do not have RJW talent and there are more than 3 enemies and toggle enabled
    { "Spinning Crane Kick", { "modifier.enemies > 3", "toggle.rjw" }},
    -- Otherwise, use it 'normally' if we aren't using chi explosion
    { "Spinning Crane Kick", { "!talent(7,2)" }},

  }, { "!talent(6,1)" }},

  { "Expel Harm", { "player.health <= 95", "player.chidiff >= 2" }},
  { "Jab", "player.chidiff >= 2" },
}

local st = {
  { "Blackout Kick", "player.buff(Combo Breaker: Blackout Kick)" },
  { "Blackout Kick", "player.buff(Serenity)" },

  { "Tiger Palm", { "player.buff(Combo Breaker: Tiger Palm)", "player.buff(Combo Breaker: Tiger Palm).duration <= 2" }},

  { "Rising Sun Kick", "!talent(7,2)" },

  {{
    { "Chi Wave" },
    --{ "Zen Sphere", { "!player.buff(Zen Sphere)" }, "target" },
    { "Chi Burst", { "!player.moving", "talent(2,3)" }},
    { "Chi Torpoedo" },
  }, { "player.timetomax > 2", "!player.buff(Serenity)" }},

  { "Blackout Kick", "player.chidiff < 2" },
}

local st_chex = {
  { "Chi Explosion", { "player.chi >= 2", "player.buff(Combo Breaker: Chi Explosion)", "player.spell(Fists of Fury).cooldown > 2" }},

  { "Tiger Palm", { "player.buff(Combo Breaker: Tiger Palm)", "player.buff(Combo Breaker: Tiger Palm).duration <= 2" }},

  {{
    { "Chi Wave" },
    --{ "Zen Sphere", { "!player.buff(Zen Sphere)" }, "target" },
    { "Chi Burst", { "!player.moving", "talent(2,3)" }},
  }, { "player.timetomax > 2", "!player.buff(Serenity)" }},

  { "Rising Sun Kick" },

  { "Tiger Palm", { "player.chi >= 4", "!player.buff(Combo Breaker: Chi Explosion)" }},

  { "Chi Explosion", { "player.chi >= 3", "player.spell(Fists of Fury).cooldown > 4" }},

  { "Chi Torpoedo", "player.timetomax > 2" },
}

local opener = {
  {{
    -- This should 'constrain' BoK to be only casted once during the opener
    { "Blackout Kick", { "player.chidiff <= 1", "player.spell(Blackout Kick).casted = 0" }},

    -- TeB when we have used both Chi Brews and have casted BoK at least once
    { "116740", { "!player.buff(116740)", "player.spell(Chi Brew).charges = 0", "player.spell(Blackout Kick).casted != 0" }},

  }, { "player.buff(Tiger Power)", "target.debuff(Rising Sun Kick)" }},

  { "Chi Brew", { "!lastcast(Chi Brew)", "player.chidiff >= 2" }}, -- 0-3 chi

  { "Jab", "player.chidiff >= 2" }, -- 0-3 chi
}

local combat = {
  -- Pause
  { "pause", "modifier.lshift" },
  { "pause", "player.casting(115176)" }, -- Pause for Zen Meditation
  { "/stopcasting\n/stopattack\n/cleartarget\n/stopattack\n/cleartarget", { "player.time >= 300", "toggle.dpstest" }},

   -- AutoTarget
  { "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
  { "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } },

  -- Keyboard modifiers
  { "Leg Sweep", "modifier.lcontrol" },
  { "Touch of Karma", "modifier.lalt" },

  -- Buffs
  { buffs, },

  { "Storm, Earth, and Fire", { "!mouseover.debuff(138130)", "!player.buff(137639).count = 2", "@NOC.canSEF()" }, "mouseover" },
  -- Auto SEF when enabled
  { "Storm, Earth, and Fire", { "toggle.autosef", "!player.buff(137639).count = 2", "@NOC.autoSEF()", },},
  { "/cancelaura Storm, Earth, and Fire", { "target.debuff(Storm, Earth, and Fire)" }},

  -- Interrupts
  {{
    { "Paralysis", { -- Paralysis when SHS, and Quaking Palm are all on CD
       "!target.debuff(Spear Hand Strike)",
       "player.spell(Spear Hand Strike).cooldown > 1",
       "player.spell(Quaking Palm).cooldown > 1",
       "!lastcast(Spear Hand Strike)"
    }},
    { "Ring of Peace", { -- Ring of Peace when SHS is on CD
       "!target.debuff(Spear Hand Strike)",
       "player.spell(Spear Hand Strike).cooldown > 1",
       "!lastcast(Spear Hand Strike)"
    }},
    { "Leg Sweep", { -- Leg Sweep when SHS is on CD
       "player.spell(116705).cooldown > 1",
       "target.range <= 5",
       "!lastcast(116705)"
    }},
    { "Charging Ox Wave", { -- Charging Ox Wave when SHS is on CD
       "player.spell(116705).cooldown > 1",
       "target.range <= 30",
       "!lastcast(116705)"
    }},
    { "Quaking Palm", { -- Quaking Palm when SHS is on CD
       "!target.debuff(Spear Hand Strike)",
       "player.spell(Spear Hand Strike).cooldown > 1",
       "!lastcast(Spear Hand Strike)"
    }},
    { "Spear Hand Strike" }, -- Spear Hand Strike
  }, "target.interruptAt(40)" }, -- Interrupt when 40% into the cast time

  -- Self-Healing & Defensives
  { "Expel Harm", { "player.health <= 70", "player.chidiff >= 2" }}, -- 10 yard range, 40 energy, 0 chi

  -- Forifying Brew at < 30% health and when DM & DH buff is not up
  { "Fortifying Brew", {
    "player.health <= 25",
    "!player.buff(Diffuse Magic)",
    "!player.buff(Dampen Harm)"
  }},

  { "#109223", "player.health < 40" }, -- Healing Tonic
  { "#5512", "player.health < 40" }, -- Healthstone

  { "Detox", "player.dispellable(Detox)", "player" },
  { "Nimble Brew", "@NOC.noControl()" },
  { "Tiger's Lust", "@NOC.noControl()" },

  -- wrapper for "@NOC.immuneEvents" which prevents the following from occuring when the target is CCed or otherwise not allowed to be attacked
  {{
    -- Chi wave during the first few seconds of combat (even at range) and when not under Serenity
    { "Chi Wave", { "player.time < 10", "!player.buff(Serenity)" }}, -- 40 yard range 0 energy, 0 chi

    {{
       -- Cooldowns/Racials
       { "Lifeblood" },
       { "Berserking" },
       { "Blood Fury" },
       { "Bear Hug" },
       { "Invoke Xuen, the White Tiger" },
       --{ "#trinket1", "player.hashero" },
       --{ "#trinket2", "player.hashero" },
       -- Use trinkets when we are using TeB
      -- Use with TeB when not specced into Serenity
       { "#trinket1", { "!talent(7,3)", "player.buff(116740)" }},
       { "#trinket2", { "!talent(7,3)", "player.buff(116740)" }},
       -- Use with Serenity buff when secced into Serenity
       { "#trinket1", { "talent(7,3)", "player.buff(Serenity)" }},
       { "#trinket2", { "talent(7,3)", "player.buff(Serenity)" }},
    }, "modifier.cooldowns" },

    -- Should this be moved after the melee-range check? Worried that it may be prioritized too much
    {{
      { "Zen Sphere", "!player.buff(Zen Sphere)" },
      { "Zen Sphere", { "focus.exists", "!focus.buff(Zen Sphere)", "focus.range <= 40", }, "focus" },
      { "Zen Sphere", { "!focus.exists", "tank.exists", "!tank.buff(Zen Sphere)", "tank.range <= 40", }, "tank" },
    }, { "player.timetomax > 2", "!player.buff(Serenity)" }},

    -- Melee range only
    {{
      -- Opener priority during the first 10 seconds when serenity talent is selected and we haven't popped TeB yet
      -- 'ideal' opener (starting with 5 chi) is:    RSK -> TP -> CB -> CB -> BoK -> TeB -> Serenity
      -- 'unideal' opener (starting with 0 chi) is:  CB -> CB -> RSK -> TP -> Jab -> Jab -> BoK -> TeB -> Serenity
      { opener, { "player.time < 10", "talent(3,3)", "talent(7,3)", "!player.buff(116740)" }},

      -- fortifying_brew, if=target.health.percent<10 & cooldown.touch_of_death.remains=0 & (glyph.touch_of_death.enabled | chi>=3)
      -- touch_of_death, if=target.health.percent<10 & (glyph.touch_of_death.enabled | chi>=3)
      -- Use Fortifying Brew offensivley to get bigger ToD damage
      -- TODO: Add code to handle glyph
      {{
         { "!Fortifying Brew", "player.spell(Touch of Death).cooldown < 1" },
         { "!Touch of Death" },
      }, { "player.buff(Death Note)", "player.chi >= 3", "!target.id(78463)", "!target.id(76829)" }}, -- Don't use ToD if we are targetting the Slag Elemental

      -- If serenity, honor opener
      {{
        { "Chi Brew", { "!lastcast(Chi Brew)", "player.spell(Chi Brew).charges = 2" }},
        { "Chi Brew", { "player.spell(Chi Brew).charges = 1", "player.spell(Chi Brew).recharge <= 10", "!lastcast(Chi Brew)" }},
      }, { "player.chidiff >= 2", "player.buff(Tigereye Brew).count <= 16", "player.time >= 10", "talent(7,3)" }},

      -- If not serenity, disregard opener
      {{
        { "Chi Brew", { "!lastcast(Chi Brew)", "player.spell(Chi Brew).charges = 2" }},
        { "Chi Brew", { "player.spell(Chi Brew).charges = 1", "player.spell(Chi Brew).recharge <= 10", "!lastcast(Chi Brew)" }},
        }, { "player.chidiff >= 2", "player.buff(Tigereye Brew).count <= 16", "!talent(7,3)" }},

      { "Tiger Palm", { "!talent(7,2)", "player.buff(Tiger Power).duration < 6.6" }},
      { "Tiger Palm", { "talent(7,2)", "player.buff(Tiger Power).duration < 5", "player.spell(Fists of Fury).cooldown < 5" }},

      -- Tigereye Brew
      {{
        { "116740", "player.buff(125195).count = 20" },
        { "116740", { "player.buff(125195).count >= 9", "player.buff(Serenity).duration > 1" }},
        {{
          -- Pop TeB anytime we have any sort of proc or big buff
          {{
            { "116740", "player.spell(Fists of Fury).cooldown < 1" },
            { "116740", { "player.spell(Hurricane Strike).cooldown < 1", "talent(7,1)" }},
            { "116740", "@NOC.StatProcs('agility')" }, -- Any agility buff
            { "116740", "@NOC.StatProcs('multistrike')" }, -- Any multistrike buff
            { "116740", "player.hashero" },
          },{ "player.chi >= 2", "player.time >= 10" }},
          --"player.chi >= 3", "player.buff(125195).count >= 9"
          {{
            { "116740", { "player.buff(125195).count >= 16" }},
          },{ "player.chi >= 2" }},
        },{ "target.debuff(Rising Sun Kick)", "player.buff(Tiger Power)" }},
      },{ "!player.buff(116740)", "!lastcast(116740)" }},

      { "Rising Sun Kick", "!target.debuff(Rising Sun Kick)" },
      { "Rising Sun Kick", "target.debuff(Rising Sun Kick).duration < 3" },

      -- Serenity whenever TeB buff is up
      { "Serenity", { "talent(7,3)", "player.buff(116740)", "player.chi >= 2", "target.debuff(Rising Sun Kick)", "player.buff(Tiger Power)", "modifier.cooldowns" }},

      {{
        { "Fists of Fury", { "!player.moving", "player.lastmoved > 1", "!player.glyph(Glyph of the Floating Butterfly)" }},
        { "Fists of Fury", "player.glyph(Glyph of the Floating Butterfly)" },
      }, { "!player.buff(Serenity)", "target.debuff(Rising Sun Kick).duration > 3.6", "player.chi >= 3", "player.buff(Tiger Power).duration > 3.6" }},

      { "Hurricane Strike", {
        "talent(7,1)",
        "player.timetomax > 2",
        "target.debuff(Rising Sun Kick).duration > 2",
        "player.buff(Tiger Power).duration > 2",
        "!player.buff(Energizing Brew)" }},

      {{
        { "Energizing Brew", "!talent(7,3)" },
        { "Energizing Brew", { "!player.buff(Serenity)", "player.spell(Serenity).cooldown > 4" }},
      },{ "player.spell(Fists of Fury).cooldown > 6", "@NOC.energyTime(50)" }},

      -- AoE
      { aoe, { "toggle.multitarget", "modifier.enemies >= 3" }},

      -- Not specced into Chi Explosion
      { st, "!talent(7,2)" },
      -- Specced into Chi Explosion
      { st_chex, "talent(7,2)" },

      { "Expel Harm", { "player.health <= 95", "player.chidiff >= 2" }},
      { "Jab", "player.chidiff >= 2" },

    }, { "target.range <= 5" }},

    -- Tiger's Lust if the target is out of melee range and we are moving for at least 0.5 second
    { "Tiger's Lust", { "target.range > 5", "player.movingfor > 0.5", "target.alive" }},

    -- Crackling Jade Lightning (on toggle)
    {{
      {"/stopcasting", { "target.range <= 5", "player.casting(Crackling Jade Lightning)" }},
      { "Crackling Jade Lightning", { "target.range > 8", "target.range <= 40", "!player.moving", "target.combat" }},
    }, "toggle.cjl" },
  }, "@NOC.immuneEvents('target')" },
}

ProbablyEngine.rotation.register_custom(269, "|cFF32ff84NOC Windwalker Monk|r", combat, ooc, onLoad)
