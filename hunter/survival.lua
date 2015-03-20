-- ProbablyEngine Rotation Packager
-- NO CARRIER's Survival Hunter Rotation
local function dynamicEval(condition, spell)
  if not condition then return false end
  return ProbablyEngine.dsl.parse(condition, spell or '')
end

local onLoad = function()
  ProbablyEngine.toggle.create('aspect', 'Interface\\Icons\\ability_mount_jungletiger', 'Auto Aspect', 'Automatically switch aspect when moving and not in combat')
  ProbablyEngine.toggle.create('md', 'Interface\\Icons\\ability_hunter_misdirection', 'Auto Misdirect', 'Automatially Misdirect when necessary')
  ProbablyEngine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automatically target the nearest enemy when target dies or does not exist')
  ProbablyEngine.toggle.create('dpstest', 'Interface\\Icons\\inv_misc_pocketwatch_01', 'DPS Test', 'Stop combat after 5 minutes in order to do a controlled DPS test')
  ProbablyEngine.toggle.create('autoAS', 'Interface\\Icons\\ability_hunter_quickshot', 'Mouseover Arcane Shot', 'Automatically apply Arcane Shot to mouseover units while in combat')

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
  -- Out of combat
  { "pause","player.buff(5384)" }, -- Pause for Feign Death

  { "2641", { "pet.exists", "talent(7,3)" }}, -- Dismiss Pet
  { "982", { "pet.dead", "!talent(7,3)" }}, -- Revive Pet
  { "136", { "pet.health <= 90", "pet.exists", "!pet.dead", "!pet.buff(136)", "!talent(7,3)" }}, -- Mend Pet

  { "Aspect of the Cheetah", { "!player.buff(Aspect of the Cheetah)", "toggle.aspect" }},

  -- Keep trap launcher set
  { "77769", "!player.buff(77769)" },

  { "82939", "modifier.lalt", "ground" }, -- Explosive Trap
  { "82941", "modifier.lalt", "ground" }, -- Ice Trap
}

local aoe = {
  -- Explosive shot if LnL is up and Barrage is not ready
  { "Explosive Shot", { "player.buff(Lock and Load)", "!talent(6,1)" }},
  { "Explosive Shot", { "player.buff(Lock and Load)", "talent(6,1)", "player.spell(Barrage).cooldown > 1" }},
  { "Barrage", "talent(6,3)" },
  { "Black Arrow", "!target.debuff(3674)" },
  { "Explosive Shot", "modifier.enemies <= 4" },
  { "A Murder of Crows", "target.health.actual < 200000" },
  { "Dire Beast" },

  { "Multi-Shot", { "player.buff(34720)", "player.focus > 50" }},
  { "Multi-Shot", "target.debuff(Serpent Sting).duration <= 5" },

  { "Glaive Toss" },
  { "Powershot" },

  { "Cobra Shot", { "player.buff(Steady Focus).duration < 5", "player.focus < 45" }},
--  { "Cobra Shot", { "player.buff(Steady Focus).duration < 5", "player.focus < 45", function() return ((dynamicEval("player.focus") + 14 + dynamicEval("player.spell(77767).regen")) < 80) end, }},

  { "Multi-Shot", "player.focus >= 70" },
  { "Multi-Shot", "talent(7,2)" },
  { "Focusing Shot", "!player.moving" },
  { "Cobra Shot" },
}

