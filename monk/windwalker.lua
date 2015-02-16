-- ProbablyEngine Rotation Packager
-- NO CARRIER's Windwalker Monk Rotation

local onLoad = function()
  ProbablyEngine.toggle.create('chistacker', 'Interface\\Icons\\ability_monk_expelharm', 'Stack Chi', 'Keep Chi at full even OoC...')
  ProbablyEngine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automatically target the nearest enemy when target dies or does not exist')
  ProbablyEngine.toggle.create('rjw', 'Interface\\Icons\\ability_monk_rushingjadewind', 'RJW/SCK', 'Enable use of Rushing Jade Wind or Spinning Crane Kick when using Chi Explosion')
  ProbablyEngine.toggle.create('cjl', 'Interface\\Icons\\ability_monk_cracklingjadelightning', 'Crackling Jade Lightning', 'Enable use of automatic Crackling Jade Lightning when the target is in combat and at range')
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
  { "Expel Harm", "toggle.chistacker" },
}

local aoe = {
  {{
    { "Chi Explosion", "player.spell(Fists of Fury).cooldown > 3" },
    { "Chi Explosion", "!talent(6,1)" },
  }, "player.chi >= 4" },

  {{
    { "Energizing Brew", "!talent(7,3)" },
    { "Energizing Brew", { "!player.buff(Serenity)", "player.spell(Serenity).cooldown > 4" }},
  },{ "player.spell(Fists of Fury).cooldown > 6", "player.timetomax > 5" }},

  -- Only use this is we have the RJW talent and there are more than 3 enemies and toggle enabled
  { "Rushing Jade Wind", { "talent(6,1)", "modifier.enemies > 3", "toggle.rjw" }},
  -- Otherwise, use it 'normally' if we aren't using chi explosion
  { "Rushing Jade Wind", { "talent(6,1)", "!talent(7,2)" }},

  { "Rising Sun Kick", "player.chidiff = 0" },

  {{
    { "Fists of Fury", { "!player.moving", "player.lastmoved > 1", "!player.glyph(Glyph of the Floating Butterfly)" }},
    { "Fists of Fury", "player.glyph(Glyph of the Floating Butterfly)" },
  }, {
    "player.spell(Rushing Jade Wind).exists",
    "player.timetomax > 4",
    "player.buff(Tiger Power).duration > 4",
    "target.debuff(Rising Sun Kick).duration > 4", }},

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

  -- Only do this if we have RJW talent and not chex talent
  {{
    { "Blackout Kick", "player.buff(Combo Breaker: Blackout Kick)" },
    { "Blackout Kick", "player.buff(Serenity).duration > 0" },
  },{ "talent(6,1)", "!talent(7,2)" }},

  { "Tiger Palm", { "player.spell(Rushing Jade Wind).exists", "player.buff(Combo Breaker: Tiger Palm)", "player.buff(Combo Breaker: Tiger Palm).duration <= 2" }},

  -- Only do this if we have RJW talent and not chex talent
  { "Blackout Kick", { "talent(6,1)", "!talent(7,2)", "player.chidiff < 2", "player.spell(Fists of Fury).cooldown > 3"  }},

  -- Only do this if we do not have RJW talent and there are more than 3 enemies and toggle enabled
  { "Spinning Crane Kick", { "!talent(6,1)", "modifier.enemies > 3", "toggle.rjw" }},
  -- Otherwise, use it 'normally' if we aren't using chi explosion
  { "Spinning Crane Kick", { "!talent(6,1)", "!talent(7,2)" }},

  { "Jab", { "player.spell(Rushing Jade Wind).exists", "player.chidiff >= 2" }},
  { "Jab", { "player.spell(Rushing Jade Wind).exists", "player.chidiff >= 1", "talent(7,2)", "player.spell(Fists of Fury).cooldown > 3" }},
}

