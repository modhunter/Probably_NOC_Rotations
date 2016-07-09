-- ProbablyEngine Rotation Packager
-- NO CARRIER's Windwalker Monk Rotation

local onLoad = function()
  ProbablyEngine.toggle.create('sint', 'Interface\\Icons\\ability_monk_spearhand', 'Sudden Interrupt', 'Stop spellcasting in order to use an interrupt')
  ProbablyEngine.toggle.create('cjl', 'Interface\\Icons\\ability_monk_cracklingjadelightning', 'Crackling Jade Lightning', 'Enable use of automatic Crackling Jade Lightning when the target is in combat and at range')
  ProbablyEngine.toggle.create('nb', 'Interface\\Icons\\spell_monk_nimblebrew', 'Automatic use of Nimble Brew/Tigers Lust', 'Enable use of automatic Nimble Brew/Tigers Lust when the player is rooted')
  ProbablyEngine.toggle.create('dpstest', 'Interface\\Icons\\inv_misc_pocketwatch_01', 'DPS Test', 'Stop combat after 5 minutes in order to do a controlled DPS test')
  --ProbablyEngine.toggle.create('autosef', 'Interface\\Icons\\spell_sandstorm', 'Auto SEF', 'Automatically cast SEF on mouseover targets')

  NOC.BaseStatsTableInit()

  C_Timer.NewTicker(0.25, (
      function()
        if ProbablyEngine.config.read('button_states', 'MasterToggle', false) then
          NOC.BaseStatsTableUpdate()
        end
      end),
  nil)
end

local ooc = {
  { "Effuse", "player.health < 100" },
}

local aoe = {
  { "Spinning Crane Kick", { "!talent(6,1)" }},
}

local st = {
  --{ "Blackout Kick", { "player.tier18 >= 2" }},

  { "Rising Sun Kick" },

  { "Blackout Kick", { "player.buff(Serenity)" }},

  {{
    { "Chi Wave" }, -- 40 yard range 0 energy, 0 chi
    { "Chi Burst", { "!player.moving" }},
  }, { "!player.buff(Serenity)" }},

  { "Rushing Jade Wind", { "player.chidiff <= 3" }},

  { "Blackout Kick", { "player.chidiff <= 3" }},

  { "Tiger Palm", { "player.buff(Power Strikes)", "player.chidiff >= 3" }},

  { "Tiger Palm", { "!player.buff(Power Strikes)", "player.chidiff >= 2" }},
}


local opener = {
  -- 'ideal' opener (starting with 5 chi) is:    RSK -> TP -> CB -> CB -> BoK -> TeB -> FoF -> Jab -> Serenity (~10 GCD before serenity?)
  -- 'unideal' opener (starting with 0 chi) is:  CB -> CB -> RSK -> TP -> Jab -> Jab -> BoK -> TeB -> FoF -> Jab -> Serenity
  -- fists_of_fury,if=buff.serenity.up&buff.serenity.remains<1.5
  -- rising_sun_kick
  -- blackout_kick,if=chi.max-chi<=1&cooldown.chi_brew.up|buff.serenity.up
  -- serenity,if=chi.max-chi<=2
  -- tiger_palm,if=chi.max-chi>=2&!buff.serenity.up
    { "Fists of Fury", { "player.buff(Serenity).duration < 1.5" }},

    { "Rising Sun Kick" },

    -- This should 'constrain' BoK to be only casted once during the opener
    {{
      { "Blackout Kick", { "player.buff(Serenity)" }},
      { "Blackout Kick", { "player.spell(Chi Brew).charges = 2" }},
    }, { "player.chidiff <= 1", "player.spell(Blackout Kick).casted = 0" }},

    { "Serenity", { "player.chidiff >= 2" }},

    { "Tiger Palm", { "player.chidiff >= 2", "!player.buff(Serenity)" }},
}

local interrupts = {
  { "Ring of Peace", { -- Ring of Peace when SHS is on CD
     "!target.debuff(Spear Hand Strike)",
     "player.spell(Spear Hand Strike).cooldown > 1",
     "!lastcast(Spear Hand Strike)"
  }},
  { "Leg Sweep", { -- Leg Sweep when SHS is on CD
     "player.spell(Spear Hand Strike).cooldown > 1",
     "target.range <= 5",
     "!lastcast(Spear Hand Strike)"
  }},
  { "Quaking Palm", { -- Quaking Palm when SHS is on CD
     "!target.debuff(Spear Hand Strike)",
     "player.spell(Spear Hand Strike).cooldown > 1",
     "!lastcast(Spear Hand Strike)"
  }},
  { "Spear Hand Strike" }, -- Spear Hand Strike
}