local combat = {
  -- Combat
  { "pause", "modifier.lshift" },
  { "pause","player.buff(5384)" }, -- Pause for Feign Death

  { "/cancelaura Aspect of the Cheetah", { "!player.glyph(Aspect of the Cheetah)", "player.buff(Aspect of the Cheetah)" }},

  { "/stopcasting\n/stopattack\n/cleartarget\n/stopattack\n/cleartarget\n/petpassive", { "player.time >= 300", "toggle.dpstest" }},

  -- AutoTarget
  { "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
  { "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } },

  -- Pet
  {{
    { "883", { "!pet.dead", "!pet.exists" }}, -- Call Pet 1
    { "55709", "pet.dead" }, -- Heart of the Phoenix (55709)
    { "982", "pet.dead" }, -- Revive Pet
  }, "!talent(7,3)" },

  { "82939", "modifier.lalt", "ground" }, -- Explosive Trap
  { "82941", "modifier.lalt", "ground" }, -- Ice Trap

  { "109248" , "modifier.lcontrol", "ground" }, -- Binding Shot

  -- Arcane Shot on mouseover when they don't have the debuff already and the toggle is enabled
  { "Arcane Shot", { "!mouseover.debuff(Serpent Sting)", "toggle.autoAS", "!mouseover.cc", "mouseover.alive", "mouseover.enemy" }, "mouseover" },

  -- Stop flamethrower in Brackenspore
  { "/click ExtraActionButton1", { "player.buff(163322)" }},
  -- Feign Death for Infesting Spores when >= 6
  { "5384", "player.debuff(163242).count >= 6" },
  -- TODO: Add Feign Death for Iron Maiden's mechanic

  -- Interrupt(s)
  { "147362", "target.interruptAt(50)" }, -- Counter Shot at 50% cast time left
  { "19577", "target.interruptAt(30)" }, -- Intimidation at 30% cast time left
  { "19386", "target.interruptAt(30)" }, -- Wyrven Sting at 30% cast time left

  -- Survival
  { "109304", "player.health < 50" }, -- Exhiliration
  { "Deterrence", "player.health < 10" }, -- Deterrence as a last resort
  { "#109223", "player.health < 40" }, -- Healing Tonic
  { "#5512", "player.health < 40" }, -- Healthstone

  { "#109223", "player.health < 40" }, -- Healing Tonic
  { "136", { "pet.health <= 75", "pet.exists", "!pet.dead", "!pet.buff(136)", "!talent(7,3)" }}, -- Mend Pet

  -- Misdirect to focus target or pet when threat is above a certain threshhold
  {{
   { "34477", { "focus.exists", "!player.buff(35079)", "target.threat > 60" }, "focus" },
   { "34477", { "pet.exists", "!pet.dead", "!player.buff(35079)", "!focus.exists", "target.threat > 85", "!talent(7,3)" }, "pet" },
  }, "toggle.md", },

  -- Master's Call when stuck
  {{
    { "53271", "player.state.stun" },
    { "53271", "player.state.root" },
    { "53271", { "player.state.snare", "!player.debuff(Dazed)" }},
    { "53271", "player.state.disorient" },
  }, { "!talent(7,3)", "pet.exists" }},

  -- Wrap the entire block in an 'immuneEvents' check
  {{
    -- Cooldowns
    {{
      { "Stampede", "player.proc.any" },
      { "Stampede", "player.hashero" },
      { "A Murder of Crows" },
      { "Lifeblood" },
      { "Berserking" },
      { "Blood Fury" },
      { "#trinket1" },
      { "#trinket2" },
    }, "modifier.cooldowns" },

    { "Tranquilizing Shot", { "target.dispellable(Tranquilizing Shot)", "!target.cc" }, "target" },

    --{ "Arcane Shot", "!target.debuff(Serpent Sting)" },

    -- AoE
    { aoe, { "toggle.multitarget", "modifier.enemies >= 2" }},

    { "A Murder of Crows", "target.health.actual < 200000" },
    { "Black Arrow", "!target.debuff(3674)" },
    { "Explosive Shot" },
    { "Dire Beast" },

    { "Arcane Shot", { "player.buff(34720)", "player.focus > 25" }},
    --{ "Arcane Shot", { "player.buff(34720)", "player.focus > 35", function() return (dynamicEval("player.spell(3044).regen") <= dynamicEval("player.focus.deficit")) end, }},
    { "Arcane Shot", "target.debuff(Serpent Sting).duration <= 3" },

    --{ "Cobra Shot", {"lastcast(Cobra Shot)", "player.buff(Steady Focus).duration < 7", "player.focus < 60"}},    
    { "Cobra Shot", { "lastcast(Cobra Shot)", "player.buff(Steady Focus).duration < 4" }},
    { "Cobra Shot", { "player.buff(Steady Focus).duration < 5", "player.focus < 60" }},

    { "Arcane Shot", "player.focus >= 80" },
    { "Arcane Shot", "talent(7,2)" },
    { "Focusing Shot", "!player.moving" },
    { "Cobra Shot" },
  }, "@NOC.isValidTarget('target')" },
}

ProbablyEngine.rotation.register_custom(255, "NOC Survival Hunter", combat, ooc, onLoad)
