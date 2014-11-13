-- ProbablyEngine Rotation Packager
-- NO CARRIER's Brewmaster Monk Rotation

local onLoad = function()
	ProbablyEngine.toggle.create('def', 'Interface\\Icons\\INV_SummerFest_Symbol_Medium.png‎', 'Defensive CDs Toggle', 'Enable or Disable usage of Guard / Fortifying Brew')
	ProbablyEngine.toggle.create('autotaunt', 'Interface\\Icons\\Spell_Magic_PolymorphRabbit.png‎',	'SoO Auto autotaunt Toggle', 'Enable or Disable Auto autotaunt in SoO\nImmerseus 1 Stack\nNorushen 4 Stacks\nSha of Pride 1 Stack\nIron Juggernaut 3 Stacks\nDark Shamans 5 Stacks\nGeneral Nazgrim 3 Stacks\nMalkorok 13 Stacks\nBlackfuse 3 Stacks\nThok 3 Stacks\nGarrosh 3 Stacks\nSET 2ND TANK TO FOCUS')
	ProbablyEngine.toggle.create('kegsmash', 'Interface\\Icons\\achievement_brewery_2.png‎',	'Keg Smash Toggle',	'Enable or Disable Keg Smash to avoid cleave')
	ProbablyEngine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automatically target the nearest enemy when target dies or does not exist')
end

local ooc = {
	{ "115180", "modifier.lcontrol", "ground" }, -- Dizzying Haze
	{ "115315", "modifier.lalt", "ground" }, -- Black Ox Statue
	{ "Expel Harm", "player.health < 100" }, -- Expel Harm when not at full health
	{ "Legacy of the White Tiger", "!player.buffs.stats" },
	{ "Legacy of the White Tiger", "!player.buffs.crit" },
}

local aoe = {
	{ "Breath of Fire", {
			--"target.debuff(Dizzying Haze)",
			"player.buff(115307).duration >= 6",
			"!target.debuff(Breath of Fire)",
			"player.chi >= 3",
	}},

	{ "Chi Explosion", "player.chi >= 4" },

	{ "Rushing Jade Wind", {
		"player.chidiff >= 1",
		"!player.buff(116847)",
	}},

	{ "Keg Smash", { "player.chidiff >= 2", "!player.buff(Serenity)", "toggle.kegsmash" }},

	{{
		{ "Chi Burst" },
		{ "Chi Wave" },
	}, "player.timetomax > 3" },

	{{
		{ "Blackout Kick", { "player.buff(115307).duration <= 3", "player.spell(Keg Smash).cooldown > 0" }},
		{ "Blackout Kick", "!player.buff(115307)" },
		{ "Blackout Kick", "player.buff(Serenity)" },
		{ "Blackout Kick",  "player.chi >= 4" },
	}, "player.spell(116847).exists" },

	{ "Expel Harm", {
		"player.health <= 85",
		"player.chidiff >= 1",
		"player.spell(Keg Smash).cooldown > 0",
		"@NOC.KSEnergy >= 40"
	}},

	{ "Spinning Crane Kick", {
		"player.chidiff >= 1",
		"!player.spell(116847).exists",
	}},

	{ "Jab", {
		"player.chidiff >= 1",
		"player.spell(Keg Smash).cooldown > 0",
		"player.spell(Expel Harm).cooldown > 0"
	}},

	{{
		{ "Tiger Palm", "@NOC.KSEnergy >= 40" },
		{ "Tiger Palm", "player.spell(Keg Smash).cooldown > 0" },
	}, "player.spell(116847).exists" },
}

