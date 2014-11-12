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


--[[
actions.aoe=guard
actions.aoe+=/breath_of_fire,if=chi>=3&buff.shuffle.remains>=6&dot.breath_of_fire.remains<=gcd
actions.aoe+=/chi_explosion,if=chi>=4
actions.aoe+=/rushing_jade_wind,if=chi.max-chi>=1&talent.rushing_jade_wind.enabled
actions.aoe+=/purifying_brew,if=!talent.chi_explosion.enabled&stagger.heavy
actions.aoe+=/guard
actions.aoe+=/keg_smash,if=chi.max-chi>=2&!buff.serenity.remains
actions.aoe+=/chi_burst,if=talent.chi_burst.enabled&energy.time_to_max>3
actions.aoe+=/chi_wave,if=talent.chi_wave.enabled&energy.time_to_max>3
actions.aoe+=/zen_sphere,cycle_targets=1,if=talent.zen_sphere.enabled&!dot.zen_sphere.ticking
actions.aoe+=/blackout_kick,if=talent.rushing_jade_wind.enabled&buff.shuffle.remains<=3&cooldown.keg_smash.remains>=gcd
actions.aoe+=/blackout_kick,if=talent.rushing_jade_wind.enabled&buff.serenity.up
actions.aoe+=/blackout_kick,if=talent.rushing_jade_wind.enabled&chi>=4
actions.aoe+=/expel_harm,if=chi.max-chi>=1&cooldown.keg_smash.remains>=gcd&(energy+(energy.regen*(cooldown.keg_smash.remains)))>=40
actions.aoe+=/spinning_crane_kick,if=chi.max-chi>=1&!talent.rushing_jade_wind.enabled
actions.aoe+=/jab,if=talent.rushing_jade_wind.enabled&chi.max-chi>=1&cooldown.keg_smash.remains>=gcd&cooldown.expel_harm.remains>=gcd
actions.aoe+=/purifying_brew,if=!talent.chi_explosion.enabled&talent.rushing_jade_wind.enabled&stagger.moderate&buff.shuffle.remains>=6
actions.aoe+=/tiger_palm,if=talent.rushing_jade_wind.enabled&(energy+(energy.regen*(cooldown.keg_smash.remains)))>=40
actions.aoe+=/tiger_palm,if=talent.rushing_jade_wind.enabled&cooldown.keg_smash.remains>=gcd
]]
local aoe = {
	{ "Breath of Fire", {
			"target.debuff(Dizzying Haze)",
			"!target.debuff(Breath of Fire)",
			"player.chi >= 2",
	}},
	--Spinning Crane Kick
	{ "101546", {
		"!player.spell(116847).exists",
		"player.buff(115307).duration >= 3",
	}},
	--Rushing Jade Wind
	{ "116847", {
		"!player.buff(116847)",
		"player.buff(115307).duration >= 3",
	}},
}

