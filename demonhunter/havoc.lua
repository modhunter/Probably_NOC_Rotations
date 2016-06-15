-- ProbablyEngine Rotation Packager
-- NO CARRIER's Havoc Demon Hunter Rotation

local onLoad = function()
  ProbablyEngine.toggle.create('sint', 'Interface\\Icons\\ability_monk_spearhand', 'Sudden Interrupt', 'Stop spellcasting in order to use an interrupt')
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
  { "Consume Magic" }, -- Spear Hand Strike
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
      { "Eye Beam" },

      {{
         -- Cooldowns/Racials
         { "Lifeblood" },
         { "Berserking" },
         { "Blood Fury" },
         -- { "Metamorphosis", "player.hashero" },
         -- { "Metamorphosis", "player.buff(156423)" },
         -- { "Metamorphosis" }, "ground",
         { "Metamorphosis", "ground" },

      }, "modifier.cooldowns" },

      -- Melee range only
      {{
        { "Blade Dance" },
        { "Fury of the Illidari" },
        { "Felblade" },
        { "Demon's Bite" },
        { "Chaos Strike" },
        { "Fel Barrage" },
        { "Demon's Bite" },

      }, { "!player.channeling", "target.range <= 5" }},

      { "Throw Glaive" },
    }, "@NOC.isValidTarget('target')" },
  }, "!player.channeling" },
}

ProbablyEngine.rotation.register_custom(577, "|cFF32ff84NOC Havoc Demonk Hunter|r", combat, ooc, onLoad)
