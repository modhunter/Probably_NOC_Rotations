-- ProbablyEngine Rotation Packager
-- NO CARRIER's Beastmaster Hunter Rotation

local onLoad = function()
ProbablyEngine.toggle.create('aspect', 'Interface\\Icons\\ability_mount_jungletiger', 'Auto Aspect', 'Automatically switch aspect when moving and not in combat')
ProbablyEngine.toggle.create('md', 'Interface\\Icons\\ability_hunter_misdirection', 'Auto Misdirect', 'Automatially Misdirect when necessary')
ProbablyEngine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automatically target the nearest enemy when target dies or does not exist')
end

local ooc = {
  { "pause", "modifier.lshift" },
  { "pause","player.buff(5384)" }, -- Pause for Feign Death
  { "136", { "pet.health <= 90", "pet.exists", "!pet.dead", "!pet.buff(136)" }}, -- Mend Pet
  {{
    { "Aspect of the Cheetah", { "player.moving", "!player.buff(Aspect of the Cheetah)" }}, -- Cheetah
    { "/cancelaura Aspect of the Cheetah", "!player.moving" },
  }, "toggle.aspect" },
  { "82939", "modifier.lalt", "ground" }, -- Explosive Trap
  { "82948", "modifier.lalt", "ground" }, -- Snake Trap
  { "82941", "modifier.lalt", "ground" }, -- Ice Trap
}

local aoe = {
  { "Barrage" },
  { "Multi-Shot", "!player.buff(Beast Cleave)" },
  { "Cobra Shot" },
}

local combat = {
  { "pause", "modifier.lshift" },
  { "pause", "@NOC.pause()"},
  { "pause","player.buff(5384)" }, -- Pause for Feign Death

  -- AutoTarget
  { "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" }},
  { "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" }},

  -- Pet
  { "883", { "!pet.dead", "!pet.exists" }}, -- Call Pet 1
  { "55709", "pet.dead" }, -- Heart of the Phoenix (55709)
  { "982", "pet.dead" }, -- Revive Pet

  { "82939", "modifier.lalt", "ground" }, -- Explosive Trap
  { "82948", "modifier.lalt", "ground" }, -- Snake Trap
  { "82941", "modifier.lalt", "ground" }, -- Ice Trap

  { "109248" , "modifier.lcontrol", "ground" }, -- Binding Shot

  -- Interrupt(s)
  { "147362", "target.interruptAt(30)" }, -- Counter Shot at 70% cast time left

  -- Survival
  { "109304", "player.health < 50" }, -- Exhiliration
  { "Deterrence", "player.health < 10" }, -- Deterrence as a last resort
  { "#109223", "player.health < 40" }, -- Healing Tonic
  { "#5512", "player.health < 40" }, -- Healthstone
  -- This is still broken if the potion is on cooldown
  { "#76097", "player.health < 40" }, -- Master Healing Potion
  { "136", { "pet.health <= 75", "pet.exists", "!pet.dead", "!pet.buff(136)" }}, -- Mend Pet

  -- Misdirect to focus target or pet when threat is above a certain threshhold
  {{
   { "34477", { "focus.exists", "!player.buff(35079)", "target.threat > 60" }, "focus" },
   { "34477", { "pet.exists", "!pet.dead", "!player.buff(35079)", "!focus.exists", "target.threat > 85" }, "pet" },
  }, "toggle.md", },

  -- Master's Call when stuck
  { "53271", "player.state.stun" },
  { "53271", "player.state.root" },
  { "53271", "player.state.snare" },

  -- Wrap the entire block in an 'immuneEvents' check
  {{
    -- Cooldowns
    {{
      { "Stampede" },
      { "Lifeblood" },
      { "Berserking" },
      { "Blood Fury" },
      { "Bear Hug" },
      -- { "53401" }, -- Rabid
      { "#trinket1" },
      { "#trinket2" },
    }, "modifier.cooldowns" },

    { "Tranquilizing Shot", { "target.dispellable(Tranquilizing Shot)", "!target.charmed", "!target.state.charm", "!target.debuff(Touch of Y'Shaarj)", "!target.debuff(Empowered Touch of Y'Shaarj)", "!target.buff(Touch of Y'Shaarj)", "!target.buff(Empowered Touch of Y'Shaarj)" }, "target" },

    -- Shared
    { "Dire Beast" },
    { "Bestial Wrath", { "player.focus > 60", "!player.buff(Bestial Wrath)" }},

    -- AoE
    { aoe, { "toggle.multitarget", "modifier.enemies >= 3" }},

    -- Single Target
    { "A Murder of Crows" },
    { "Kill Shot" },
    { "Kill Command" },
    { "Focusing Shot", { "player.focus < 50", "!player.moving", "player.lastmoved > 1" }},
    { "Cobra Shot", { "player.buff(Steady Focus).duration < 5", "player.focus < 50" }},
    { "Glaive Toss" },
    { "Barrage" }, -- Do we really want this in ST? May want to put on a toggle
    { "Powershot", "player.timetomax > 2.5" },
    { "Arcane Shot", { "player.buff(Thrill of the Hunt)", "player.focus > 35" }},
    { "Arcane Shot", "player.buff(Bestial Wrath)" },
    { "Focus Fire", "player.buff(Frenzy).count = 5" },
    { "Arcane Shot", "player.focus >= 64" },
    { "Cobra Shot" },
  }, "@NOC.immuneEvents('target')" },
}

ProbablyEngine.rotation.register_custom(253, "NOC Beastmaster Hunter 6.0", combat, ooc, onLoad)