local combat = {
	-- Hotkeys
	{ "pause", "modifier.lshift" },
	{ "pause", "@NOC.pause()" },
	{ "pause", "@NOC.zenMed()" }, -- Pause for Zen Meditation
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


	-- Selfheal Talents T2
	{ "115098", { "player.health < 85" }, "player" }, -- Chi Wave
	{ "123986", "player.health < 85" }, -- Chi Burst
	{ "124081", { "player.buff(124081)", "!focus.buff(124081)" }, "focus" }, -- Zen Sphere on focus if buff is already on player and we are above 90% health
	{ "124081", { "!player.buff(124081)" }, "player" }, -- Zen Sphere on player
	{ "#5512", "player.health < 40"}, --Healthstone when less than 40% health

	-- Purify always at Heavy Stagger and only when shuffle is at least 25% of health with Moderate Stagger
	{ "Purifying Brew", "@NOC.DrinkStagger" },

	-- Defensives
	-- Fortifying Brew when < 35% health
	{ "Fortifying Brew", { "player.health <= 30", "!player.buff(Dampen Harm)", "!player.buff(Diffuse Magic)", "toggle.def" }, "player" },

	-- Guard when glyphed and not active (basically on CD)
	{ "Guard", { "player.glyph(123401)", "!player.buff(123402)", "toggle.def" }, "player" },
	-- Guard when not glyphed, not ative, and <= 70% health
	{ "Guard", { "!player.glyph(123401)", "player.health <= 70", "toggle.def", "!player.buff(115295)" }, "player" },

	{ "115308", { "player.buff(128939).count >= 6", "player.health <= 80", "!player.buff(Dampen Harm)", "!player.buff(Diffuse Magic)" }}, --Elusive Brew at 6+ Stacks and under 80% health
	{ "115308", "player.buff(128939).count >= 14" }, -- Elusive Brew at 14+ stacks no matter what

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
--[[
actions+=/serenity,if=talent.serenity.enabled&energy<=40
actions+=/call_action_list,name=aoe,if=active_enemies>=3

actions.aoe=guard
actions.aoe+=/breath_of_fire,if=chi>=3&buff.shuffle.remains>=6&dot.breath_of_fire.remains<=gcd
actions.aoe+=/chi_explosion,if=chi>=4
actions.aoe+=/rushing_jade_wind,if=chi.max-chi>=1&talent.rushing_jade_wind.enabled
actions.aoe+=/purifying_brew,if=!talent.chi_explosion.enabled&stagger.heavy
actions.aoe+=/guard
actions.aoe+=/keg_smash,if=chi.max-chi>=2&!buff.serenity.remains
actions.aoe+=/chi_burst,if=talent.chi_burst.enabled&energy.time_to_max>3
actions.aoe+=/chi_wave,if=talent.chi_wave.enabled&energy.time_to_max>3
actions.aoe+=/zen_sphere,cycle_targets=1,if=talent.zen_sphere.enabled&!dot.zen_sphere.ticking
actions.aoe+=/blackout_kick,if=talent.rushing_jade_wind.enabled&buff.shuffle.remains<=3&cooldown.keg_smash.remains>=gcd
actions.aoe+=/blackout_kick,if=talent.rushing_jade_wind.enabled&buff.serenity.up
actions.aoe+=/blackout_kick,if=talent.rushing_jade_wind.enabled&chi>=4
actions.aoe+=/expel_harm,if=chi.max-chi>=1&cooldown.keg_smash.remains>=gcd&(energy+(energy.regen*(cooldown.keg_smash.remains)))>=40
actions.aoe+=/spinning_crane_kick,if=chi.max-chi>=1&!talent.rushing_jade_wind.enabled
actions.aoe+=/jab,if=talent.rushing_jade_wind.enabled&chi.max-chi>=1&cooldown.keg_smash.remains>=gcd&cooldown.expel_harm.remains>=gcd
actions.aoe+=/purifying_brew,if=!talent.chi_explosion.enabled&talent.rushing_jade_wind.enabled&stagger.moderate&buff.shuffle.remains>=6
actions.aoe+=/tiger_palm,if=talent.rushing_jade_wind.enabled&(energy+(energy.regen*(cooldown.keg_smash.remains)))>=40
actions.aoe+=/tiger_palm,if=talent.rushing_jade_wind.enabled&cooldown.keg_smash.remains>=gcd

actions.st=blackout_kick,if=buff.shuffle.down
actions.st+=/purifying_brew,if=!talent.chi_explosion.enabled&stagger.heavy
actions.st+=/purifying_brew,if=!buff.serenity.up
actions.st+=/guard
actions.st+=/keg_smash,if=chi.max-chi>=2&!buff.serenity.remains
actions.st+=/chi_burst,if=talent.chi_burst.enabled&energy.time_to_max>3
actions.st+=/chi_wave,if=talent.chi_wave.enabled&energy.time_to_max>3
actions.st+=/zen_sphere,cycle_targets=1,if=talent.zen_sphere.enabled&!dot.zen_sphere.ticking
actions.st+=/chi_explosion,if=chi>=3
actions.st+=/blackout_kick,if=buff.shuffle.remains<=3&cooldown.keg_smash.remains>=gcd
actions.st+=/blackout_kick,if=buff.serenity.up
actions.st+=/blackout_kick,if=chi>=4
actions.st+=/expel_harm,if=chi.max-chi>=1&cooldown.keg_smash.remains>=gcd
actions.st+=/jab,if=chi.max-chi>=1&cooldown.keg_smash.remains>=gcd&cooldown.expel_harm.remains>=gcd
actions.st+=/purifying_brew,if=!talent.chi_explosion.enabled&stagger.moderate&buff.shuffle.remains>=6
actions.st+=/tiger_palm,if=(energy+(energy.regen*(cooldown.keg_smash.remains)))>=40
actions.st+=/tiger_palm,if=cooldown.keg_smash.remains>=gcd
]]

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
		{ "Keg Smash", { "player.chidiff >= 2", "toggle.kegsmash" }},

		-- Blackout Kick
		{ "100784", "!player.buff(115307)" },
		{ "100784", "player.buff(115307).duration < 3" },
		{ "100784",  "player.chi >= 4" },

		{ "Chi Brew", {"player.chidiff >= 2", "player.buff(128939).count <= 10" }},

		{ "Touch of Death", "player.buff(Death Note)" },

		--{ "Chi Burst", "player.timetomax > 3"},

		-- TODO: Which approach to take?
		--{ "Chi Wave", { "player.chidiff >= 2", "player.energy < 40", "player.buff(Tiger Power)" }},
		--{ "Chi Wave", "player.timetomax > 3"},

		{ "Expel Harm", "player.health <= 85"}, -- Expel Harm if < 85

		-- { "100787", "!player.spell(100780).usable" }, -- Tiger Palm if Jab isn't usable... ?

		-- AoE
		{ aoe, { "toggle.multitarget", "modifier.enemies >= 3" }},
		-- No FH
		--{ aoe, {"toggle.multitarget", "!player.firehack"}},
		-- FH and when there is at least 3 enemies
		--{ aoe, {"toggle.multitarget", "target.area(10).enemies >= 3", "player.firehack"}},

		{ "100787", "player.buff(125359).duration < 4" }, -- Tiger Palm if Tiger Power buff will last < 4 seconds
		{ "100787", "player.energy <= 39"}, -- Tiger Palm when < 40 energy

		{ "100780", "player.energy >= 40"}, -- Jab when we have at least 40 energy

	}, { "target.exists", "target.alive", "player.alive", "target.range <= 5", "!player.casting" }},

	{ "Tiger's Lust", { "target.range >= 15", "player.moving", "player.movingifor > 1" }},
}

ProbablyEngine.rotation.register_custom(268, "|cFF32ff84NOC Brewmaster Monk 6.0|r", combat, ooc, onLoad)
