-- ProbablyEngine Rotation Packager
-- NO CARRIER's Beastmaster Hunter Rotation

local onLoad = function()
  ProbablyEngine.toggle.create('aspect', 'Interface\\Icons\\ability_mount_jungletiger', 'Auto Aspect', 'Automatically switch aspect when moving and not in combat')
  ProbablyEngine.toggle.create('md', 'Interface\\Icons\\ability_hunter_misdirection', 'Auto Misdirect', 'Automatially Misdirect when necessary')
  ProbablyEngine.toggle.create('dpstest', 'Interface\\Icons\\inv_misc_pocketwatch_01', 'DPS Test', 'Stop combat after 5 minutes in order to do a controlled DPS test')
  ProbablyEngine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automatically target the nearest enemy when target dies or does not exist')

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

  { "982", "pet.dead" }, -- Revive Pet
  { "136", { "pet.health <= 90", "pet.exists", "!pet.dead", "!pet.buff(136)" }}, -- Mend Pet

  { "Aspect of the Cheetah", { "!player.buff(Aspect of the Cheetah)", "toggle.aspect" }},

  -- Keep trap launcher set
  { "77769", "!player.buff(77769)" },

  { "82939", "modifier.lalt", "ground" }, -- Explosive Trap
  { "82941", "modifier.lalt", "ground" }, -- Ice Trap
}

local aoe = {
  { "Multi-Shot", { "!pet.buff(Beast Cleave)", "!lastcast(Cobra Shot)" }},
  { "Barrage", "!lastcast(Cobra Shot)" },
  --{ "Multi-Shot", "modifier.enemies >= 6" },
  --{ "Cobra Shot" },
}

local focusfire = {
	{{
		{ "Focus Fire", {
			"player.buff(Frenzy).count = 5",
			"!player.spell(Bestial Wrath).cooldown >= 10",
			"!player.spell(Bestial Wrath).cooldown <= 19",
		}, },
		{ "Focus Fire", {
			"player.buff(Frenzy).count >= 1",
			"player.buff(Bestial Wrath).duration >= 3",
		}, },
		{ "Focus Fire", {
			"player.buff(Frenzy).count >= 1",
			"player.buff(Frenzy).duration <= 1",
		}, },
		{ "Focus Fire", {
			"player.buff(Frenzy).count >= 1",
			"player.buff(Stampede).cooldown >= 260",
		}, },
		{ "Focus Fire", {
			"player.buff(Frenzy).count >= 1",
			"player.buff(Bestial Wrath).cooldown < 1 ",
      "!player.buff(Bestial Wrath)",
		}, },
	}, { "pet.exists", "!player.buff(Focus Fire)", "!lastcast(Cobra Shot)", }, },
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
  --{ "883", { "!pet.dead", "!pet.exists" }}, -- Call Pet 1
  { "55709", { "player.alive", "pet.dead", "!player.debuff(55711)" }}, -- Heart of the Phoenix (55709)
  { "982", { "pet.dead", "player.alive", }}, -- Revive Pet

  { "82939", "modifier.lalt", "ground" }, -- Explosive Trap
  { "82941", "modifier.lalt", "ground" }, -- Ice Trap

  { "109248" , "modifier.lcontrol", "ground" }, -- Binding Shot

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
  { "136", { "pet.health <= 75", "pet.exists", "!pet.dead", "!pet.buff(136)" }, "pet", }, -- Mend Pet

  -- Misdirect to focus target or pet when threat is above a certain threshhold
  {{
   { "34477", { "focus.exists", "!player.buff(35079)", "target.threat > 60" }, "focus" },
   { "34477", { "pet.exists", "!pet.dead", "!player.buff(35079)", "!focus.exists", "target.threat > 85" }, "pet" },
  }, "toggle.md", },

  -- Master's Call when stuck
  {{
    { "53271", "player.state.stun" },
    { "53271", "player.state.root" },
    { "53271", { "player.state.snare", "!player.debuff(Dazed)" }},
    { "53271", "player.state.disorient" },
  }, { "pet.exists" }},

  -- Wrap the entire block in an 'immuneEvents' check
  {{
    -- Cooldowns
    {{
      { "Stampede", "player.proc.any" },
      { "Stampede", "player.hashero" },
      { "Stampede", "player.buff(Frenzy).count >= 4", },
      --{ "A Murder of Crows" },
      { "Lifeblood" },
      { "Berserking" },
      { "Blood Fury" },
      { "#trinket1" },
      { "#trinket2" },
    }, "modifier.cooldowns" },

    { "Tranquilizing Shot", { "target.dispellable(Tranquilizing Shot)", "!target.cc" }, "target" },

    -- Shared
    { focusfire, },
    {{
      { "Cobra Shot", { "!player.buff(Steady Focus)", "talent(4,1)" }},
      { "Cobra Shot", { "player.focus < 35", "!talent(4,1)" }},
      { "Bestial Wrath", { "player.buff(Steady Focus)", "talent(4,1)" }},
      { "Bestial Wrath", "!talent(4,1)" },
    }, { "player.spell(Bestial Wrath).cooldown < 1", "!player.buff(Bestial Wrath)", "!lastcast(Cobra Shot)" }},

    { "Dire Beast", "!lastcast(Cobra Shot)" },

    -- AoE
    { aoe, { "toggle.multitarget", "modifier.enemies >= 2" }},

    { "Kill Command", "!lastcast(Cobra Shot)" },
    --{ "A Murder of Crows", "target.health.actual < 200000" },
    { "!Kill Shot", { "!player.channeling", "player.spell(Kill Shot).cooldown < 0.5", "!lastcast(Cobra Shot)" }},
    { "!Kill Shot", { "!player.channeling", "!lastcast(Cobra Shot)" }},
    { "Barrage", "!lastcast(Cobra Shot)" },
    --{ "Powershot", "player.timetomax > 2.5" },
    { "Cobra Shot", { "!player.buff(Bestial Wrath)", "lastcast(Cobra Shot)", "player.buff(Steady Focus).duration < 4", "talent(4,1)" }},
    { "Cobra Shot", { "!player.buff(Bestial Wrath)", "player.buff(Steady Focus).duration < 5", "talent(4,1)", "player.focus < 60" }},
    { "Arcane Shot", "player.focus >= 70" },
    { "Cobra Shot" },
  }, "@NOC.isValidTarget('target')" },
}

ProbablyEngine.rotation.register_custom(253, "NOC Beastmaster Hunter", combat, ooc, onLoad)
