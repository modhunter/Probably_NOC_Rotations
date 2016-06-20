-- ProbablyEngine Rotation Packager
-- NO CARRIER's Vengeance Demon Hunter Rotation

local onLoad = function()
  ProbablyEngine.toggle.create('sint', 'Interface\\Icons\\ability_monk_spearhand', 'Sudden Interrupt', 'Stop spellcasting in order to use an interrupt')
  ProbablyEngine.toggle.create('def', 'Interface\\Icons\\INV_SummerFest_Symbol_Medium.png', 'Defensive CDs Toggle', 'Enable or Disable usage of ??? Defensive Cooldowns')

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
  	{{
  		{ "Blur", { "player.health <= 70" }},
  		{ "Soul Cleave", { "player.health <= 75" }, "player" },
  	}, "toggle.def" },

    { "#109223", "player.health < 40" }, -- Healing Tonic
    { "#5512", "player.health < 40" }, -- Healthstone

    -- wrapper for "@NOC.isValidTarget" which prevents the following from occuring when the target is CCed or otherwise not allowed to be attacked
    {{
      {{
         -- Cooldowns/Racials
         { "Lifeblood" },
         { "Berserking" },
         { "Blood Fury" },
      }, "modifier.cooldowns" },

      -- Melee range only
      {{
        { "Fiery Brand" },
        { "Demon Spikes" },
        { "Empower Wards" },
        { "Immolation Aura" },
        { "Fracture", "player.pain >= 80" },
        { "Soul Cleave", "player.pain >= 80" },
        { "Felblade" },
        { "Sigil of Flame" },
        { "Fel Erruption" },
        { "Spirit Bomb", "!target.debuff(Frail)" },
        { "Fel Devastation" },
        { "Soul Carver" },
        { "Shear" },
      }, { "!player.channeling", "target.range <= 5" }},

    }, "@NOC.isValidTarget('target')" },
  }, "!player.channeling" },
}

ProbablyEngine.rotation.register_custom(581, "|cFF32ff84NOC Vengeance Demonk Hunter|r", combat, ooc, onLoad)
