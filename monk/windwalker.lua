-- ProbablyEngine Rotation Packager
-- NO CARRIER's Windwalker Monk Rotation

local onLoad = function()
  ProbablyEngine.toggle.create('sint', 'Interface\\Icons\\ability_monk_spearhand', 'Sudden Interrupt', 'Stop spellcasting in order to use an interrupt')
  ProbablyEngine.toggle.create('chistacker', 'Interface\\Icons\\ability_monk_expelharm', 'Stack Chi', 'Keep Chi at full even OoC...')
  ProbablyEngine.toggle.create('rjw', 'Interface\\Icons\\ability_monk_rushingjadewind', 'RJW/SCK', 'Enable use of Rushing Jade Wind or Spinning Crane Kick when using Chi Explosion')
  ProbablyEngine.toggle.create('cjl', 'Interface\\Icons\\ability_monk_cracklingjadelightning', 'Crackling Jade Lightning', 'Enable use of automatic Crackling Jade Lightning when the target is in combat and at range')
  ProbablyEngine.toggle.create('dpstest', 'Interface\\Icons\\inv_misc_pocketwatch_01', 'DPS Test', 'Stop combat after 5 minutes in order to do a controlled DPS test')
  ProbablyEngine.toggle.create('autosef', 'Interface\\Icons\\spell_sandstorm', 'Auto SEF', 'Automatically cast SEF on mouseover targets')

  NOC.BaseStatsTableInit()

  C_Timer.NewTicker(0.25, (
      function()
        if ProbablyEngine.config.read('button_states', 'MasterToggle', false) then
          NOC.BaseStatsTableUpdate()
        end
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

  -- Only use this is we have the RJW talent and there are 3 or more enemies and toggle enabled
  { "Rushing Jade Wind", { "talent(6,1)", "modifier.enemies >= 3", "toggle.rjw" }},
  -- Otherwise, use it 'normally' if we aren't using chi explosion
  { "Rushing Jade Wind", { "talent(6,1)", "!talent(7,2)" }},

  {{
    { "Chi Wave" },
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
  }, { "talent(6,1)" }},

  -- If we do NOT have RJW
  {{
    { "Blackout Kick", { "!talent(7,2)", "player.chidiff < 2" }},

    -- Only do this if we do not have RJW talent and there are more than 3 enemies and toggle enabled
    { "Spinning Crane Kick", { "modifier.enemies >= 4", "toggle.rjw" }},
    -- Otherwise, use it 'normally' if we aren't using chi explosion
    { "Spinning Crane Kick", { "!talent(7,2)" }},

  }, { "!talent(6,1)" }},

  { "Expel Harm", { "player.health <= 95", "player.chidiff >= 2" }},
  { "Jab", "player.chidiff >= 2" },
}

local st = {
  { "Rising Sun Kick" },

  { "Blackout Kick", "player.buff(Combo Breaker: Blackout Kick)" },
  { "Blackout Kick", "player.buff(Serenity)" },

  { "Tiger Palm", { "player.buff(Combo Breaker: Tiger Palm)", "player.buff(Combo Breaker: Tiger Palm).duration <= 2" }},

  { "Blackout Kick", "player.chidiff < 2" },
}

local st_chex = {
  { "Chi Explosion", { "player.chi >= 2", "player.buff(Combo Breaker: Chi Explosion)", "player.spell(Fists of Fury).cooldown > 2" }},

  { "Tiger Palm", { "player.buff(Combo Breaker: Tiger Palm)", "player.buff(Combo Breaker: Tiger Palm).duration <= 2" }},

  { "Rising Sun Kick" },

  { "Tiger Palm", { "player.chi >= 4", "!player.buff(Combo Breaker: Chi Explosion)" }},

  { "Chi Explosion", { "player.chi >= 3", "player.spell(Fists of Fury).cooldown > 4" }},
}

local opener = {
  -- 'ideal' opener (starting with 5 chi) is:    RSK -> TP -> CB -> CB -> BoK -> TeB -> FoF -> Jab -> Serenity (~10 GCD before serenity?)
  -- 'unideal' opener (starting with 0 chi) is:  CB -> CB -> RSK -> TP -> Jab -> Jab -> BoK -> TeB -> FoF -> Jab -> Serenity
  {{
    -- This should 'constrain' BoK to be only casted once during the opener
    { "Blackout Kick", { "player.chidiff <= 1", "player.spell(Blackout Kick).casted = 0" }},

    -- Only FoF if TeB & BoK have been casted
    {{
      { "Fists of Fury", { "!player.moving", "player.lastmoved > 0.5", "!player.glyph(Floating Butterfly)" }},
      { "Fists of Fury", "player.glyph(Floating Butterfly)" },
    }, { "player.buff(116740)", "player.spell(Blackout Kick).casted != 0" }},

    -- TeB when we have used both Chi Brews and have casted BoK at least once
    { "116740", { "!player.buff(116740)", "player.spell(Chi Brew).charges = 0", "player.spell(Blackout Kick).casted != 0" }},

  }, { "player.buff(Tiger Power)", "target.debuff(Rising Sun Kick)" }},

  { "Chi Brew", { "!lastcast(Chi Brew)", "player.chidiff >= 2" }}, -- 0-3 chi

  { "Jab", "player.chidiff >= 2" }, -- 0-3 chi
}

local interrupts = {
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
}

local teb = {
  { "116740", "player.proc(agility)" }, -- Any agility buff
  { "116740", "player.proc(multistrike)" }, -- Any multistrike buff
  { "116740", "player.hashero" },
  { "116740", { "player.spell(Fists of Fury).cooldown < 1", "player.chi >= 3" }},
  { "116740", { "player.spell(Hurricane Strike).cooldown < 1", "talent(7,1)", "player.chi >= 3" }},
}

local combat = {
  -- Pause
  { "pause", "modifier.lshift" },

  { "pause", "player.casting(115176)" }, -- Pause for Zen Meditation
  { "/stopcasting\n/stopattack\n/cleartarget\n/stopattack\n/cleartarget", { "player.time >= 300", "toggle.dpstest" }},

  -- AutoTarget
  { "/targetenemy [noexists]", "!target.exists" },
  { "/targetenemy [dead]", { "target.exists", "target.dead" } },

  -- Keyboard modifiers
  { "Leg Sweep", "modifier.lcontrol" },
  { "Touch of Karma", "modifier.lalt" },

  -- Buffs
  { buffs, },

  { "Storm, Earth, and Fire", { "!player.buff(137639).count = 2", "@NOC.canSEF('mouseover')" }, "mouseover" },
  -- Auto SEF when enabled
  { "Storm, Earth, and Fire", { "toggle.autosef", "!player.buff(137639).count = 2", "@NOC.autoSEF()", },},
  { "/cancelaura Storm, Earth, and Fire", { "target.debuff(Storm, Earth, and Fire)" }},

  { interrupts, { "target.interruptsAt(40)", "toggle.sint" }}, -- Interrupt when 40% into the cast time
  { interrupts, { "target.interruptAt(40)", "!toggle.sint" }}, -- Interrupt when 40% into the cast time

  {{ -- while not casting
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

    -- wrapper for "@NOC.isValidTarget" which prevents the following from occuring when the target is CCed or otherwise not allowed to be attacked
    {{
      -- ToD prioritization
      {{
        -- If not glyphed, Jab immediatley to get enough chi for ToD
        { "Jab", { "player.chi < 3", "!player.glyph(Touch of Death)" }},
        {{
          -- If not glyphed, Fort Brew Immediatley if we have at least 3 chi
          { "Fortifying Brew", { "player.chi >= 3", "!player.glyph(Touch of Death)" }},
          -- If glyphed, Fort Brew Immediatley
          { "Fortifying Brew", "player.glyph(Touch of Death)" }, -- Only if the target's current health is > our max health
        }, "target.health.actual > player.health.max" }, -- Only if the target's current health is > our max health
        { "!Touch of Death" },
      }, { "player.buff(Death Note)", "player.spell(Touch of Death).cooldown < 1", "@NOC.notBlacklist('target')", "target.range <= 5" }}, -- Don't use ToD if we are targetting a blacklisted unit

      {{
        { "Chi Wave" }, -- 40 yard range 0 energy, 0 chi
        { "Chi Burst", { "!player.moving", "talent(2,3)" }},
      }, { "player.timetomax > 2", "!player.buff(Serenity)" }},

      {{
         -- Cooldowns/Racials
         { "Lifeblood" },
         { "Berserking" },
         { "Blood Fury" },
         { "Invoke Xuen, the White Tiger" },
        -- Use with TeB
         { "#trinket1", "player.buff(116740)" },
         { "#trinket2", "player.buff(116740)" },
      }, "modifier.cooldowns" },

      -- Should this be moved after the melee-range check? Worried that it may be prioritized too much
      {{
        { "Zen Sphere", "!player.buff(Zen Sphere)" },
        --{ "Zen Sphere", { "focus.exists", "!focus.buff(Zen Sphere)", "focus.range <= 40", }, "focus" },
        { "Zen Sphere", { "tank.exists", "!tank.buff(Zen Sphere)", "tank.range <= 40", }, "tank" },
      }, { "player.timetomax > 2", "!player.buff(Serenity)" }},

      -- Melee range only
      {{
        -- Opener priority during the first 10 seconds when serenity & chi brew talents are selected and we haven't popped TeB yet
        { opener, { "player.time < 16", "talent(3,3)", "talent(7,3)", "player.spell(Fists of Fury).casted = 0" }},

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

        -- Tigereye Brew only if the buff isn't up already
        {{
          -- Use no matter what if we are at 20 stacks
          { "116740", "player.buff(125195).count = 20" },

          -- Use when at 9+ stacks and Serenity buff is up
          { "116740", { "player.buff(125195).count >= 9", "player.buff(Serenity).duration > 1" }},

          -- Only use when RSK debuff & TP buff are active
          {{
            -- Big procs, FoF ready, HS ready, or 16+ stacks
            {{
              { teb, { "player.tier17 >= 4", "player.buff(125195).count >= 9" }}, -- 9+ stacks (with proc) with T17 4pc set
              { teb, { "player.tier17 < 4" }}, -- Pop any time (with proc) when not using T17 4pc set
              { "116740", "player.buff(125195).count >= 16" },
            },{ "player.chi >= 2", "player.time >= 10" }},

          },{ "target.debuff(Rising Sun Kick)", "player.buff(Tiger Power)" }},
        },{ "!player.buff(116740)", "!lastcast(116740)" }},

        { "Rising Sun Kick", "!target.debuff(Rising Sun Kick)" },
        { "Rising Sun Kick", "target.debuff(Rising Sun Kick).duration < 3" },

        {{
          -- If we are in the opener, pop Serenity only after we have used TeB & FoF
          { "Serenity", { "player.buff(116740)", "player.time < 10", "player.spell(Fists of Fury).casted != 0" }},
          { "Serenity", { "player.time >= 10" }},
        }, { "talent(7,3)", "player.chi >= 2", "target.debuff(Rising Sun Kick)", "player.buff(Tiger Power)", "modifier.cooldowns" }},

        {{
          { "Fists of Fury", { "!player.moving", "player.lastmoved > 0.5", "!player.glyph(Floating Butterfly)" }},
          { "Fists of Fury", "player.glyph(Floating Butterfly)" },
        }, { "!player.buff(Serenity)", "target.debuff(Rising Sun Kick).duration > 3.6", "player.buff(Tiger Power).duration > 3.6" }},

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
        { aoe, { "toggle.multitarget", "modifier.enemies >= 2" }},

        -- Not specced into Chi Explosion
        { st, "!talent(7,2)" },
        -- Specced into Chi Explosion
        { st_chex, "talent(7,2)" },

        { "Expel Harm", { "player.health <= 95", "player.chidiff >= 2" }},
        { "Jab", "player.chidiff >= 2" },

      }, { "!player.casting", "target.range <= 5" }},

      -- Tiger's Lust if the target is out of melee range and we are moving for at least 0.5 second
      { "Tiger's Lust", { "target.range > 5", "player.movingfor > 0.5", "target.alive" }},

      -- Crackling Jade Lightning (on toggle)
      {{
        {"/stopcasting", { "target.range <= 5", "player.casting(Crackling Jade Lightning)" }},
        { "Crackling Jade Lightning", { "target.range > 8", "target.range <= 40", "!player.moving", "target.combat" }},
      }, "toggle.cjl" },
    }, "@NOC.isValidTarget('target')" },
  }, "!player.casting" },
}

ProbablyEngine.rotation.register_custom(269, "|cFF32ff84NOC Windwalker Monk|r", combat, ooc, onLoad)
