-- ProbablyEngine Rotation Packager
-- NO CARRIER's Brewmaster Monk Rotation

local onLoad = function()
	ProbablyEngine.toggle.create('def', 'Interface\\Icons\\INV_SummerFest_Symbol_Medium.png', 'Defensive CDs Toggle', 'Enable or Disable usage of Guard / Fortifying Brew')
	ProbablyEngine.toggle.create('zs', 'Interface\\Icons\\ability_monk_expelharm', 'Auto Zen Sphere', 'Keep Zen Sphere up on yourself and the other tank even OoC')
	--ProbablyEngine.toggle.create('autotaunt', 'Interface\\Icons\\Spell_Magic_PolymorphRabbit.png',	'SoO Auto autotaunt Toggle', 'Enable or Disable Auto autotaunt in SoO\nImmerseus 1 Stack\nNorushen 4 Stacks\nSha of Pride 1 Stack\nIron Juggernaut 3 Stacks\nDark Shamans 5 Stacks\nGeneral Nazgrim 3 Stacks\nMalkorok 13 Stacks\nBlackfuse 3 Stacks\nThok 3 Stacks\nGarrosh 3 Stacks\nSET 2ND TANK TO FOCUS')
	ProbablyEngine.toggle.create('kegsmash', 'Interface\\Icons\\achievement_brewery_2.png',	'Keg Smash Toggle',	'Enable or Disable Keg Smash to avoid cleave')
	ProbablyEngine.toggle.create('rjw', 'Interface\\Icons\\ability_monk_rushingjadewind', 'RJW/SCK', 'Enable use of Rushing Jade Wind or Spinning Crane Kick when using Chi Explosion')

	NOC.BaseStatsTableInit()

  C_Timer.NewTicker(0.25, (
      function()
        if ProbablyEngine.config.read('button_states', 'MasterToggle', false) then
          NOC.BaseStatsTableUpdate()
        end
      end),
  nil)
end

local buffs = {
	{ "Legacy of the White Tiger", { -- Legacy of the White Tiger
	"!player.buff(Legacy of the White Tiger).any",
	"!player.buff(17007).any",
	"!player.buff(1459).any",
	"!player.buff(61316).any",
	"!player.buff(24604).any",
	"!player.buff(90309).any",
	"!player.buff(126373).any",
	"!player.buff(126309).any",
	"!player.buff(117666).any",
	"!player.buff(1126).any",
	"!player.buff(20217).any",
	"!player.buff(90363).any"
	}},
}

local ooc = {
	{ "115180", "modifier.lcontrol", "ground" }, -- Dizzying Haze
	{ "115315", "modifier.lalt", "ground" }, -- Black Ox Statue
	{ "Expel Harm", "player.health < 100" }, -- Expel Harm when not at full health
	{{
    { "Zen Sphere", "!player.buff(Zen Sphere)" },
    { "Zen Sphere", { "focus.exists", "!focus.buff(Zen Sphere)", "focus.range <= 40", }, "focus" },
    { "Zen Sphere", { "!focus.exists", "tank.exists", "!tank.buff(Zen Sphere)", "tank.range <= 40", }, "tank" },
  }, "toggle.zs" },
	{ buffs, },
}

local interrupts = {
  { "Paralysis", { -- Paralysis when SHS, and Quaking Palm are all on CD
     "!target.debuff(Spear Hand Strike)",
     "player.spell(Spear Hand Strike).cooldown > 1",
     "player.spell(Quaking Palm).cooldown > 1",
     "!lastcast(Spear Hand Strike)"
  }},
  { "Ring of Peace", { -- Ring of Peace when SHS is on CD
     "!target.debuff(Spear Hand Strike)",
     "player.spell(Spear Hand Strike).cooldown > 1",
     "!lastcast(Spear Hand Strike)"
  }},
  { "Leg Sweep", { -- Leg Sweep when SHS is on CD
     "player.spell(116705).cooldown > 1",
     "target.range <= 5",
     "!lastcast(116705)"
  }},
  { "Charging Ox Wave", { -- Charging Ox Wave when SHS is on CD
     "player.spell(116705).cooldown > 1",
     "target.range <= 30",
     "!lastcast(116705)"
  }},
  { "Quaking Palm", { -- Quaking Palm when SHS is on CD
     "!target.debuff(Spear Hand Strike)",
     "player.spell(Spear Hand Strike).cooldown > 1",
     "!lastcast(Spear Hand Strike)"
  }},
  { "Spear Hand Strike" }, -- Spear Hand Strike
}

