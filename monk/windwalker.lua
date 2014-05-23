-- ProbablyEngine Rotation Packager
-- Custom Windwalker Monk Rotation - modified from rootWind's original WW rotation
-- Forked on Jan 2nd 2014
ProbablyEngine.rotation.register_custom(269, "|cFF32ff84NOC Windwalker Monk|r",
{
  -- Combat

  -- Pause 
  { "pause", "modifier.lshift" },

   -- AutoTarget
   { "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
   { "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } },

  -- Keyboard modifiers
  { "Healing Sphere", "modifier.lcontrol", "ground" },  -- Healing Sphere
  { "Leg Sweep", "modifier.ralt" },              -- Leg Sweep
  { "Touch of Karma", "modifier.lalt" },              -- Touch of Karma

  -- SEF on mouseover
  {{
    { "Storm, Earth, and Fire", { "@NOC.SEF()" }, "mouseover" },
    { "/cancelaura Storm, Earth, and Fire", { "@NOC.cancelSEF" }}
  }, "toggle.autosef" },

  -- Interrupts
  {{
    { "Paralysis", { -- Paralysis when SHS, Ring of Peace, and Quaking Palm are all on CD
       "!target.debuff(Spear Hand Strike)",
       "player.spell(Spear Hand Strike).cooldown > 0",
       "player.spell(Ring of Peace).cooldown > 0",
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
    { "Quaking Palm", { -- Quaking Palm when SHS and Ring of Peace are on CD
       "!target.debuff(Spear Hand Strike)",
       "player.spell(Spear Hand Strike).cooldown > 0",
       "player.spell(Ring of Peace).cooldown > 0",
       "!modifier.last(Spear Hand Strike)"
    }}, 
    { "Spear Hand Strike" }, -- Spear Hand Strike
  }, "target.interruptAt(50)" },

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
  { "Legacy of the Emperor", { -- Legacy of the Emperor
      "!player.buff(117666).any",
      "!player.buff(1126).any",
      "!player.buff(20217).any",
      "!player.buff(90363).any"
  }},
  -- Queued Spells
  { "!122470", "@NOC.checkQueue(122470)" }, -- Touch of Karma
  { "!117368", "@NOC.checkQueue(117368)" }, -- Grapple Weapon
  { "!116845", "@NOC.checkQueue(Ring of Peace)" }, -- Ring of Peace
  { "!119392", "@NOC.checkQueue(119392)" }, -- Charging Ox Wave
  { "!119381", "@NOC.checkQueue(119381)" }, -- Leg Sweep
  { "!Tiger's Lust", "@NOC.checkQueue(Tiger's Lust)" }, -- Tiger's Lust
  { "!Dampen Harm", "@NOC.checkQueue(Dampen Harm)" }, -- Dampen Harm
  { "!Diffuse Magic", "@NOC.checkQueue(Diffuse Magic)" }, -- Diffuse Magic
  { "!115460", "@NOC.checkQueue(115460)", "ground" }, -- Healing Sphere

  -- Survival
  { "Expel Harm", "player.health <= 80" }, -- Expel Harm
  { "Chi Wave", "player.health <= 75" }, -- Chi Wave

  { "Fortifying Brew", { -- Forifying Brew at < 30% health and when DM & DH buff is not up
    "player.health < 30",
    "!player.buff(Diffuse Magic)", --DM
    "!player.buff(Dampen Harm)" --DH
  }}, 
  { "Diffuse Magic", { -- Diffuse Magic at < 50% health and when FB & DH buff is not up
    "player.health < 50",
    "!player.buff(Fortifying Brew)", --FB
    "!player.buff(Dampen Harm)" --DH
  }}, 
  { "Dampen Harm", { -- Dampen Harm at < 50% health and when FB & DM buff is not up
    "player.health < 50",
    "!player.buff(Fortifying Brew)", --FB
    "!player.buff(Diffuse Magic)" --DM
  }}, 
  {{
     { "#5512", "player.health < 40" }, -- Healthstone
     -- This is still broken if the potion is on cooldown
     -- { "#76097", "@NOC.MasterHealingPotion()", "player.health < 40" }, -- Master Healing Potion
  }, "toggle.useItem" },

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
     { "#gloves" },
     --{ "#76089", "player.hashero" }, -- Virmen's Bite whenever we are in heroism/bloodlust
  }, "toggle.useItem" },
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
    { "Touch of Death", "player.buff(Death Note)" }, -- Touch of Death
    { "Grapple Weapon", "target.disarmable" }, -- Grapple Weapon
    -- Ring of Peace when Grapple Weapon debuff is not present, is on CD, and the target is in melee range
    --{ "Ring of Peace", { "!player.buff(123231)", "player.spell(117368).cooldown > 0", "target.range <= 5" }},

    -- Chi Brew
    {{
      --actions+=/chi_brew,if=talent.chi_brew.enabled&chi<=2&(trinket.proc.agility.react|(charges=1&recharge_time<=10)|charges=2|target.time_to_die<charges*10)
      { "Chi Brew", "player.spell(Chi Brew).charges = 2" },
      { "Chi Brew", { "player.spell(Chi Brew).charges = 1", "player.spell(Chi Brew).recharge <= 10", }},
      { "Chi Brew", "target.ttd < 15" },
    }, "player.chi <= 2" },

    -- Tiger Palm
    --actions+=/tiger_palm,if=buff.tiger_power.remains<=3
    { "Tiger Palm", "player.buff(Tiger Power).duration <= 3" },

    -- Tigereye Brew 
    --actions+=/tigereye_brew,if=buff.tigereye_brew_use.down&buff.tigereye_brew.stack=20
    { "Tigereye Brew", { "player.buff(125195).count == 20", "!player.buff(116740)" }},

    {{
      {{
        --actions+=/tigereye_brew,if=buff.tigereye_brew_use.down&trinket.proc.agility.react
        -- TeB whenever a trinket agility proc is up
        -- TODO: Move these to a function for reuse
        --Assurance of Consequence Proc
        { "Tigereye Brew", "player.buff(Dextrous)" },
        --Haromm's Talisman Proc
        { "Tigereye Brew", "player.buff(Item - Proc Agility)" },
        --Heroic Haromm's Talisman Proc
        { "Tigereye Brew", "player.buff(Vicious)" },
        --Ticking Ebon Detonator
        { "Tigereye Brew", "player.buff(Restless Agility)" },
        --Bad Juju
        { "Tigereye Brew", "player.buff(Item - Attacks Proc Agility and Voodoo Gnomes)" }
         -- TODO Synapse Springs Buff???
      }, "player.buff(125195).count >= 10" },
      { "Tigereye Brew", "player.buff(125195).count >= 15" },
      { "Tigereye Brew", "target.ttd < 20" },
      --Tigereye Brew @ 15stacks (prevent capping) with the following conditions: at least 2 chi, at least 15 stacks, TeB buff not already up, tiger power buff will be up at least 2 seconds, and RsK debuff is already on the target
      --actions+=/tigereye_brew,if=buff.tigereye_brew_use.down&chi>=2&(trinket.proc.agility.react|trinket.proc.strength.react|buff.tigereye_brew.stack>=15|target.time_to_die<40)&debuff.rising_sun_kick.up&buff.tiger_power.up
    }, { "player.chi >= 2", "!player.buff(116740)", "player.buff(Tiger Power).duration > 2", "target.debuff(Rising Sun Kick)" }},

    -- Energizing Brew when it will take more than 6 secs to max-out energy
    --actions+=/energizing_brew,if=energy.time_to_max>6
    --{ "115289", "player.timetomax > 6" },
    { "Energizing Brew", "player.timetomax > 5" },

    --actions+=/rising_sun_kick,if=debuff.rising_sun_kick.down
    { "Rising Sun Kick", "!target.debuff(Rising Sun Kick)" }, -- Rising Sun Kick

    --actions+=/tiger_palm,if=buff.tiger_power.down&debuff.rising_sun_kick.remains>1&energy.time_to_max>1
    { "Tiger Palm", -- Tiger Palm
      { "!player.buff(Tiger Power)", "target.debuff(Rising Sun Kick)", "target.debuff(Rising Sun Kick).duration > 1", "player.timetomax > 1" }},
    -- AoE
    {{
      --actions.aoe=rushing_jade_wind,if=talent.rushing_jade_wind.enabled
      { "Rushing Jade Wind" }, -- Rushing Jade Wind

      --actions.aoe+=/zen_sphere,cycle_targets=1,if=talent.zen_sphere.enabled&!dot.zen_sphere.ticking
      { "Zen Sphere", "!target.debuff(Zen Sphere)" }, -- 40 yard range!
      
      --actions.aoe+=/chi_wave,if=talent.chi_wave.enabled
      { "Chi Wave" }, -- Chi Wave (40yrd range!)

      --actions.aoe+=/chi_burst,if=talent.chi_burst.enabled
      { "Chi Burst" }, -- Chi Burst (40yrd range!)
      
      --actions.aoe+=/rising_sun_kick,if=chi=chi.max
      { "Rising Sun Kick", { "player.chi = 4", "!player.spell(Ascension).exists" }}, -- Rising Sun Kick
      { "Rising Sun Kick", { "player.chi = 5", "player.spell(Ascension).exists" }}, -- Rising Sun Kick

      --actions.aoe+=/spinning_crane_kick,if=!talent.rushing_jade_wind.enabled
      { "Spinning Crane Kick", "!player.spell(Rushing Jade Wind).exists" } -- Spinning Crane Kick
    }, 
    -- Even is AOE is enabled, don't use unless there are at least 3 enemies
    { "toggle.multitarget", "modifier.enemies > 2" }},

    -- Single
    --actions.single_target=rising_sun_kick
    { "Rising Sun Kick" }, -- Rising Sun Kick

    -- Fists of Fury
    --actions.single_target+=/fists_of_fury,if=buff.energizing_brew.down&energy.time_to_max>4&buff.tiger_power.remains>4
    --"the criteria for FoF are: brew needs to be greater than 5, TF needs to be up, and RSK needs to be on CD"
    --"I only ever use FoF when my energy is below 20, I have 3 chi and RSK is on cooldown for longer than 3 seconds"
    --From Icy-Veins: Rising Sun Kick will not come off cooldown while Fists of Fury is channeling.
    --                You will not reach maximum Energy while Fists of Fury is channeling (either innately or because Energizing Brew Icon Energizing Brew is active).
    --                Tiger Power has at least 5 seconds remaining on its duration.
    {{
    { "Fists of Fury", "player.buff(Dextrous)" },
    { "Fists of Fury", "player.buff(Item - Proc Agility)" },
    { "Fists of Fury", "player.buff(Vicious)" },
    { "Fists of Fury", "player.buff(Restless Agility)" },
    { "Fists of Fury", "player.buff(Item - Attacks Proc Agility and Voodoo Gnomes)" },
    { "Fists of Fury", "player.buff(Synapse Springs)" },
    { "Fists of Fury", "player.buff(116740)" }, -- TeB
    -- }, { "!player.moving", "!player.buff(Energizing Brew)", "player.buff(Tiger Power).duration > 4" }},
    -- }, { "!player.moving", "!player.buff(Energizing Brew)", "player.timetomax > 4", "player.buff(Tiger Power).duration > 4" }},
    }, { "!player.moving", 
         "!player.buff(Energizing Brew)", 
         "player.timetomax > 4", 
         "player.buff(Tiger Power).duration > 4", 
         "target.debuff(Rising Sun Kick).duration > 4",
         "toggle.fof" }},
    --}, { "!player.moving", "!player.buff(Energizing Brew)", "player.timetomax > 4", "player.buff(Tiger Power).duration > 4", "player.spell(Rising Sun Kick).cooldown > 4" }},



    {{
      --actions.single_target+=/chi_wave,if=talent.chi_wave.enabled&energy.time_to_max>2
      { "Chi Wave" }, -- Chi Wave (40 yard range!)
      --actions.single_target+=/chi_burst,if=talent.chi_burst.enabled&energy.time_to_max>2
      { "Chi Burst" }, -- Chi Burst (40 yard range!)
      --actions.single_target+=/zen_sphere,cycle_targets=1,if=talent.zen_sphere.enabled&energy.time_to_max>2&!dot.zen_sphere.ticking
      --{ "Zen Sphere", "!target.debuff(Zen Sphere)" }, -- (40 yard range!)
      { "Zen Sphere", { "!target.debuff(Zen Sphere)" }, "target" }, -- (40 yard range!)
      }, "player.timetomax > 2" },

    --actions.single_target+=/blackout_kick,if=buff.combo_breaker_bok.react
    { "Blackout Kick", "player.buff(Combo Breaker: Blackout Kick)" }, -- Blackout Kick

    --actions.single_target+=/tiger_palm,if=buff.combo_breaker_tp.react&(buff.combo_breaker_tp.remains<=2|energy.time_to_max>=2)
    -- Tiger Palm
    {{
      { "Tiger Palm", "player.buff(Combo Breaker: Tiger Palm).duration <= 2" },
      { "Tiger Palm", "player.timetomax >= 2" }
    }, "player.buff(Combo Breaker: Tiger Palm)" },

    --actions.single_target+=/jab,if=chi.max-chi>=2
    { "Jab", { "player.chi <= 2", "!player.spell(Ascension).exists" }},
    { "Jab", { "player.chi <= 3", "player.spell(Ascension).exists" }},

    --actions.single_target+=/blackout_kick,if=energy+energy.regen*cooldown.rising_sun_kick.remains>=40
    { "Blackout Kick", "@NOC.fillBlackout" },
  }, { "target.range <= 5", "!player.casting" }},

  -- Ranged
  {{
    -- Tiger's Lust if the target is at least 15 yards away and we are moving
    { "Tiger's Lust", { "target.range >= 15", "player.moving" }},

    -- Spinning Fire Blossom - best when used glyphed to avoid random blossoms going all over the combat area
    { "Spinning Fire Blossom", { "target.range > 5", "target.range <= 50", "player.chi > 1" }},

    { "Zen Sphere", "!target.debuff(Zen Sphere)" }, -- 40 yard range!
    { "Chi Wave" }, -- Chi Wave (40yrd range!)
    { "Chi Burst" }, -- Chi Burst (40yrd range!)

    -- Crackling Jade Lightning
    { "Crackling Jade Lightning", { "target.range > 5", "target.range <= 40", "!player.moving" }},

    { "Expel Harm", "player.chi < 4" } -- Expel Harm
  }, "@NOC.immuneEvents" },
},
{
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
  { "Legacy of the Emperor", { -- Legacy of the Emperor
      "!player.buff(117666).any",
      "!player.buff(1126).any",
      "!player.buff(20217).any",
      "!player.buff(90363).any"
  }},
  { "Expel Harm", "player.health < 100" }, -- Expel Harm when not at full health
  { "Expel Harm", "toggle.chistacker" }, -- Expel Harm
  { "Healing Sphere", "modifier.lcontrol", "ground" },  -- Healing Sphere
}, function()
ProbablyEngine.toggle.create('chistacker', 'Interface\\Icons\\ability_monk_expelharm', 'Stack Chi', 'Keep Chi at full even OoC...')
ProbablyEngine.toggle.create('useItem', 'Interface\\Icons\\trade_alchemy_potiona2', 'Use Items', 'Toggle for item usage since it is so buggy')
ProbablyEngine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automatically target the nearest enemy when target dies or does not exist')
ProbablyEngine.toggle.create('fof', 'Interface\\Icons\\monk_ability_fistoffury', 'Fists of Fury', 'Enable use of Fists of Fury')
ProbablyEngine.toggle.create('autosef', 'Interface\\Icons\\spell_sandstorm', 'Auto SEF', 'Automatically cast SEF on mouseover targets')
end)
