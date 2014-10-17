-- ProbablyEngine Rotation Packager
-- NO CARRIER's Brewmaster Monk Rotation
ProbablyEngine.rotation.register_custom(268, "|cFF32ff84NOC Brewmaster Monk 6.0|r", {

-- Hotkeys ---------------------------------------------------------------------------------------------------------
	{ "pause", "modifier.lshift"},
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
		{ "115078", { -- Paralysis when SHS, Ring of Peace, and Quaking Palm are all on CD
			"!target.debuff(Spear Hand Strike)",
			"player.spell(116705).cooldown > 0",
			"player.spell(116844).cooldown > 0",
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
		{ "107079", { -- Quaking Palm when SHS and Ring of Peace are on CD
			"!target.debuff(Spear Hand Strike)",
			"player.spell(116705).cooldown > 0",
			"player.spell(116844).cooldown > 0",
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

	{ "137562", "player.state.disorient" }, -- 137562 = Nimble Brew
	{ "137562", "player.state.fear" },
	{ "137562", "player.state.stun" },
	{ "137562", "player.state.root" },
	{ "137562", "player.state.horror" },
	{ "137562", "player.state.snare" },

	{ "116841", "player.state.disorient" }, -- 116841 = Tiger's Lust
	{ "116841", "player.state.stun" },
	{ "116841", "player.state.root" },
	{ "116841", "player.state.snare" },

-- Cooldowns -------------------------------------------------------------------------------------------------------
	{{
			{ "Lifeblood" },
			{ "Berserking" },
			{ "Blood Fury" },
			{ "Bear Hug" },
			{ "Invoke Xuen, the White Tiger", "player.time > 5" },
	}, "modifier.cooldowns" },

-- Main Rotation ---------------------------------------------------------------------------------------------------

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

	{{
		{ "Keg Smash", { "player.chi < 3", "!player.spell(Ascension).exists" }}, -- Keg Smash when less then 3 Chi
		{ "Keg Smash", { "player.chi < 4", "player.spell(Ascension).exists" }}, -- Keg Smash when less then 4 Chi (due to Ascension)
	}, "toggle.kegsmash" },

	-- Blackout Kick
	{ "100784", "!player.buff(115307)" },
	{ "100784", "player.buff(115307).duration < 3" },
	{ "100784",  "player.chi >= 4" },


	{ "Chi Brew", {"player.chi <= 2", "player.buff(128939).count <= 10" }},
-------------------




	-- Blackout Kick only with at least 2 Chi
	{{
		{ "100784", "!player.buff(115307)"},
		{ "100784", "player.buff(115307).duration < 3"},
		{ "100784" }
	}, "player.chi >= 2" },

	{ "Touch of Death", "player.buff(Death Note)" },

	-- AoE only when toggles and at least 3 enemies
	{{
			--{{
			--   { "Keg Smash", { "player.chi < 3", "!player.spell(Ascension).exists" }}, -- Keg Smash when less then 3 Chi
			--   { "Keg Smash", { "player.chi < 4", "player.spell(Ascension).exists" }}, -- Keg Smash when less then 4 Chi (due to Ascension)
			--}, { "toggle.kegsmash", "!target.debuff(Dizzying Haze)" }},

			{ "Breath of Fire", {
				"player.buff(125359).duration >= 6",
				"target.debuff(Dizzying Haze)",
				"!target.debuff(Breath of Fire)",
				"player.chi >= 3",
			}},

			--Rushing Jade Wind
			{ "116847", {
				"player.chi >= 3",
				--"player.buff(115307).duration >= 3",  -- Shuffle
			}},

			-- Blackout Kick
			{ "100784", { "player.spell(Rushing Jade Wind).exists", "player.buff(115307).duration <= 3" }},
			{ "100784", { "player.spell(Rushing Jade Wind).exists", "player.chi >= 4" }},

		--Spinning Crane Kick
		{ "101546", {
			"!player.spell(116847).exists",
			"player.chi >= 3",
			--"player.buff(115307).duration >= 3", -- shuffle
		}},

		{ "Jab", { "player.spell(Rushing Jade Wind).exists", "player.chi >= 3" }},

		--"modifier.enemies > 2"
	}, { "toggle.multitarget" }},


-- ST

	{ "100787", "player.buff(125359).duration < 4" }, -- Tiger Palm if Tiger Power buff will last < 4 seconds
	{ "100787", "player.energy <= 39"}, -- Tiger Palm when < 40 energy
	{ "115072", "player.health <= 85"}, -- Expel Harm if < 85

	{ "Jab", "player.energy >= 40"}, -- Jab when we have at least 40 energy

	{ "Tiger's Lust", { "target.range >= 15", "player.moving" }},

	-- TODO: Not sure if a good idea as a BM
	--{ "Crackling Jade Lightning", { "target.range > 5", "target.range <= 40", "!player.moving" }},


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
},

-- OOC -------------------------------------------------------------------------------------------------------------
{
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
},

-- Custom Toggle ---------------------------------------------------------------------------------------------------
function()
ProbablyEngine.toggle.create(
    'def',
    'Interface\\Icons\\INV_SummerFest_Symbol_Medium.png‎',
    'Defensive CDs Toggle',
	'Enable or Disable usage of Guard / Fortifying Brew')
ProbablyEngine.toggle.create(
    'autotaunt',
    'Interface\\Icons\\Spell_Magic_PolymorphRabbit.png‎',
    'SoO Auto autotaunt Toggle',
	'Enable or Disable Auto autotaunt in SoO\nImmerseus 1 Stack\nNorushen 4 Stacks\nSha of Pride 1 Stack\nIron Juggernaut 3 Stacks\nDark Shamans 5 Stacks\nGeneral Nazgrim 3 Stacks\nMalkorok 13 Stacks\nBlackfuse 3 Stacks\nThok 3 Stacks\nGarrosh 3 Stacks\nSET 2ND TANK TO FOCUS')
ProbablyEngine.toggle.create(
    'kegsmash',
    'Interface\\Icons\\achievement_brewery_2.png‎',
    'Keg Smash Toggle',
	'Enable or Disable Keg Smash to avoid cleave')
ProbablyEngine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automatically target the nearest enemy when target dies or does not exist')
end)
