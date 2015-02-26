-- ProbablyEngine Rotation Packager
-- NO CARRIER's Beastmaster Hunter Rotation

local function dynamicEval(condition, spell)
  if not condition then return false end
  return ProbablyEngine.dsl.parse(condition, spell or '')
end

local onLoad = function()
  ProbablyEngine.toggle.create('aspect', 'Interface\\Icons\\ability_mount_jungletiger', 'Auto Aspect', 'Automatically switch aspect when moving and not in combat')
  ProbablyEngine.toggle.create('md', 'Interface\\Icons\\ability_hunter_misdirection', 'Auto Misdirect', 'Automatially Misdirect when necessary')
  ProbablyEngine.toggle.create('dpstest', 'Interface\\Icons\\inv_misc_pocketwatch_01', 'DPS Test', 'Stop combat after 5 minutes in order to do a controlled DPS test')
  ProbablyEngine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automatically target the nearest enemy when target dies or does not exist')

  BaseStatsInit()

  C_Timer.NewTicker(0.25, (
      function()
        PrimaryStatsTableUpdate()
        SecondaryStatsTableUpdate()
      end),
  nil)
end

local ooc = {
  -- Out of combat
  { "pause","player.buff(5384)" }, -- Pause for Feign Death

  { "982", "pet.dead" }, -- Revive Pet
  { "136", { "pet.health <= 90", "pet.exists", "!pet.dead", "!pet.buff(136)" }}, -- Mend Pet

  {{
    { "Aspect of the Cheetah", { "player.movingfor >= 1", "!player.buff(Aspect of the Cheetah)" }}, -- Cheetah
    { "/cancelaura Aspect of the Cheetah", "player.lastmoved >= 2" },
  }, "toggle.aspect" },

  -- Keep trap launcher set
  { "77769", "!player.buff(77769)" },

  { "82939", "modifier.lalt", "ground" }, -- Explosive Trap
  { "82941", "modifier.lalt", "ground" }, -- Ice Trap
}

local aoe = {
  { "Multi-Shot", "!pet.buff(Beast Cleave)" },
  { "Barrage" },
  { "Multi-Shot", "modifier.enemies >= 6" },
  { "Cobra Shot" },
}

local combat = {
  -- Combat
  { "pause", "modifier.lshift" },
  { "pause","player.buff(5384)" }, -- Pause for Feign Death

  { "/stopcasting\n/stopattack\n/cleartarget\n/stopattack\n/cleartarget\n/petfollow", { "player.time >= 300", "toggle.dpstest" }},

  -- AutoTarget
  { "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
  { "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } },

  -- Pet
  { "883", { "!pet.dead", "!pet.exists" }}, -- Call Pet 1
  { "55709", "pet.dead" }, -- Heart of the Phoenix (55709)
  { "982", "pet.dead" }, -- Revive Pet

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
  { "136", { "pet.health <= 75", "pet.exists", "!pet.dead", "!pet.buff(136)" }}, -- Mend Pet

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
      { "Stampede", "player.agility.proc" },
      { "Stampede", "player.multistrike.proc" },
      { "Stampede", "player.crit.proc" },
      { "Stampede", "player.hashero" },
      { "A Murder of Crows" },
      { "Lifeblood" },
      { "Berserking" },
      { "Blood Fury" },
      { "Bear Hug" },
      -- { "53401" }, -- Rabid
      { "#trinket1" },
      { "#trinket2" },
    }, "modifier.cooldowns" },

    { "Tranquilizing Shot", { "target.dispellable(Tranquilizing Shot)", "!target.cc" }, "target" },

    -- Shared
    { "Dire Beast" },
    {{
      { "Focus Fire", "player.spell(Bestial Wrath).cooldown < 1" },
      { "Focus Fire", "player.buff(Stampede)" },
    }, "!player.buff(Focus Fire)" },
    { "Bestial Wrath", { "player.focus > 30", "!player.buff(Bestial Wrath)" }},

    -- AoE
    { aoe, { "toggle.multitarget", "modifier.enemies >= 2" }},

    { "Focus Fire", "player.buff(Frenzy).count = 5" },
    { "Kill Command" },
    { "A Murder of Crows", "target.health.actual < 200000" },
    { "Kill Shot" },
    { "Focusing Shot", { "player.focus < 50", "!player.moving" }},

    -- { "Cobra Shot", {"lastcast(Cobra Shot)", "player.buff(Steady Focus).duration < 7", "player.focus < 60"}},
    { "Cobra Shot", { "lastcast(Cobra Shot)", "player.buff(Steady Focus).duration < 5", function() return ((14 + dynamicEval("player.spell(Cobra Shot).regen")) <= dynamicEval("player.focus.deficit")) end, }},

    { "Glaive Toss" },
    { "Barrage" }, -- Do we really want this in ST? May want to put on a toggle
    { "Powershot", "player.timetomax > 2.5" },
    { "Dire Beast" },
    { "Arcane Shot", { "player.buff(34720)", "player.focus > 35" }},
    { "Arcane Shot", "player.buff(Bestial Wrath)" },
    { "Arcane Shot", "player.focus > 75" },
    { "Cobra Shot" },
  }, "@NOC.immuneEvents('target')" },
}

ProbablyEngine.rotation.register_custom(253, "NOC Beastmaster Hunter", combat, ooc, onLoad)
