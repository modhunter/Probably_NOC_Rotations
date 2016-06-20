-- ProbablyEngine Rotation Packager
-- NO CARRIER's Havoc Demon Hunter Rotation

local onLoad = function()
  ProbablyEngine.toggle.create('sint', 'Interface\\Icons\\ability_monk_spearhand', 'Sudden Interrupt', 'Stop spellcasting in order to use an interrupt')
  ProbablyEngine.toggle.create('auto_jump', 'Interface\\Icons\\ability_monk_spearhand', 'Automatic Jumping', 'Automatically perform Vengeful Retreat & Fel Rush')
  ProbablyEngine.toggle.create('dpstest', 'Interface\\Icons\\inv_misc_pocketwatch_01', 'DPS Test', 'Stop combat after 5 minutes in order to do a controlled DPS test')

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
}

local interrupts = {
  { "Consume Magic" },
}

local combat = {
  -- Pause
  { "pause", "modifier.lshift" },

  { "/stopcasting\n/stopattack\n/cleartarget\n/stopattack\n/cleartarget", { "player.time >= 300", "toggle.dpstest" }},

  -- AutoTarget
  { "/targetenemy [noexists]", "!target.exists" },
  { "/targetenemy [dead]", { "target.exists", "target.dead" } },

  -- Keyboard modifiers
  { "Chaos Nova", "modifier.lcontrol" },
  { "Darkness", "modifier.lalt" },

  { interrupts, { "target.interruptsAt(40)", "toggle.sint" }}, -- Interrupt when 40% into the cast time
  { interrupts, { "target.interruptAt(40)", "!toggle.sint" }}, -- Interrupt when 40% into the cast time

  {{ -- while not casting
    -- Self-Healing & Defensives
    { "Blur", { "player.health <= 70" }},
    { "Desperate Instincts", { "player.health <= 70" }},
    { "Netherwalk", { "player.health <= 70" }},

    { "#109223", "player.health < 40" }, -- Healing Tonic
    { "#5512", "player.health < 40" }, -- Healthstone

    -- wrapper for "@NOC.isValidTarget" which prevents the following from occuring when the target is CCed or otherwise not allowed to be attacked
    {{
      {{
        { "Eye Beam", "!talent(3,2)" },
        { "Eye Beam", "player.fury >= 80" },
        { "Eye Beam", "player.furydiff < 30" },
      }, { "talent(5,1)", "!player.buff(Momentum)" }},
      { "Eye Beam", { "!talent(5,1)", "toggle.multitarget", "modifier.enemies >= 2" }},

      { "Throw Glaive", { "talent(3,3)", "talent(1,2)", "toggle.multitarget", "modifier.enemies >= 2" }},
      { "Throw Glaive", { "!player.buff(Metamorphosis)", "talent(3,3)" }},
      { "Throw Glaive", { "!player.buff(Metamorphosis)", "toggle.multitarget", "modifier.enemies >= 3" }},

      {{
         -- Cooldowns/Racials
         { "Lifeblood" },
         { "Berserking" },
         { "Blood Fury" },
         {{
           { "Metamorphosis", { "player.spell(Chaos Blades).cooldown < 1" }, "target" },
           { "Metamorphosis", { "player.buff(Chaos Blades)" }, "target" },
           { "Metamorphosis", { "!talent(6,3)" }, "target" },
           -- TODO: Handle demonic talent and eye beam
         }, { "!player.buff(Metamorphosis)" }},
      }, "modifier.cooldowns" },

      -- { "Nemsis", "target.ttd < 60" },
      { "Nemsis" },

      -- Melee range only
      {{
        {{
          { "/run AscendStop()", "player.buff(Vengeful Retreat)" },
          { "/run AscendStop()", "player.buff(Fel Rush)" },
          { "Vengeful Retreat", { "talent(5,1)", "!player.buff(Momentum)" }},
          { "Vengeful Retreat", { "!talent(5,1)" }},
          { "Fel Rush", { "talent(5,1)", "!player.buff(Momentum)", "player.spell(Fel Rush).charges = 2" }},
          { "Fel Rush", { "talent(5,1)", "!player.buff(Momentum)", "player.spell(Vengeful Retreat).cooldown > 4" }},
        }, "toggle.auto_jump" },

        { "Chaos Blades", { "!player.buff(Chaos Blades)", "player.spell(Metamorphosis).cooldown > 100" }},
        { "Chaos Blades", "player.buff(Metamorphosis)" },

        { "Death Sweep", "talent(3,2)" },
        { "Death Sweep", { "talent(1,2)", "toggle.multitarget", "modifier.enemies >= 2" }},

        {{
          { "Demon's Bite", "talent(3,2)" },
          { "Demon's Bite", { "talent(1,2)", "toggle.multitarget", "modifier.enemies >= 2" }},
        }, { "player.buff(Metamorphosis).duration > 1.5", "player.spell(Blade Dance).cooldown < 1.5", "player.fury < 70" }},

        { "Blade Dance", "talent(3,2)" },
        { "Blade Dance", { "talent(1,2)", "toggle.multitarget", "modifier.enemies >= 2" }},
        { "Fel Barrage", "player.spell(Fel Barrage).charges >= 5" },

        { "Fury of the Illidari", "!player.buff(Momentum)" },
        { "Fury of the Illidari", { "talent(1,2)", "toggle.multitarget", "modifier.enemies >= 2" }},

        { "Felblade", { "player.furydiff >= 30", "!player.buff(Prepared)" }},
        { "Felblade", { "player.furydiff >= 42", "player.buff(Prepared)" }},

        { "Annihilation" },
        { "Fel Erruption" },

        {{
          { "Demon's Bite", "talent(3,2)" },
          { "Demon's Bite", { "talent(1,2)", "toggle.multitarget", "modifier.enemies >= 2" }},
        }, { "!player.buff(Metamorphosis)", "player.spell(Blade Dance).cooldown < 1.5", "player.fury < 55" }},
        {{
          { "Demon's Bite", { "player.spell(Eye Beam).cooldown < 1.5", "player.furydiff >= 30" }},
          { "Demon's Bite", { "player.spell(Eye Beam).cooldown < 3", "player.furydiff >= 55" }},
        }, { "!player.buff(Metamorphosis)", "talent(7,3)" }},

        { "Chaos Strike" },
        { "Fel Barrage", { "player.spell(Fel Barrage).charges >= 4", "!player.buff(Metamorphosis)" }},
        { "Demon's Bite" },

      }, { "!player.channeling", "target.range <= 5" }},

    }, "@NOC.isValidTarget('target')" },
  }, "!player.channeling" },
}

ProbablyEngine.rotation.register_custom(577, "|cFF32ff84NOC Havoc Demonk Hunter|r", combat, ooc, onLoad)
