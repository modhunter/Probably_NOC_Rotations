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
	{ "Chi Explosion", "player.chi >= 4" },

	{ "Breath of Fire", {
			"player.buff(115307).duration >= 9",
			"!target.debuff(Breath of Fire)",
			"player.chi >= 3",
			"!talent(7,2)",
	}},

	{{
		-- Only use this is we have the RJW talent and there are more than 3 enemies and toggle enabled
		{ "Rushing Jade Wind", { "modifier.enemies > 3", "toggle.rjw" }},
		-- Otherwise, use it 'normally' if we aren't using chi explosion
		{ "Rushing Jade Wind", "!talent(7,2)" },
	}, { "talent(6,1)", "player.chidiff >= 1" }},

	{{
		-- Only do this if we do not have RJW talent and there are more than 3 enemies and toggle enabled
		{ "Spinning Crane Kick", { "modifier.enemies > 3", "toggle.rjw" }},
		-- Otherwise, use it 'normally' if we aren't using chi explosion
		{ "Spinning Crane Kick", "!talent(7,2)" },
	}, { "!talent(6,1)", "player.chidiff >= 1" }},
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

	-- Purify always at Heavy Stagger and only when shuffle is at least 25% of health with Moderate Stagger when not using Chi Explosion
	{ "Purifying Brew", { "@NOC.DrinkStagger", "!talent(7,2)" }},

	-- Purify only at heavy stagger when using Chi Explosion
	--{ "Purifying Brew", { "player.debuff(124273)", "talent(7,2)" }},

	-- Purify if Serenity is about to fall-off
	{ "Purifying Brew", { "player.buff(157558)", "player.buff(157558).duration <= 2" }},

	-- Defensives
	-- Fortifying Brew when < 25% health and DM/DH are not being used
	{ "Fortifying Brew", { "player.health <= 25", "!player.buff(Dampen Harm)", "!player.buff(Diffuse Magic)", "toggle.def" }, "player" },

	-- Guard when glyphed and not active (basically on CD)
	{ "Guard", { "player.glyph(123401)", "!player.buff(123402)", "toggle.def" }, "player" },
	-- Guard when not glyphed, not ative, and <= 60% health
	{ "Guard", { "!player.glyph(123401)", "player.health <= 60", "toggle.def", "!player.buff(115295)" }, "player" },

	-- TODO: add check for buff.elusive_brew_activated.down
	--Elusive Brew at 8+ Stacks and under 80% health
	{ "115308", { "player.buff(128939).count >= 8", "player.health <= 80", "!player.buff(Dampen Harm)", "!player.buff(Diffuse Magic)" }},
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
			{ "Bear Hug" },
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

	-- Main Rotation (melee)
	{{
		-- During the first 10 seconds of combat, consider these items as a priority
		{{
			{ "Keg Smash", { "!player.buff(157558)", "toggle.kegsmash" }},
			{ "Tiger Palm", "!player.buff(Tiger Power)" },
			{ "Blackout Kick", "!player.buff(115307)" },
			{ "Blackout Kick", "player.buff(115307).duration < 3" },
			--{ "Blackout Kick",  "player.chi >= 4" },
		}, "player.time < 10" },

		{ "Serenity", { "player.chidiff >= 1", "player.buff(Tiger Power).duration >= 10", "modifier.cooldowns" }},

		{ "Keg Smash", { "player.chidiff >= 2", "toggle.kegsmash" }},

		{ "Blackout Kick", "player.buff(157558)" },

		{ "Chi Brew", {
			"player.chidiff >= 2",
			"player.buff(128939).count <= 10",
		}},

		{ "Blackout Kick", "!player.buff(115307)" },
		{ "Blackout Kick", "player.buff(115307).duration < 9" },

		{ "Chi Explosion", "player.chi >= 3" },

		{ "Tiger Palm", "!player.buff(Tiger Power)" },

		{ "Touch of Death", "player.buff(Death Note)" },

		{ "Chi Burst" },
		{ "Chi Wave" },

		{ aoe, { "toggle.multitarget", "modifier.enemies >= 3" }},

		{ "Expel Harm", "player.health <= 75 "},

		{ "Blackout Kick", "player.chidiff = 0" },

		-- Use Jab when we are not chi-capped and Keg Smash and Expel Harm are on CD
		{ "Jab", {
			"player.chidiff >= 1",
			--"player.spell(Keg Smash).cooldown > 0",
			--"player.spell(Expel Harm).cooldown > 0",
			"player.energy > 70",
		}},

		{ "Tiger Palm" },
	}, { "target.exists", "target.alive", "player.alive", "target.range <= 5", "!player.casting" }},

	{ "Tiger's Lust", { "target.range >= 15", "player.moving", "player.movingfor > 1" }},
}

ProbablyEngine.rotation.register_custom(268, "|cFF32ff84NOC Brewmaster Monk 6.0|r", combat, ooc, onLoad)