local combat = {
	-- Hotkeys
	{ "pause", "modifier.lshift" },
	{ "pause", "@NOC.pause()" },
	{ "pause", "player.casting(115176)" }, -- Pause for Zen Meditation
	{ "115180", "modifier.lcontrol", "ground" }, -- Dizzying Haze
	{ "115315", "modifier.lalt", "ground" }, -- Black Ox Statue

	-- AutoTarget
	{ "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
	{ "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } },

	-- Buffs
	{ "Legacy of the White Tiger", "!player.buffs.stats" },
	{ "Legacy of the White Tiger", "!player.buffs.crit" },

	-- Queued Spells
	-- TODO: Remediate this
	 ---------------------------------------------------------------------------------------------------
	{ "!123402", "@NOC.checkQueue(123402)" }, -- Guard
	{ "!115203", "@NOC.checkQueue(115203)" }, -- Fortifying Brew
	{ "!115176", "@NOC.checkQueue(115176)" }, -- Zen Meditation
	{ "!116844", "@NOC.checkQueue(116844)" }, -- Ring of Peace
	{ "!119392", "@NOC.checkQueue(119392)" }, -- Charging Ox Wave
	{ "!119381", "@NOC.checkQueue(119381)" }, -- Leg Sweep
	{ "!122280", "@NOC.checkQueue(122280)" }, -- Healing Elixers
	{ "!122278", "@NOC.checkQueue(122278)" }, -- Dampen Harm
	{ "!122783", "@NOC.checkQueue(122783)" }, -- Diffuse Magic
	{ "!115078", "@NOC.checkQueue(115078)", "mouseover" }, -- Paralysis
	{ "!115315", "@NOC.checkQueue(115315)", "ground" }, -- Summon Black Ox Statue

	-- Interrupts
	{{
		{ "115078", { -- Paralysis when SHS and Quaking Palm are all on CD
			"!target.debuff(Spear Hand Strike)",
			"player.spell(116705).cooldown > 0",
			"player.spell(107079).cooldown > 0",
			"!modifier.last(116705)"
		}},
		{ "116844", { -- Ring of Peace when SHS is on CD
			"!target.debuff(Spear Hand Strike)",
			"player.spell(116705).cooldown > 0",
			"!modifier.last(116705)"
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
		{ "107079", { -- Quaking Palm when SHS on CD
			"!target.debuff(Spear Hand Strike)",
			"player.spell(116705).cooldown > 0",
			"!modifier.last(116705)"
		}},
		{ "116705" }, -- Spear Hand Strike
	}, "target.interruptAt(40)" }, -- Interrupt when 40% into the cast time

	-- Selfheal
	{ "124081", { "player.buff(124081)", "!focus.buff(124081)" }, "focus" }, -- Zen Sphere on focus if buff is already on player and we are above 90% health
	{ "124081", { "!player.buff(124081)" }, "player" }, -- Zen Sphere on player
	{ "#5512", "player.health < 40"}, --Healthstone when less than 40% health

	-- Purify always at Heavy Stagger and only when shuffle is at least 25% of health with Moderate Stagger
	{ "Purifying Brew", "@NOC.DrinkStagger" },

	-- Defensives
	-- Fortifying Brew when < 35% health
	-- TODO: add check for buff.elusive_brew_activated.down
	{ "Fortifying Brew", { "player.health <= 30", "!player.buff(Dampen Harm)", "!player.buff(Diffuse Magic)", "toggle.def" }, "player" },

	-- Guard when glyphed and not active (basically on CD)
	{ "Guard", { "player.glyph(123401)", "!player.buff(123402)", "toggle.def" }, "player" },
	-- Guard when not glyphed, not ative, and <= 70% health
	{ "Guard", { "!player.glyph(123401)", "player.health <= 70", "toggle.def", "!player.buff(115295)" }, "player" },

	-- TODO: add check for buff.elusive_brew_activated.down
	--Elusive Brew at 8+ Stacks and under 80% health
	{ "115308", { "player.buff(128939).count >= 8", "player.health <= 80", "!player.buff(Dampen Harm)", "!player.buff(Diffuse Magic)" }},
	-- Elusive Brew at 14+ stacks no matter what
	{ "115308", "player.buff(128939).count >= 14" },

	--Purify when under healing elixirs buff and <= 80% health
	{ "Purifying Brew", { "player.health <= 80", "player.buff(134563)" }},

	--Expel Harm
	{ "Expel Harm", "player.health <= 35" },
	{ "Expel Harm", { "player.health <= 90 ", "@NOC.KSEnergy >= 80", "player.chidiff >= 2" }},

	{ "Detox", { "player.dispellable(115450)" }, "player" }, -- Self Dispell (Detox)
	{ "Detox", { "!modifier.last(4987)", "mouseover.exists", "mouseover.alive", "mouseover.friend", "mouseover.range <= 40", "mouseover.dispellable(115450)" }, "mouseover" }, -- Detox on mouseover if needed

	{ "Nimble Brew", "@NOC.noControl()" },
	{ "Tiger's Lust", "@NOC.noControl()" },

	-- TODO: Implement auto-taunting as a library call

	-- Cooldowns
	{{
			{ "Lifeblood" },
			{ "Berserking" },
			{ "Blood Fury" },
			{ "Bear Hug" },
			{ "Invoke Xuen, the White Tiger", "player.time > 5" },
	}, "modifier.cooldowns" },

	-- Main Rotation
	-- Automatically cast Dizzying Haze at the ground as long as it's an enemy who is aggroing another player
	{ "115180", {
		"mouseover.exists",
		"mouseover.enemy",
		"mouseover.combat",
		"mouseovertarget.exists",
		"mouseovertarget.player",
		"mouseover.spell(115546).range",
		"mouseover.threat < 100",
		"mouseover.range > 10"
	}, "mouseover.ground" },

	-- Main Rotation (melee)
	{{
		-- During the first 10 seconds of combat, consider these items as a priority
		{{
			{ "Keg Smash", { "player.chidiff >= 2", "!player.buff(Serenity)", "toggle.kegsmash" }},

			-- Blackout Kick
			{ "Blackout Kick", "!player.buff(115307)" },
			{ "Blackout Kick", "player.buff(115307).duration < 3" },
			{ "Blackout Kick",  "player.chi >= 4" },
		}, "player.time < 10"},

		{ "Chi Brew", {"player.chidiff >= 2", "player.buff(128939).count <= 10" }},

		{ "Serenity", "player.energy <= 40" },

		{ "Touch of Death", "player.buff(Death Note)" },

		-- AoE
		{ aoe, { "toggle.multitarget", "modifier.enemies >= 3" }},

		{ "Blackout Kick", "!player.buff(115307)" },

		{ "Keg Smash", { "player.chidiff >= 2", "!player.buff(Serenity)", "toggle.kegsmash" }},

		{{
			{ "Chi Burst" },
			{ "Chi Wave" },
		}, "player.timetomax > 3" },

		{ "Chi Explosion", "player.chi >= 3" },

		{ "Blackout Kick", { "player.buff(115307).duration <= 3", "player.spell(Keg Smash).cooldown > 0" }},
		{ "Blackout Kick", "!player.buff(115307)" },
		{ "Blackout Kick", "player.buff(Serenity)" },
		{ "Blackout Kick",  "player.chi >= 4" },

		{ "Expel Harm", { "player.health <= 85", "player.chidiff >= 1", "player.spell(Keg Smash).cooldown > 0" }},

		{ "Jab", { "player.chidiff >= 1", "player.spell(Keg Smash).cooldown > 0", "player.spell(Expel Harm).cooldown > 0" }},

		{ "Tiger Palm", "@NOC.KSEnergy >= 40" },
		{ "Tiger Palm", "player.spell(Keg Smash).cooldown > 0" },
	}, { "target.exists", "target.alive", "player.alive", "target.range <= 5", "!player.casting" }},

	{ "Tiger's Lust", { "target.range >= 15", "player.moving", "player.movingifor > 1" }},
}

ProbablyEngine.rotation.register_custom(268, "|cFF32ff84NOC Brewmaster Monk 6.0|r", combat, ooc, onLoad)