local combat = {
  -- Pause
  { "pause", "modifier.lshift" },

  { "/stopcasting\n/stopattack\n/cleartarget\n/stopattack\n/cleartarget", { "player.time >= 300", "toggle.dpstest" }},

  -- AutoTarget
  { "/targetenemy [noexists]", "!target.exists" },
  { "/targetenemy [dead]", { "target.exists", "target.dead" } },

  -- Keyboard modifiers
  { "Leg Sweep", "modifier.lcontrol" },
  { "Touch of Karma", "modifier.lalt" },

  --{ "Storm, Earth, and Fire", { "toggle.autosef", "!player.buff(137639).count = 2", "@NOC.canSEF('mouseover')" }, "mouseover" },
  -- Auto SEF when enabled
  --{ "Storm, Earth, and Fire", { "toggle.autosef", "!player.buff(137639).count = 2", "@NOC.autoSEF()", },},
  --{ "/cancelaura Storm, Earth, and Fire", { "target.debuff(Storm, Earth, and Fire)" }},
  --{ "/cancelaura Storm, Earth, and Fire", { "!toggle.autosef", "player.buff(137639)" }},

  { interrupts, { "target.interruptsAt(40)", "toggle.sint" }}, -- Interrupt when 40% into the cast time
  { interrupts, { "target.interruptAt(40)", "!toggle.sint" }}, -- Interrupt when 40% into the cast time

  {{ -- while not casting
    -- Self-Healing & Defensives
    { "Effuse", { "player.health <= 70", "player.energy >= 60" }},

    { "#109223", "player.health < 40" }, -- Healing Tonic
    { "#5512", "player.health < 40" }, -- Healthstone

    { "Detox", "player.dispellable(Detox)", "player" },
    { "Nimble Brew", { "@NOC.noControl()", "toggle.nb" }},
    { "Tiger's Lust", { "@NOC.noControl()", "toggle.nb" }},

    -- wrapper for "@NOC.isValidTarget" which prevents the following from occuring when the target is CCed or otherwise not allowed to be attacked
    {{
      { "Touch of Death" },

      {{
         -- Cooldowns/Racials
         { "Lifeblood" },
         { "Berserking" },
         { "Blood Fury" },
         -- Use Xuen only while hero or potion is active
         { "Invoke Xuen, the White Tiger", "player.hashero" },
         { "Invoke Xuen, the White Tiger", "player.buff(156423)" },
         --{ "#trinket1", "player.buff(116740)" },
         --{ "#trinket2", "player.buff(116740)" },
      }, "modifier.cooldowns" },

      -- Melee range only
      {{
        -- Opener priority during the first 16 seconds
        { opener, { "player.time < 16" }},

        { "Serenity", { "player.spell(Rising Sun Kick).cooldown <= 5", "player.spell(Fists of Fury).cooldown <= 9" }},

        { "Energizing Elixir", { "player.energy < 30", "player.chi < 2" }},

        { "Rushing Jade Wind", { "player.buff(Serenity)" }},

        { "Strike Of The Windlord" },

        { "Whirling Dragon Punch" },

        { "Fists of Fury" },

        -- AoE
        { aoe, { "toggle.multitarget", "modifier.enemies >= 2" }},

        { st, },

        { "Effuse", { "player.health <= 95", "player.energy >= 60" }},

      }, { "!player.channeling", "target.range <= 5" }},

      -- Tiger's Lust if the target is out of melee range and we are moving for at least 0.5 second
      { "Tiger's Lust", { "target.range > 5", "player.movingfor > 0.5", "target.alive" }},

      -- Crackling Jade Lightning (on toggle)
      {{
        {"/stopcasting", { "target.range <= 5", "player.casting(Crackling Jade Lightning)" }},
        { "Crackling Jade Lightning", { "target.range > 8", "target.range <= 40", "!player.moving", "target.combat" }},
      }, "toggle.cjl" },
    }, "@NOC.isValidTarget('target')" },
  }, "!player.channeling" },
}

ProbablyEngine.rotation.register_custom(269, "|cFF32ff84NOC Windwalker Monk|r", combat, ooc, onLoad)
