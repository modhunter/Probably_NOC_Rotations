-- ProbablyEngine Rotation Packager
-- NO CARRIER's Marksman Hunter Rotation
ProbablyEngine.rotation.register_custom(254, "NOC Marksman Hunter 6.0",
{
  -- Combat
  { "pause", "modifier.lshift" },
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
  { "147362", "target.interruptAt(30)" }, -- Counter Shot at 30% cast time left

  -- Survival
  { "109304", "player.health < 50" }, -- Exhiliration
  { "19263", "player.health < 10" }, -- Deterrence as a last resort
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

  -- Cooldowns
  {{
    { "Stampede", "player.buff(Rapid Fire)" },
    { "Lifeblood" },
    { "Berserking" },
    { "Blood Fury" },
    { "Bear Hug" },
    -- { "53401" }, -- Rabid
  }, "modifier.cooldowns" },

  { "Tranquilizing Shot", { "target.dispellable(Tranquilizing Shot)", "!target.charmed", "!target.state.charm", "!target.debuff(Touch of Y'Shaarj)", "!target.debuff(Empowered Touch of Y'Shaarj)", "!target.buff(Touch of Y'Shaarj)", "!target.buff(Empowered Touch of Y'Shaarj)" }, "target" },

  -- Shared
  --actions+=/kill_shot,if=cast_regen+action.aimed_shot.cast_regen<focus.deficit
  { "Kill Shot", "player.timetomax > 3" },

  { "Chimaera Shot" },
  { "Rapid Fire" },

  -- Careful Aim
  {{
    -- AOE
    {{
      { "Glaive Toss" },
      { "Powershot", "player.timetomax > 2.5" },
      { "Barrage" },
    }, { "modifier.multitarget" },},
    -- "modifier.enemies >= 3"

    -- ST
    {{
      { "Aimed Shot" },
      { "Focusing Shot", "player.timetomax > 4" },
      { "Steady Shot" },
    }, { "!modifier.multitarget" },},

  }, { "player.buff(Careful Aim)" },},

  { "A Murder of Crows" },
  { "Dire Beast", "player.timetomax > 3" },
  { "Glaive Toss" },
  { "Powershot", "player.timetomax > 2.5" },
  { "Barrage" }, -- Do we really want this in ST? May want to put on a toggle

-- TODO: Need to figure out how to implement this:
--# Pool max focus for rapid fire so we can spam AimedShot with Careful Aim buff
--actions+=/steady_shot,if=focus.deficit*cast_time%(14+cast_regen)>cooldown.rapid_fire.remains
--actions+=/focusing_shot,if=focus.deficit*cast_time%(50+cast_regen)>cooldown.rapid_fire.remains&focus<100
  { "Steady Shot", "player.timetomax > player.spell(Rapid Fire).cooldown" },
  { "Focusing Shot", { "player.focus < 50" }},
  { "Steady Shot", { "player.buff(Steady Focus)", "player.timetomax > 5" }},
  { "Aimed Shot", "player.spell(Focusing Shot).exists" },
  { "Aimed Shot", "player.focus > 80" },
  { "Aimed Shot", { "player.buff(34720)", "player.focus > 60" }},
  { "Focusing Shot", "player.focus < 50" },
  { "Steady Shot" },
},
{
  -- Out of combat
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
}, function()
ProbablyEngine.toggle.create('aspect', 'Interface\\Icons\\ability_mount_jungletiger', 'Auto Aspect', 'Automatically switch aspect when moving and not in combat')
ProbablyEngine.toggle.create('md', 'Interface\\Icons\\ability_hunter_misdirection', 'Auto Misdirect', 'Automatially Misdirect when necessary')
ProbablyEngine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automatically target the nearest enemy when target dies or does not exist')
end)