local aoe = {
	{ "Chi Explosion", { "player.chi >= 4", "talent(7,2)" }},

	-- removed from the simc APL, so commenting-out here for now (sadface)
	--{{
	--	{ "Breath of Fire", "player.chi >= 3" },
	--	{ "Breath of Fire", "player.buff(Serenity)" },
	--}, { "player.buff(Shuffle).duration >= 6", "target.debuff(Breath of Fire).duration < 2.4", "!talent(7,2)" }},

	{{
		{ "Rushing Jade Wind", "toggle.rjw" },
		-- Otherwise, use it 'normally' if we aren't using chi explosion
		{ "Rushing Jade Wind", "!talent(7,2)" },
	}, { "talent(6,1)", "player.chidiff >= 1", "!player.buff(Serenity)" }},

	{{
		{ "Spinning Crane Kick", "toggle.rjw" },
		-- Otherwise, use it 'normally' if we aren't using chi explosion
		{ "Spinning Crane Kick", "!talent(7,2)" },
	}, { "!talent(6,1)", "player.chidiff >= 1", "!player.buff(Serenity)" }},
}

local combat = {
	-- Hotkeys
	{ "pause", "modifier.lshift" },
	{ "pause", "player.casting(115176)" }, -- Pause for Zen Meditation
	{ "115180", "modifier.lcontrol", "ground" }, -- Dizzying Haze
	{ "115315", "modifier.lalt", "ground" }, -- Black Ox Statue

	-- AutoTarget
  { "/targetenemy [noexists]", "!target.exists" },
  { "/targetenemy [dead]", { "target.exists", "target.dead" } },

	-- Buffs
	{ buffs, },

	{ interrupts, "target.interruptAt(40)" }, -- Interrupt when 40% into the cast time

	-- Self Heal
	{ "Zen Sphere", "!player.buff(Zen Sphere)" },
	{ "Zen Sphere", { "focus.exists", "!focus.buff(Zen Sphere)", "focus.range <= 40", }, "focus" },
  { "#109223", "player.health < 40" }, -- Healing Tonic
	{ "#5512", "player.health < 40" }, --Healthstone when less than 40% health

	-- Purify always at Heavy Stagger and only when shuffle is at least 25% of health with Moderate Stagger
	{ "Purifying Brew", { "@NOC.DrinkStagger" }},
	-- Purify when under Serenity & light stagger
	{ "Purifying Brew", { "player.buff(Serenity)", "player.buff(124275)" }},

	-- Defensives
	{{
		-- Fortifying Brew when < 25% health and DM/DH/EB are not being used
		{ "Fortifying Brew", { "player.health <= 25", "!player.buff(Dampen Harm)", "!player.buff(Diffuse Magic)", "!player.buff(115308)" }, "player" },

		{ "Guard", { "player.spell(Guard).charges = 1", "player.spell(Guard).recharge < 5" }, "player" },
		{ "Guard", { "player.spell(Guard).charges = 2", }, "player" },
	}, "toggle.def" },

	{{
		{ "Chi Brew", { "player.spell(Chi Brew).charges = 1", "player.spell(Chi Brew).recharge < 5" }},
		{ "Chi Brew", { "player.spell(Chi Brew).charges = 2" }},
	}, { "player.chidiff >= 2", "player.buff(128939).count <= 10" }},
	{ "Chi Brew", { "player.chi < 1", "player.debuff(124273)" }},
	{ "Chi Brew", { "player.chi < 2", "!player.buff(Shuffle)" }},

	--Elusive Brew at 8+ Stacks and under 80% health
	{ "115308", { "player.buff(128939).count >= 9", "player.health <= 80", "!player.buff(Dampen Harm)", "!player.buff(Diffuse Magic)", "!player.buff(115308)" }},
	-- Elusive Brew at 14+ stacks no matter what
	{ "115308", "player.buff(128939).count >= 14" },

	--Always attempt Expel Harm when < 35% health
	--TODO: Only consider this if we are using the glyph?
	{ "Expel Harm", "player.health < 35" },

	{ "Detox", { "player.dispellable(115450)" }, "player" }, -- Self Dispell (Detox)
	{ "Detox", { "!modifier.lastcast(4987)", "mouseover.exists", "mouseover.alive", "mouseover.friend", "mouseover.range <= 40", "mouseover.dispellable(115450)" }, "mouseover" }, -- Detox on mouseover if needed

	{ "Nimble Brew", "@NOC.noControl()" },
	{ "Tiger's Lust", "@NOC.noControl()" },

	-- TODO: Implement auto-taunting as a library call

	-- Cooldowns
	{{
			{ "Lifeblood" },
			{ "Berserking" },
			{ "Blood Fury" },
			{ "Invoke Xuen, the White Tiger", "player.time > 5" },
			{ "#trinket1" },
			{ "#trinket2" },
	}, "modifier.cooldowns" },

	-- Main Rotation
	-- Automatically cast Dizzying Haze at the ground as long as it's an enemy who is aggroing another player
	{ "115180", {
		"mouseover.exists",
		"mouseover.enemy",
		"mouseover.combat",
		"mouseover.spell(115546).range",
		"mouseover.threat < 100",
		"mouseover.range > 10"
	}, "ground" },

	{{
		{ "Chi Wave" },
		{ "Chi Burst", { "!player.moving", "talent(2,3)" }},
	}, { "player.timetomax > 2", "!player.buff(Serenity)" }},

	{{
		{ "Zen Sphere", "!player.buff(Zen Sphere)" },
		{ "Zen Sphere", { "focus.exists", "!focus.buff(Zen Sphere)", "focus.range <= 40", }, "focus" },
		{ "Zen Sphere", { "tank.exists", "!tank.buff(Zen Sphere)", "tank.range <= 40", }, "tank" },
	}, { "player.timetomax > 2", "!player.buff(Serenity)" }},

	-- Main Rotation (melee)
	{{
		-- During the first 10 seconds of combat, consider these items as a priority
		--{{
		--	{ "Keg Smash", { "!player.buff(Serenity)", "toggle.kegsmash" }},
		--	{ "Tiger Palm", "!player.buff(Tiger Power)" },
		--	{ "Blackout Kick", "!player.buff(Serenity)" },
		--	{ "Blackout Kick", "player.buff(Serenity).duration < 3" },
		--	--{ "Blackout Kick",  "player.chi >= 4" },
		--}, "player.time < 10" },

		{ "!Touch of Death", "player.buff(Death Note)" },

		{ aoe, { "toggle.multitarget", "modifier.enemies >= 3" }},

		{ "Serenity", { "talent(7,3)", "player.chi >= 2", "player.spell(Keg Smash).cooldown > 6", "modifier.cooldowns" }},

		{ "Blackout Kick", "!player.buff(Shuffle)" },
		{ "Blackout Kick", "player.buff(Shuffle).duration <= 6" },

		{ "Chi Explosion", { "player.chi >= 3", "talent(7,2)" }},

		{ "Chi Brew", { "target.health < 10", "player.spell(Touch of Death).cooldown < 1", "player.chidiff >= 2", "player.buff(Shuffle).duration >= 6", "!player.glyph(Touch of Death)" }},

		{ "Keg Smash", { "player.chidiff >= 2", "!player.buff(Serenity)", "toggle.kegsmash" }},

		{ "Blackout Kick", "player.chidiff < 2" },

		--actions.st+=/blackout_kick,if=buff.shuffle.remains<=3 & cooldown.keg_smash.remains>=gcd
		-- TODO: This needs more work around GCD
		{ "Blackout Kick", { "player.buff(Shuffle).duration <= 3", "player.spell(Keg Smash).cooldown >= 1.5" }},
		--actions.st+=/blackout_kick,if=buff.serenity.up
		{ "Blackout Kick", "player.buff(Serenity)" },

		--expel_harm,if= chi.max-chi>=1 & cooldown.keg_smash.remains>=gcd & (energy+(energy.regen*(cooldown.keg_smash.remains)))>=80
		-- TODO: This needs more work around GCD
		{ "Expel Harm", { "player.chidiff >= 1", "player.spell(Keg Smash).cooldown >= 1.5", "@NOC.KSEnergy(80)" }},

		{ "Jab", {
			"player.chidiff >= 1",
			"player.spell(Keg Smash).cooldown > 1",
			"player.spell(Expel Harm).cooldown > 1",
			"@NOC.KSEnergy(80)",
		}},

		{ "Tiger Palm" },
	}, { "target.range <= 5" }},

	{ "Tiger's Lust", { "target.range >= 15", "player.moving", "player.movingfor > 1" }},
}

ProbablyEngine.rotation.register_custom(268, "|cFF32ff84NOC Brewmaster Monk |r", combat, ooc, onLoad)
