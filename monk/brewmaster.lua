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
}

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
	-- Hotkeys ---------------------------------------------------------------------------------------------------------
	{ "pause", "modifier.lshift"},
	{ "pause", "@NOC.pause()"},
	{ "115180", "modifier.lcontrol", "ground" }, -- Dizzying Haze
	{ "115315", "modifier.lalt", "ground" }, -- Black Ox Statue


	-- AutoTarget
	{ "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
	{ "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } },

	-- Buffs -----------------------------------------------------------------------------------------------------------
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

	-- Queued Spells ---------------------------------------------------------------------------------------------------
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

	-- Interrupts ------------------------------------------------------------------------------------------------------
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
	}, "target.interruptAt(30)" }, -- Interrupt when 30% into the cast time


	-- Selfheal Talents T2 ---------------------------------------------------------------------------------------------
	{ "115098", { "player.health < 85" }, "player" }, -- Chi Wave
	{ "123986", "player.health < 85" }, -- Chi Burst
	{ "124081", { "player.buff(124081)" }, "focus" }, -- Zen Sphere on focus if buff is already on player
	{ "124081", { "!player.buff(124081)" }, "player" }, -- Zen Sphere on player
	{ "#5512", "player.health < 40"}, --Healthstone when less than 40% health

	-- Stagger ---------------------------------------------------------------------------------------------------------
	-- Purify always at Heavy Stagger and only when shuffle is at least 25% of health with Moderate Stagger
	{ "119582", "@NOC.DrinkStagger" },

	-- Defensives ------------------------------------------------------------------------------------------------------
	{ "115308", { "player.buff(128939).count >= 9", "!player.buff(Dampen Harm)" }}, -- Elusive Brew at 9 Stacks
	{ "115203", { "player.health <= 35", "!player.buff(Dampen Harm)", "toggle.def" }, "player" }, -- Fortifying Brew when < 35% health
	{ "123402", { "player.health <= 50", "toggle.def" }, "player" }, -- Guard when < 50% health
	--{ "Guard", { "player.buff(Power Guard)" }, "player" }, -- TODO: Proper usage? It is being used on CD whenever the buff is up..
	{ "115450", { "player.dispellable(115450)" }, "player" }, -- Self Dispell (Detox)
	{ "115450", { "!modifier.last(4987)", "mouseover.exists", "mouseover.alive", "mouseover.friend", "mouseover.range <= 40", "mouseover.dispellable(115450)" }, "mouseover" }, -- Detox on mouseover if needed

	{ "Nimble Brew", "@NOC.noControl()" },
	{ "Tiger's Lust", "@NOC.noControl()" },

	--Taunt on Encounter (needs focus on other tank)
	{{
	{ "!115546", { "target.id(71543)", "!player.debuff(143436).any", "focus.debuff(143436).any" }},    -- Immerseus
	{ "!115546", { "target.id(72276)", "!player.debuff(146124).any", "focus.debuff(146124).any.count >= 4" }},  -- Norushen 4 Stacks
	{ "!115546", { "target.id(71734)", "!player.debuff(144358).any", "focus.debuff(144358).any" }},    -- Sha of Pride
	{ "!115546", { "target.id(71466)", "!player.debuff(144467).any.duration > 5", "focus.debuff(144467).any.count >= 3" }},    -- Iron Juggernaut 3 Stacks
	{ "!115546", { "target.id(71859)", "!player.debuff(144215).any", "focus.debuff(144215).any.count >= 4" }},  -- Dark Shamans 4 Stacks
	{ "!115546", { "target.id(71515)", "!player.debuff(143494).any", "focus.debuff(143494).any.count >= 3" }},  -- Nazgrim 3 Stacks
	{ "!115546", { "target.id(71454)", "!player.debuff(142990).any", "focus.debuff(142990).any.count >= 12" }},    -- Malkorok
	{ "!115546", { "target.id(71504)", "!player.debuff(143385).any", "focus.debuff(143385).any.count >= 3" }},     -- Blackfuse 3 Stacks !!!
	{ "!115546", { "target.id(71529)", "!player.debuff(143426).any", "focus.debuff(143426).any.count >= 2" }},  -- Thok 2 Stacks Fearsome Roar
	{ "!115546", { "target.id(71529)", "!player.debuff(143780).any", "focus.debuff(143780).any.count >= 2" }},  -- Thok 2 Stacks Acid Breath
	{ "!115546", { "target.id(71529)", "!player.debuff(143773).any", "focus.debuff(143773).any.count >= 3" }},  -- Thok 2 Stacks Freezing Breath
	{ "!115546", { "target.id(71865)", "!player.debuff(145183).any", "focus.debuff(145183).any.count >= 3" }},  -- Garrosh 3 Stacks Gripping Despair
	{ "!115546", { "target.id(71865)", "!player.debuff(145195).any", "focus.debuff(145195).any.count >= 3" }},  -- Garrosh 3 Stacks Empowered Gripping Despair
	}, { "toggle.autotaunt", "target.threat < 100" },},

	-- Cooldowns -------------------------------------------------------------------------------------------------------
	{{
			{ "Lifeblood" },
			{ "Berserking" },
			{ "Blood Fury" },
			{ "Bear Hug" },
			{ "Invoke Xuen, the White Tiger", "player.time > 5" },
	}, "modifier.cooldowns" },

	-- Main Rotation ---------------------------------------------------------------------------------------------------

--[[
ctions+=/chi_brew,if=talent.chi_brew.enabled&chi.max-chi>=2&buff.elusive_brew_stacks.stack<=10
actions+=/gift_of_the_ox,if=buff.gift_of_the_ox.react&incoming_damage_1500ms
actions+=/diffuse_magic,if=incoming_damage_1500ms&buff.fortifying_brew.down
actions+=/dampen_harm,if=incoming_damage_1500ms&buff.fortifying_brew.down&buff.elusive_brew_activated.down
actions+=/fortifying_brew,if=incoming_damage_1500ms&(buff.dampen_harm.down|buff.diffuse_magic.down)&buff.               elusive_brew_activated.down
actions+=/elusive_brew,if=buff.elusive_brew_stacks.react>=9&(buff.dampen_harm.down|buff.diffuse_magic.down)&buff.elusive_brew_activated.down
actions+=/invoke_xuen,if=talent.invoke_xuen.enabled&time>5
actions+=/serenity,if=talent.serenity.enabled&energy<=40
actions+=/call_action_list,name=st,if=active_enemies<3
actions+=/call_action_list,name=aoe,if=active_enemies>=3

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

	-- Automatically cast Dizzying Haze at the ground as long as it's an enemy who is aggroing another player
	{ "115180", {
		"toggle.dh",
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

		{ "Chi Brew", {"player.chi <= 2", "player.buff(128939).count <= 10" }},

		{ "Touch of Death", "player.buff(Death Note)" },

		{ "115072", "player.health <= 85"}, -- Expel Harm if < 85

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