local st = {
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

  { "Chi Explosion", { "talent(7,2)", "player.chi >= 3", "player.buff(Combo Breaker: Chi Explosion)", "player.spell(Fists of Fury).cooldown > 3" }},

  { "Tiger Palm", { "player.buff(Combo Breaker: Tiger Palm)", "player.buff(Combo Breaker: Tiger Palm).duration < 6" }},

  { "Blackout Kick", { "!talent(7,2)", "player.chidiff < 2" }},

  { "Chi Explosion", { "talent(7,2)", "player.chi >= 3", "player.spell(Fists of Fury).cooldown > 3" }},

  -- If Serenity, honor opener
  { "Jab", { "player.chidiff >= 2", "player.energy >= 45", "player.time >= 6", "talent(7,3)" }},
  { "Jab", { "player.chidiff >= 1", "talent(7,2)", "player.spell(Fists of Fury).cooldown > 3", "player.time >= 6", "talent(7,3)" }},
  -- If not serenity, disregard opener
  { "Jab", { "player.chidiff >= 2", "player.energy >= 45", "!talent(7,3)" }},
  { "Jab", { "player.chidiff >= 1", "talent(7,2)", "player.spell(Fists of Fury).cooldown > 3", "!talent(7,3)" }},
}

local st_chex = {

}

