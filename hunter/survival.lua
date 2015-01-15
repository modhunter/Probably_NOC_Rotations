-- ProbablyEngine Rotation Packager
-- NO CARRIER's Survival Hunter Rotation

local onLoad = function()
ProbablyEngine.toggle.create('aspect', 'Interface\\Icons\\ability_mount_jungletiger', 'Auto Aspect', 'Automatically switch aspect when moving and not in combat')
ProbablyEngine.toggle.create('md', 'Interface\\Icons\\ability_hunter_misdirection', 'Auto Misdirect', 'Automatially Misdirect when necessary')
ProbablyEngine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automatically target the nearest enemy when target dies or does not exist')
ProbablyEngine.toggle.create('autoAS', 'Interface\\Icons\\ability_hunter_quickshot', 'Mouseover Arcane Shot', 'Automatically apply Arcane Shot to mouseover units while in combat')
end

local ooc = {
  -- Out of combat
  { "pause", "modifier.lshift" },
  { "pause","player.buff(5384)" }, -- Pause for Feign Death
  { "136", { "pet.health <= 90", "pet.exists", "!pet.dead", "!pet.buff(136)", "!talent(7,3)" }}, -- Mend Pet
  {{
    { "Aspect of the Cheetah", { "player.moving", "!player.buff(Aspect of the Cheetah)" }}, -- Cheetah
    { "/cancelaura Aspect of the Cheetah", "!player.moving" },
  }, "toggle.aspect" },
  { "82939", "modifier.lalt", "ground" }, -- Explosive Trap
  { "82948", "modifier.lalt", "ground" }, -- Snake Trap
  { "82941", "modifier.lalt", "ground" }, -- Ice Trap
}

local aoe = {
  -- Explosive shot if LnL is up and Barrage is not ready
  { "Explosive Shot", { "player.buff(56453)", "player.spell(Barrage).cooldown > 0" }},
  { "Barrage" },
  { "Explosive Shot" },
  { "Black Arrow", "!target.debuff(3674)" },
  { "A Murder of Crows" },
  { "Dire Beast" },

--/multishot,if=buff.thrill_of_the_hunt.react&focus>50&cast_regen<=focus.deficit|dot.serpent_sting.remains<=5|target.time_to_die<4.5
  { "Multi-Shot", { "player.buff(34720)", "player.focus > 50" }},
  --{ "Multi-Shot", "target.ttd < 4.5" },
  { "Multi-Shot", "target.debuff(Serpent Sting).duration <= 5" },
  { "Glaive Toss" },
  { "Powershot" },
  { "Cobra Shot", { "player.buff(Steady Focus).duration < 5", "player.focus < 45" }},
  { "2643", { "player.focus >= 70", "player.spell(Focusing Shot).exists" }}, -- Multi-Shot
  { "Focusing Shot", { "player.focus < 45", "!player.moving", "player.lastmoved > 1" }},
  { "Cobra Shot" },
}

local combat = {
  -- Combat
  { "pause", "modifier.lshift" },
  { "pause", "@NOC.pause()"},
  { "pause","player.buff(5384)" }, -- Pause for Feign Death

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
  { "82948", "modifier.lalt", "ground" }, -- Snake Trap
  { "82941", "modifier.lalt", "ground" }, -- Ice Trap

  { "109248" , "modifier.lcontrol", "ground" }, -- Binding Shot

  -- Arcane Shot on mouseover when they don't have the debuff already and the toggle is enabled
  { "Arcane Shot", { "!mouseover.debuff(Serpent Sting)", "toggle.autoAS", "!mouseover.charmed", "!mouseover.state.charm", "!mouseover.debuff(Touch of Y'Shaarj)", "!mouseover.debuff(Empowered Touch of Y'Shaarj)", "!mouseover.buff(Touch of Y'Shaarj)", "!mouseover.buff(Empowered Touch of Y'Shaarj)" }, "mouseover" },

  -- Interrupt(s)
  { "147362", "target.interruptAt(30)" }, -- Counter Shot at 30% cast time left

  -- Survival
  { "109304", "player.health < 50" }, -- Exhiliration
  { "Deterrence", "player.health < 10" }, -- Deterrence as a last resort
  { "#109223", "player.health < 40" }, -- Healing Tonic
  { "#5512", "player.health < 40" }, -- Healthstone

  -- This is still broken if the potion is on cooldown
  { "#76097", "player.health < 40" }, -- Master Healing Potion
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
    { "53271", "player.state.snare" },
  }, "!talent(7,3)" },

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

    -- AoE
    { aoe, { "toggle.multitarget", "modifier.enemies >= 3" }},

    { "Explosive Shot" },
    { "Black Arrow", "!target.debuff(3674)" },
    { "A Murder of Crows" },
    { "Dire Beast" },
    --actions+=/arcane_shot,if=buff.thrill_of_the_hunt.react&focus>35&cast_regen<=focus.deficit|dot.serpent_sting.remains<=5|target.time_to_die<4.5
    -- Arcane Shot if ToTH buff is up and focus > 35 and ("cast_regen<=focus.deficit"??? or serpent sting dot will be up <= 5s or ttd < 4.5s)
    { "Arcane Shot", { "player.buff(34720)", "player.focus > 35" }},
    --{ "Arcane Shot", "target.ttd < 4.5" },
    { "Arcane Shot", "target.debuff(Serpent Sting).duration <= 5" },
    { "Glaive Toss" },
    { "Powershot" },
    { "Barrage" }, -- Do we really want this in ST? May want to put on a toggle
    { "Cobra Shot", { "player.buff(Steady Focus).duration < 5", "player.focus < 45" }},
    { "Arcane Shot", { "player.focus >= 70", "player.spell(Focusing Shot).exists" }},
    { "Focusing Shot", { "player.focus < 45", "!player.moving", "player.lastmoved > 1" }},
    { "Cobra Shot" },
  }, "@NOC.immuneEvents('target')" },
}

ProbablyEngine.rotation.register_custom(255, "NOC Survival Hunter 6.0", combat, ooc, onLoad)
