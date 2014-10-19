-- ProbablyEngine Rotation Packager
-- NO CARRIER's Windwalker Monk Rotation
ProbablyEngine.rotation.register_custom(269, "|cFF32ff84NOC Windwalker Monk 6.0|r", {
-- Combat

-- Pause
{ "pause", "modifier.lshift" },

 -- AutoTarget
{ "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
{ "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } },

-- Keyboard modifiers
{ "Leg Sweep", "modifier.lcontrol" },              -- Leg Sweep
{ "Touch of Karma", "modifier.lalt" },              -- Touch of Karma

-- SEF on mouseover
{{
  { "Storm, Earth, and Fire", { "@NOC.SEF()" }, "mouseover" },
  --{ "/cancelaura Storm, Earth, and Fire", { "@NOC.cancelSEF" }}
}, "toggle.autosef" },

-- Interrupts
{{
  { "Paralysis", { -- Paralysis when SHS, and Quaking Palm are all on CD
     "!target.debuff(Spear Hand Strike)",
     "player.spell(Spear Hand Strike).cooldown > 0",
     "player.spell(Quaking Palm).cooldown > 0",
     "!modifier.last(Spear Hand Strike)"
  }},
  { "Ring of Peace", { -- Ring of Peace when SHS is on CD
     "!target.debuff(Spear Hand Strike)",
     "player.spell(Spear Hand Strike).cooldown > 0",
     "!modifier.last(Spear Hand Strike)"
  }},
  { "Leg Sweep", { -- Leg Sweep when SHS is on CD
     "player.spell(116705).cooldown > 0",
     "target.range <= 5",
     "!modifier.last(116705)"
  }},
  { "Charging Ox Wave", { -- Charging Ox Wave when SHS is on CD
     "player.spell(116705).cooldown > 0",
     "target.range <= 30",
     "!modifier.last(116705)"
  }},
  { "Quaking Palm", { -- Quaking Palm when SHS is on CD
     "!target.debuff(Spear Hand Strike)",
     "player.spell(Spear Hand Strike).cooldown > 0",
     "!modifier.last(Spear Hand Strike)"
  }},
  { "Spear Hand Strike" }, -- Spear Hand Strike
}, "target.interruptAt(30)" }, -- Interrupt when 30% into the cast time

-- Queued Spells
{ "!122470", "@NOC.checkQueue(122470)" }, -- Touch of Karma
{ "!116845", "@NOC.checkQueue(Ring of Peace)" }, -- Ring of Peace
{ "!119392", "@NOC.checkQueue(119392)" }, -- Charging Ox Wave
{ "!119381", "@NOC.checkQueue(119381)" }, -- Leg Sweep
{ "!Tiger's Lust", "@NOC.checkQueue(Tiger's Lust)" }, -- Tiger's Lust
{ "!Dampen Harm", "@NOC.checkQueue(Dampen Harm)" }, -- Dampen Harm
{ "!Diffuse Magic", "@NOC.checkQueue(Diffuse Magic)" }, -- Diffuse Magic
--{ "!115460", "@NOC.checkQueue(115460)", "ground" }, -- Healing Sphere

-- Survival
{ "Expel Harm", { "player.health <= 80", "player.chi < 4" }},
{ "Chi Wave", "player.health <= 75" },

{ "Fortifying Brew", { -- Forifying Brew at < 30% health and when DM & DH buff is not up
  "player.health < 30",
  "!player.buff(Diffuse Magic)", --DM
  "!player.buff(Dampen Harm)" --DH
}},
{ "#5512", "player.health < 40" }, -- Healthstone

{ "Detox", "player.dispellable(Detox)", "player" }, -- Detox yourself if you can be dispelled

{ "Nimble Brew", "player.state.disorient" }, -- Nimble Brew = Nimble Brew
{ "Nimble Brew", "player.state.fear" },
{ "Nimble Brew", "player.state.stun" },
{ "Nimble Brew", "player.state.root" },
{ "Nimble Brew", "player.state.horror" },
{ "Nimble Brew", "player.state.snare" },

{ "Tiger's Lust", "player.state.disorient" }, -- Tiger's Lust = Tiger's Lust
{ "Tiger's Lust", "player.state.stun" },
{ "Tiger's Lust", "player.state.root" },
{ "Tiger's Lust", "player.state.snare" },

-- Shared
{ "Chi Sphere", { "player.spell(Power Strikes).exists", "player.buff(Chi Sphere)", "player.chi < 4" }},
{{
   -- Cooldowns/Racials
   { "Lifeblood" },
   { "Berserking" },
   { "Blood Fury" },
   { "Bear Hug" },
   { "Invoke Xuen, the White Tiger" },
}, "modifier.cooldowns" },

-- Melee range only
{{
  { "Touch of Death", "player.buff(Death Note)" },

  {{
    { "Chi Brew", { "!modifier.last(Chi Brew)", "player.spell(Chi Brew).charges = 2" }},
    --{ "Chi Brew", "target.ttd < 10" },
    { "Chi Brew", { "player.spell(Chi Brew).charges = 1", "player.spell(Chi Brew).recharge <= 10", "!modifier.last(Chi Brew)" }},
  }, {"player.chi <= 2", "player.buff(Tigereye Brew).count <= 16" }},

  -- Tiger Palm
  { "Tiger Palm", "player.buff(Tiger Power).duration <= 3" },
  -- Tigereye Brew
  {{
    { "116740", "player.buff(125195).count = 20" },
    {{
      { "116740", { "player.chi >= 3", "player.buff(125195).count >= 10", "player.spell(Fists of Fury).cooldown < 1" }},
        {{
          { "116740", { "player.buff(125195).count >= 16" }},
          --{ "116740", { "target.ttd < 40" }},
        },{ "player.chi >= 2" }},
    },{ "target.debuff(130320)", "player.buff(125359)" }},
  },{ "!player.buff(116740)", "!modifier.last(116740)" }},
  -- TODO: Implement TeB with Hurricane Strike & Serenity

  { "Rising Sun Kick", "!target.debuff(Rising Sun Kick)" },
  { "Rising Sun Kick", "target.debuff(Rising Sun Kick).duration < 3" },

  { "Tiger Palm", { "!player.buff(Tiger Power)", "target.debuff(Rising Sun Kick).duration > 1", "player.timetomax > 1" }},
  -- TODO: Implement Serenity

  -- AoE
  {{
    -- TODO: Implement Chi Explosion

    { "Rushing Jade Wind" }, -- Rushing Jade Wind

    { "Rising Sun Kick", { "player.chi = 4", "!player.spell(Ascension).exists" }}, -- Rising Sun Kick
    { "Rising Sun Kick", { "player.chi = 5", "player.spell(Ascension).exists" }}, -- Rising Sun Kick

    { "Fists of Fury", {
       "!player.moving",
       "player.spell(Rushing Jade Wind).exists",
       "player.timetomax > 4",
       "player.buff(Tiger Power).duration > 4",
       "target.debuff(Rising Sun Kick).duration > 4",
       "toggle.fof" }},

    -- TODO: Implement Hurricane Strike
    { "Zen Sphere", { "!player.buff(Zen Sphere)" }, "target" },
    { "Chi Wave", "player.timetomax > 2" }, -- Chi Wave (40yrd range!)
    { "Chi Burst", { "!player.moving", "player.timetomax > 2" }}, -- Chi Burst (40yrd range!)

    { "Blackout Kick", { "player.spell(Rushing Jade Wind).exists", "player.buff(Combo Breaker: Blackout Kick)" }},

    { "Tiger Palm", { "player.spell(Rushing Jade Wind).exists", "player.buff(Combo Breaker: Tiger Palm)", "player.buff(Combo Breaker: Tiger Palm).duration <= 2" }},

    { "Blackout Kick", { "player.spell(Rushing Jade Wind).exists", "player.chi <= 2" }},

    { "Spinning Crane Kick", "!player.spell(Rushing Jade Wind).exists" }, -- Spinning Crane Kick

    { "Jab", { "player.spell(Rushing Jade Wind).exists", "player.chi <= 2" }},
  },
  -- Even is AOE is enabled, don't use unless there are at least 3 enemies
  -- TODO: Need to be able to re-implement "modifier.enemies > 2" when CombatTracking is back...
  { "toggle.multitarget" }},

  -- Single

-- Fists of Fury
  { "Fists of Fury", {
     "!player.moving",
     "target.debuff(Rising Sun Kick).duration > 4",
     "toggle.fof" }},

  -- TODO: Implement Hurricane Strike

  { "Energizing Brew", { "player.spell(Fists of Fury).cooldown > 6", "player.timetomax > 5" }},

  { "Rising Sun Kick" }, -- Rising Sun Kick

  {{
    { "Chi Wave" }, -- Chi Wave (40 yard range!)
    { "Zen Sphere", { "!player.buff(Zen Sphere)" }, "target" },
    { "Chi Burst", "!player.moving" }, -- Chi Burst (40 yard range!)
  }, "player.timetomax > 2" },

  { "Blackout Kick", "player.buff(Combo Breaker: Blackout Kick)" }, -- Blackout Kick

  -- TODO: Implement Chi Explosion

  { "Tiger Palm", { "player.buff(125359)", "player.buff(125359).duration <= 2" }},
  { "Tiger Palm",  "player.buff(Combo Breaker: Tiger Palm)" },

  { "Blackout Kick", { "player.chi <= 2" , "player.spell(Fists of Fury).cooldown > 2" , "!player.moving"}},
  { "Blackout Kick", { "player.chi <= 2" , "player.moving"}},
  { "Blackout Kick", { "player.chi <= 2" , "!toggle.fof" }},

  -- TODO: Implement Chi Explosion

  { "Jab", { "player.chi <= 2", "!player.spell(Ascension).exists" }},
  { "Jab", { "player.chi <= 3", "player.spell(Ascension).exists" }},


  }, { "target.exists", "target.alive", "player.alive", "target.range <= 5", "!player.casting" }},


-- Ranged

{{
  -- Tiger's Lust if the target is at least 15 yards away and we are moving
  { "Tiger's Lust", { "target.range >= 15", "player.moving" }},

  { "Zen Sphere", "!target.debuff(Zen Sphere)" }, -- 40 yard range!
  { "Chi Wave" }, -- Chi Wave (40yrd range!)
  { "Chi Burst" }, -- Chi Burst (40yrd range!)

  -- Crackling Jade Lightning
  { "Crackling Jade Lightning", { "target.range > 5", "target.range <= 40", "!player.moving" }},

  { "Expel Harm", "player.chi < 4" } -- Expel Harm
}},
-- TODO: re-add this check when I can figure out why it stopped working
--}, "@NOC.immuneEvents" },

},{
-- Out of Combat
-- Buffs
{ "Legacy of the White Tiger", { -- Legacy of the White Tiger
  "!player.buff(Legacy of the White Tiger).any",
  "!player.buff(17007).any",
  "!player.buff(1459).any",
  "!player.buff(61316).any",
  "!player.buff(24604).any",
  "!player.buff(90309).any",
  "!player.buff(126373).any",
  "!player.buff(126309).any"
}},
{ "Expel Harm", "player.health < 100" }, -- Expel Harm when not at full health
{ "Expel Harm", "toggle.chistacker" }, -- Expel Harm
}, function()
ProbablyEngine.toggle.create('chistacker', 'Interface\\Icons\\ability_monk_expelharm', 'Stack Chi', 'Keep Chi at full even OoC...')
ProbablyEngine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automatically target the nearest enemy when target dies or does not exist')
ProbablyEngine.toggle.create('fof', 'Interface\\Icons\\monk_ability_fistoffury', 'Fists of Fury', 'Enable use of Fists of Fury')
ProbablyEngine.toggle.create('autosef', 'Interface\\Icons\\spell_sandstorm', 'Auto SEF', 'Automatically cast SEF on mouseover targets')
end)