local combat = {
  -- Pause
  { "pause", "modifier.lshift" },
  { "pause", "player.casting(115176)" }, -- Pause for Zen Meditation

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
       "player.spell(Spear Hand Strike).cooldown > 0",
       "player.spell(Quaking Palm).cooldown > 0",
       "!lastcast(Spear Hand Strike)"
    }},
    { "Ring of Peace", { -- Ring of Peace when SHS is on CD
       "!target.debuff(Spear Hand Strike)",
       "player.spell(Spear Hand Strike).cooldown > 0",
       "!lastcast(Spear Hand Strike)"
    }},
    { "Leg Sweep", { -- Leg Sweep when SHS is on CD
       "player.spell(116705).cooldown > 0",
       "target.range <= 5",
       "!lastcast(116705)"
    }},
    { "Charging Ox Wave", { -- Charging Ox Wave when SHS is on CD
       "player.spell(116705).cooldown > 0",
       "target.range <= 30",
       "!lastcast(116705)"
    }},
    { "Quaking Palm", { -- Quaking Palm when SHS is on CD
       "!target.debuff(Spear Hand Strike)",
       "player.spell(Spear Hand Strike).cooldown > 0",
       "!lastcast(Spear Hand Strike)"
    }},
    { "Spear Hand Strike" }, -- Spear Hand Strike
  }, "target.interruptsAt(40)" }, -- Interrupt when 40% into the cast time

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
       { "#trinket1", "player.buff(116740)" },
       { "#trinket2", "player.buff(116740)" },
    }, "modifier.cooldowns" },

    -- Melee range only
    {{
      -- Opener priority during the first 10 seconds when serenity talent is selected and hasn't been cast yet
      -- 'ideal' opener (with 5 chi) is:    RSK -> TP -> CB -> CB -> BoK -> TeB -> FoF -> Jab -> Serenity
      -- 'unideal' opener (with 2 chi) is:  RSK -> Jab -> TP -> CB -> CB -> BoK -> TeB -> FoF -> Jab -> Serenity
      {{
        {{
          -- This should 'constrain' BoK to be only casted once
          { "Blackout Kick", { "!talent(7,2)", "player.spell(Blackout Kick).casted < 1" }},

          { "Chi Brew", { "player.chidiff >= 2" }},

          -- TeB when we have at least 5 stacks and we have casted BoK at least once
          { "116740", { "player.buff(125195).count >= 9", "!player.buff(116740)", "!lastcast(116740)", "player.spell(Blackout Kick).casted >= 1" }},

          { "Fists of Fury", { "!player.moving", "player.lastmoved > 1", "!player.glyph(Glyph of the Floating Butterfly)" }},
          { "Fists of Fury", "player.glyph(Glyph of the Floating Butterfly)" },

        }, { "player.buff(Tiger Power)", "target.debuff(Rising Sun Kick)" }},
        { "Jab", "player.chi <= 1" },
      }, { "player.time < 10", "talent(7,3)", "!player.buff(Serenity)" }},

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
      }, { "player.chidiff >= 2", "player.buff(Tigereye Brew).count <= 16", "player.time >= 6", "talent(7,3)" }},

      -- If not serenity, disregard opener
      {{
        { "Chi Brew", { "!lastcast(Chi Brew)", "player.spell(Chi Brew).charges = 2" }},
        { "Chi Brew", { "player.spell(Chi Brew).charges = 1", "player.spell(Chi Brew).recharge <= 10", "!lastcast(Chi Brew)" }},
        }, { "player.chidiff >= 2", "player.buff(Tigereye Brew).count <= 16", "!talent(7,3)" }},

      { "Tiger Palm", "player.buff(Tiger Power).duration < 6.6" },

      -- TODO: Pop TeB early when any sort of weapon/trinket/etc proc goes
      -- Tigereye Brew
      {{
        { "116740", "player.buff(125195).count = 20" },
        { "116740", { "player.buff(125195).count >= 9", "player.buff(Serenity).duration > 1" }},
        {{
          {{
            { "116740", "player.spell(Fists of Fury).cooldown < 1" },
            { "116740", { "player.spell(Hurricane Strike).cooldown < 1", "talent(7,1)" }},
            { "116740", "@NOC.StatProcs('agility')" }, -- Any agility buff
            { "116740", "@NOC.StatProcs('multistrike')" }, -- Any multistrike buff
            --{ "116740", "player.buff(177161)" }, -- ArchmagesIncandescence (+10% Agility)
            --{ "116740", "player.buff(177172)" }, -- ArchmagesGreaterIncandescence (+?% Agility)
            --{ "116740", "player.buff(176878)" }, -- Lub-Dub (Beatring Heart of the Mountain Proc) (+Multistrike)
            --{ "116740", "player.buff(159676)" }, -- Mark of the Frostwolf (+Multistrike)
            { "116740", "player.hashero" },
          },{ "player.chi >= 3", "player.buff(125195).count >= 9" }},
          {{
            { "116740", { "player.buff(125195).count >= 16" }},
          },{ "player.chi >= 2" }},
        },{ "target.debuff(Rising Sun Kick)", "player.buff(Tiger Power)" }},
      },{ "!player.buff(116740)", "!lastcast(116740)" }},

      { "Rising Sun Kick", "!target.debuff(Rising Sun Kick)" },
      { "Rising Sun Kick", "target.debuff(Rising Sun Kick).duration < 3" },

      { "Serenity", { "talent(7,3)", "player.time >= 6", "player.chi >= 2", "target.debuff(Rising Sun Kick)", "player.buff(Tiger Power)", "modifier.cooldowns" }},

      {{
        { "Fists of Fury", { "!player.moving", "player.lastmoved > 1", "!player.glyph(Glyph of the Floating Butterfly)" }},
        { "Fists of Fury", "player.glyph(Glyph of the Floating Butterfly)" },
      }, { "!player.buff(Serenity)", "target.debuff(Rising Sun Kick).duration > 3.6", "player.timetomax > 3.6", "player.buff(Tiger Power).duration > 3.6" }},

      { "Hurricane Strike", {
        "talent(7,3)",
        "player.timetomax > 2",
        "target.debuff(Rising Sun Kick).duration > 2",
        "player.buff(Tiger Power).duration > 2",
        "!player.buff(Energizing Brew)" }},

      {{
        { "Energizing Brew", "!talent(7,3)" },
        { "Energizing Brew", { "!player.buff(Serenity)", "player.spell(Serenity).cooldown > 4" }},
      },{ "player.spell(Fists of Fury).cooldown > 6", "@NOC.energyTime < 50" }},

      -- AoE
      { aoe, { "toggle.multitarget", "modifier.enemies >= 3" }},

      -- Not specced into Chi Explosion
      { st, { "!talent(7,2)", "modifier.enemies < 3" }},

      -- Specced into Chi Explosion
      { st_chex, { "talent(7,2)", "modifier.enemies < 3" }},

    }, { "target.range <= 5" }},

    -- Tiger's Lust if the target is at least 10 yards away and we are moving for at least 0.5 second
    { "Tiger's Lust", { "target.range >= 5", "player.movingfor > 0.5", "target.alive" }},

    -- Crackling Jade Lightning (on toggle)
    {{
      {"/stopcasting", { "target.range <= 5", "player.casting(Crackling Jade Lightning)" }},
      { "Crackling Jade Lightning", { "target.range > 8", "target.range <= 40", "!player.moving", "target.combat" }},
    }, "toggle.cjl" },
  }, "@NOC.immuneEvents('target')" },
}

ProbablyEngine.rotation.register_custom(269, "|cFF32ff84NOC Windwalker Monk|r", combat, ooc, onLoad)
