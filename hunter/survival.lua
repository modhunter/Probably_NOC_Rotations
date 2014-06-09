-- ProbablyEngine Rotation Packager
-- Modified Hunter Rotation for BM/SV
ProbablyEngine.rotation.register_custom(255, "NOC Survival Hunter", 
{
   -- Combat
   { "pause", "modifier.lshift" },
   { "pause","player.buff(5384)" }, -- Pause for Feign Death

   -- AutoTarget
   { "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
   { "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } },

   -- Pet
   { "883", { "!pet.dead", "!pet.exists" }}, -- Call Pet 1
   { "55709", "pet.dead" }, -- Heart of the Phoenix (55709)
   { "982", "pet.dead" }, -- Revive Pet

   { "82939", "modifier.lalt", "ground" }, -- Explosive Trap
   { "82948", "modifier.lalt", "ground" }, -- Snake Trap
   { "82941", "modifier.lalt", "ground" }, -- Ice Trap

   { "109248" , "modifier.lcontrol", "ground" }, -- Binding Shot

   -- Serpent Sting on mouseover when they don't have the debuff already and the toggle is enabled
   { "1978", { "!mouseover.debuff(118253)", "toggle.autoSS", "!mouseover.charmed", "!mouseover.state.charm", "!mouseover.debuff(Touch of Y'Shaarj)", "!mouseover.debuff(Empowered Touch of Y'Shaarj)", "!mouseover.buff(Touch of Y'Shaarj)", "!mouseover.buff(Empowered Touch of Y'Shaarj)" }, "mouseover" },

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
     { "34477", { "focus.exists", "!player.buff(34477)", "target.threat > 60" }, "focus" },
     { "34477", { "pet.exists", "!pet.dead", "!player.buff(34477)", "!focus.exists", "target.threat > 85" }, "pet" },
   }, "toggle.md", },
   -- Mastrer's Call when stuck
   { "53271", "player.state.stun" },
   { "53271", "player.state.root" },
   { "53271", "player.state.snare" },
   { "109260", { "!player.buff(109260)", "!player.moving" }}, -- Iron Hawk
   { "13165", { "!player.spell(109260).exists", "!player.buff(13165)", "!player.moving" }}, -- Hawk

   -- Cooldowns
   {{
      { "121818" }, -- Stampede
      { "131894" }, -- A Murder of Crows
      { "120697" }, -- Lynx Rush
      -- { "53401" }, -- Rabid
   }, "modifier.cooldowns" },

   -- Shared
   { "#gloves" },
   { "53351", "target.health <= 20" }, -- Kill Shot
   { "53301", { "player.buff(56453)", "!target.charmed", "!target.state.charm", "!target.debuff(Touch of Y'Shaarj)", "!target.debuff(Empowered Touch of Y'Shaarj)", "!target.buff(Touch of Y'Shaarj)", "!target.buff(Empowered Touch of Y'Shaarj)" }}, -- Explosive shot if LnL buff is up
   { "3045" }, -- Rapid Fire
   { "120679" }, -- Dire Beast
   { "82726", "player.focus < 50" }, -- Fervor when under 50 focus
   { "19801", { "target.dispellable(19801)", "!target.charmed", "!target.state.charm", "!target.debuff(Touch of Y'Shaarj)", "!target.debuff(Empowered Touch of Y'Shaarj)", "!target.buff(Touch of Y'Shaarj)", "!target.buff(Empowered Touch of Y'Shaarj)" }, "target" }, -- Tranquilizing Shot


   -- AoE
   {{
      { "120360" }, -- Barrage
       { "2643", { "player.buff(34720)", "player.focus >= 40" }}, -- Multi-Shot if ToTH buff is up
       { "2643", "player.focus >= 60" }, -- Multi-Shot
       { "77767", "player.focus < 20" } -- Cobra Shot
   }, { "modifier.multitarget", "modifier.enemies >= 3" }, },

   -- Single
   { "1978", { "!target.debuff(118253)", "!target.charmed", "!target.state.charm", "!target.debuff(Touch of Y'Shaarj)", "!target.debuff(Empowered Touch of Y'Shaarj)", "!target.buff(Touch of Y'Shaarj)", "!target.buff(Empowered Touch of Y'Shaarj)" }}, -- Serpent Sting if SS debuff is not present
   { "3674", { "!target.debuff(3674)", "!target.charmed", "!target.state.charm", "!target.debuff(Touch of Y'Shaarj)", "!target.debuff(Empowered Touch of Y'Shaarj)", "!target.buff(Touch of Y'Shaarj)", "!target.buff(Empowered Touch of Y'Shaarj)"  }}, -- Black Arrow
   { "77767", "target.debuff(118253).duration < 4" }, -- Cobra Shot if SS duration < 4 secs
   { "53301", { "!target.charmed", "!target.state.charm", "!target.debuff(Touch of Y'Shaarj)", "!target.debuff(Empowered Touch of Y'Shaarj)" }}, -- Explosive Shot
   { "117050" }, -- Glaive Toss
   { "109259" }, -- Power Shot
   { "3044", { "player.buff(34720)", "player.focus >= 40" }}, -- AS if ToTH buff is up focus is >= 40
   { "3044", "player.focus >= 60"}, -- Arcane Shot if focus >= 60
   { "77767" } -- Cobra Shot
},
{
  -- Out of combat
   { "pause", "modifier.lshift" },
   { "pause","player.buff(5384)" }, -- Pause for Feign Death
   { "136", { "pet.health <= 90", "pet.exists", "!pet.dead", "!pet.buff(136)" }}, -- Mend Pet
   {{
      { "5118", { "player.moving", "!player.buff(5118)" }}, -- Cheetah
      { "109260", { "!player.buff(109260)", "!player.moving" }}, -- Iron Hawk
      { "13165", { "!player.spell(109260).exists", "!player.buff(13165)", "!player.moving" }}, -- Hawk
   }, "toggle.aspect" },
   { "1130", { "target.exists", "!target.debuff(1130).any", "@NOC.HuntersMark()" }, "target" }, -- Hunters Mark
   { "82939", "modifier.lalt", "ground" }, -- Explosive Trap
   { "82948", "modifier.lalt", "ground" }, -- Snake Trap
   { "82941", "modifier.lalt", "ground" }, -- Ice Trap
}, function()
ProbablyEngine.toggle.create('aspect', 'Interface\\Icons\\ability_mount_jungletiger', 'Auto Aspect', 'Automatically switch aspect when moving and not in combat')
ProbablyEngine.toggle.create('md', 'Interface\\Icons\\ability_hunter_misdirection', 'Auto Misdirect', 'Automatially Misdirect when necessary')
ProbablyEngine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automatically target the nearest enemy when target dies or does not exist')
ProbablyEngine.toggle.create('autoSS', 'Interface\\Icons\\ability_hunter_quickshot', 'Mouseover Serpent Sting', 'Automatically apply Serpent Sting to mouseover units while in combat')
end)
