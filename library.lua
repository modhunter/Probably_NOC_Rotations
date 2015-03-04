NOC = {}
ProbablyEngine.library.register("NOC", NOC)

--local DSL = ProbablyEngine.dsl.get

DEBUGLOGLEVEL = 5
DEBUGTOGGLE = true
NOC.baseStatsTable = { }
tier17set = 0

Whitelist = {
  -- TRAINING DUMMIES
  [31144]     = "31144",      -- Training Dummy - Lvl 80
  [31146]     = "31146",      -- Raider's Training Dummy - Lvl ??
  [32541]     = "32541",      -- Initiate's Training Dummy - Lvl 55 (Scarlet Enclave)
  [32542]     = "32542",      -- Disciple's Training Dummy - Lvl 65
  [32545]     = "32545",      -- Initiate's Training Dummy - Lvl 55
  [32546]     = "32546",      -- Ebon Knight's Training Dummy - Lvl 80
  [32666]     = "32666",      -- Training Dummy - Lvl 60
  [32667]     = "32667",      -- Training Dummy - Lvl 70
  [46647]     = "46647",      -- Training Dummy - Lvl 85
  [60197]     = "60197",      -- Scarlet Monastery Dummy
  [67127]     = "67127",      -- Training Dummy - Lvl 90
  [87318]     = "87318",      -- Dungeoneer's Training Dummy <Damage> ALLIANCE GARRISON
  [87761]     = "87761",      -- Dungeoneer's Training Dummy <Damage> HORDE GARRISON
  [87322]     = "87322",      -- Dungeoneer's Training Dummy <Tanking> ALLIANCE ASHRAN BASE
  [88314]     = "88314",      -- Dungeoneer's Training Dummy <Tanking> ALLIANCE GARRISON
  [88836]     = "88836",      -- Dungeoneer's Training Dummy <Tanking> HORDE ASHRAN BASE
  [88288]     = "88288",      -- Dunteoneer's Training Dummy <Tanking> HORDE GARRISON
  -- WOD DUNGEONS/RAIDS
  [75966]     = "75966",      -- Defiled Spirit (Shadowmoon Burial Grounds)
  [76220]     = "76220",      -- Blazing Trickster (Auchindoun Normal)
  [76222]     = "76222",      -- Rallying Banner (UBRS Black Iron Grunt)
  [76267]     = "76267",      -- Solar Zealot (Skyreach)
  [76518]     = "76518",      -- Ritual of Bones (Shadowmoon Burial Grounds)
  [77252]     = "77252",      -- Ore Crate (BRF Oregorger)
  [77665]     = "77665",      -- Iron Bomber (BRF Blackhand)
  [77891]     = "77891",      -- Grasping Earth (BRF Kromog)
  [77893]     = "77893",      -- Grasping Earth (BRF Kromog)
  [78583]     = "78583",      -- Dominator Turret (BRF Iron Maidens)
  [78584]     = "78584",      -- Dominator Turret (BRF Iron Maidens)
  [79504]     = "79504",      -- Ore Crate (BRF Oregorger)
  [79511]     = "79511",      -- Blazing Trickster (Auchindoun Heroic)
  [81638]     = "81638",      -- Aqueous Globule (The Everbloom)
  [86644]     = "86644",      -- Ore Crate (BRF Oregorger)
}

Blacklist = {
  [76829]     = "76829",      -- Slag Elemental (BrF - Blast Furnace)
  [78463]     = "78463",      -- Slag Elemental (BrF - Blast Furnace)
}

SpecialAuras = {
  -- CROWD CONTROL
  [118]       = "118",        -- Polymorph
  [1513]      = "1513",       -- Scare Beast
  [1776]      = "1776",       -- Gouge
  [2637]      = "2637",       -- Hibernate
  [3355]      = "3355",       -- Freezing Trap
  [6770]      = "6770",       -- Sap
  [9484]      = "9484",       -- Shackle Undead
  [19386]     = "19386",      -- Wyvern Sting
  [20066]     = "20066",      -- Repentance
  [28271]     = "28271",      -- Polymorph (turtle)
  [28272]     = "28272",      -- Polymorph (pig)
  [49203]     = "49203",      -- Hungering Cold
  [51514]     = "51514",      -- Hex
  [61025]     = "61025",      -- Polymorph (serpent) -- FIXME: gone ?
  [61305]     = "61305",      -- Polymorph (black cat)
  [61721]     = "61721",      -- Polymorph (rabbit)
  [61780]     = "61780",      -- Polymorph (turkey)
  [76780]     = "76780",      -- Bind Elemental
  [82676]     = "82676",      -- Ring of Frost
  [90337]     = "90337",      -- Bad Manner (Monkey) -- FIXME: to check
  [115078]    = "115078",     -- Paralysis
  [115268]    = "115268",     -- Mesmerize
  -- MOP DUNGEONS/RAIDS/ELITES
  [106062]    = "106062",     -- Water Bubble (Wise Mari)
  [110945]    = "110945",     -- Charging Soul (Gu Cloudstrike)
  [116994]    = "116994",     -- Unstable Energy (Elegon)
  [122540]    = "122540",     -- Amber Carapace (Amber Monstrosity - Heat of Fear)
  [123250]    = "123250",     -- Protect (Lei Shi)
  [143574]    = "143574",     -- Swelling Corruption (Immerseus)
  [143593]    = "143593",     -- Defensive Stance (General Nazgrim)
  -- WOD DUNGEONS/RAIDS/ELITES
}

-- Credit to StinkyTwitch for the routines to check stat buffs
function NOC.BaseStatsTableInit()
	--[[--------------------------------------------------------------------------------------------
	Only run this once, as we load a rotation. These become the base values.
	--------------------------------------------------------------------------------------------]]--
	NOC.baseStatsTable.strength = UnitStat("player", 1)
	NOC.baseStatsTable.agility = UnitStat("player", 2)
	NOC.baseStatsTable.stamina = UnitStat("player", 3)
	NOC.baseStatsTable.intellect = UnitStat("player", 4)
	NOC.baseStatsTable.spirit = UnitStat("player", 5)
	NOC.baseStatsTable.crit = GetCritChance()
	NOC.baseStatsTable.haste = GetHaste()
	NOC.baseStatsTable.mastery = GetMastery()
	NOC.baseStatsTable.multistrike = GetMultistrike()
	NOC.baseStatsTable.versatility = GetCombatRating(29)
end

function NOC.BaseStatsTablePrint()
	print("Strength: "..NOC.baseStatsTable.strength)
	print("Agility: "..NOC.baseStatsTable.agility)
	print("Stamina: "..NOC.baseStatsTable.stamina)
	print("Intellect: "..NOC.baseStatsTable.intellect)
	print("Spirit: "..NOC.baseStatsTable.spirit)
	print("Crit: "..NOC.baseStatsTable.crit)
	print("Haste: "..NOC.baseStatsTable.haste)
	print("Mastery: "..NOC.baseStatsTable.mastery)
	print("Multistrike: "..NOC.baseStatsTable.multistrike)
	print("Versatility: "..NOC.baseStatsTable.versatility)
end

function NOC.BaseStatsTableUpdate()
	--[[--------------------------------------------------------------------------------------------
	If the base stats change we want to update them. This could be because of gear changes, food,
	flasks, buffs, etc. We want to update the base table prior to combat. Once in combat this table
	is what we check against to see if we have a buff proc.
	--------------------------------------------------------------------------------------------]]--
	if not UnitAffectingCombat("player") then
		if NOC.baseStatsTable.strength ~= UnitStat("player", 1) then
			NOC.baseStatsTable.strength = UnitStat("player", 1)
		end
		if NOC.baseStatsTable.agility ~= UnitStat("player", 2) then
			NOC.baseStatsTable.agility = UnitStat("player", 2)
		end
		if NOC.baseStatsTable.stamina ~= UnitStat("player", 3) then
			NOC.baseStatsTable.stamina = UnitStat("player", 3)
		end
		if NOC.baseStatsTable.intellect ~= UnitStat("player", 4) then
			NOC.baseStatsTable.intellect = UnitStat("player", 4)
		end
		if NOC.baseStatsTable.spirit ~= UnitStat("player", 5) then
			NOC.baseStatsTable.spirit = UnitStat("player", 5)
		end
		if NOC.baseStatsTable.crit ~= GetCritChance() then
			NOC.baseStatsTable.crit = GetCritChance()
		end
		if NOC.baseStatsTable.haste ~= GetHaste() then
			NOC.baseStatsTable.haste = GetHaste()
		end
		if NOC.baseStatsTable.mastery ~= GetMastery() then
			NOC.baseStatsTable.mastery = GetMastery()
		end
		if NOC.baseStatsTable.multistrike ~= GetMultistrike() then
			NOC.baseStatsTable.multistrike = GetMultistrike()
		end
		if NOC.baseStatsTable.versatility ~= GetCombatRating(29) then
			NOC.baseStatsTable.versatility = GetCombatRating(29)
		end
	end
end

function DEBUG(level, debug_string)
    if DEBUGTOGGLE then
        if level == 5 and DEBUGLOGLEVEL >= 5 then
            print(debug_string)
        elseif level == 4 and DEBUGLOGLEVEL >= 4 then
            print(debug_string)
        elseif level == 3 and DEBUGLOGLEVEL >= 3 then
            print(debug_string)
        elseif level == 2 and DEBUGLOGLEVEL >= 2 then
            print(debug_string)
        elseif level == 1 and DEBUGLOGLEVEL >= 1 then
            print(debug_string)
        else
            return
        end
    end
end

function NOC.isWhitelist(unit)
	--[[--------------------------------------------------------------------------------------------
	Unit Exists is a sanity check. If unit is valid get the UnitID from UnitGUID, using strsplit.
	If the UnitID matches a Special Enemy Unit in the table then return true. Otherwise the unit
	is not a Special Enemy.
	--------------------------------------------------------------------------------------------]]--
	if not UnitExists(unit) then
		return false
	end
	local _,_,_,_,_,unitID = strsplit("-", UnitGUID(unit))
	if Whitelist[tonumber(unitID)] ~= nil then
		return true
	else
		return false
	end
end

function NOC.isBlacklist(unit)
	if not UnitExists(unit) then
		return false
	end
	local _,_,_,_,_,unitID = strsplit("-", UnitGUID(unit))
	if Blacklist[tonumber(unitID)] ~= nil then
		return true
	else
		return false
	end
end

function NOC.notBlacklist(unit)
  return not NOC.isBlacklist(unit)
end

function NOC.isValidTarget(unit)
	if not UnitExists(unit) then
		return false
	end
	if isSpecialAura(unit) then
		return false
	elseif not UnitCanAttack("player", unit) then
		return false
	elseif not UnitAffectingCombat(unit) and not NOC.isWhitelist(unit) then
		return false
	else
		return true
	end
end

function NOC.hasDebuffTable(target, spells)
  for i = 1, 40 do
    local _,_,_,_,_,_,_,_,_,_,spellId = _G['UnitDebuff'](target, i)
    for k,v in pairs(spells) do
      if spellId == v then return true end
    end
  end
  return false
end


-- Props to CML for this function
-- if getCreatureType(Unit) == true then
function getCreatureType(unit)
   local CreatureTypeList = {"Critter", "Totem", "Non-combat Pet", "Wild Pet"}
   for i=1, #CreatureTypeList do
      if UnitCreatureType(unit) == CreatureTypeList[i]
      then
        return false
      end
   end
   if UnitIsBattlePet(unit) and UnitIsWildBattlePet(unit)
   then
     return false
   else
     return true
   end
end

-- Various checks to ensure that we can SEF the mouseover unit
function NOC.canSEF()
  if (UnitGUID('target')) ~= (UnitGUID('mouseover'))
    and UnitCanAttack("player", "mouseover")
    and not UnitIsDeadOrGhost("mouseover")
    and getCreatureType("mouseover")
    and not NOC.isBlacklist("mouseover")
  then
    return true
  end
  return false
end

function NOC.StaggerValue ()
    local staggerLight, _, iconLight, _, _, remainingLight, _, _, _, _, _, _, _, _, valueStaggerLight, _, _ = UnitAura("player", GetSpellInfo(124275), "", "HARMFUL")
    local staggerModerate, _, iconModerate, _, _, remainingModerate, _, _, _, _, _, _, _, _, valueStaggerModerate, _, _ = UnitAura("player", GetSpellInfo(124274), "", "HARMFUL")
    local staggerHeavy, _, iconHeavy, _, _, remainingHeavy, _, _, _, _, _, _, _, _, valueStaggerHeavy, _, _ = UnitAura("player", GetSpellInfo(124273), "", "HARMFUL")
    local staggerTotal= (remainingLight or remainingModerate or remainingHeavy or 0) * (valueStaggerLight or valueStaggerModerate or valueStaggerHeavy or 0)
    local percentOfHealth=(100/UnitHealthMax("player")*staggerTotal)
    local ticksTotal=(valueStaggerLight or valueStaggerLight or valueStaggerLight or 0)
    return percentOfHealth;
end

function NOC.DrinkStagger()
    if (UnitPower("player", 12) >= 1 or UnitBuff("player", GetSpellInfo(138237))) then
        if UnitDebuff("player", GetSpellInfo(124273))
            then return true
        end
        if UnitDebuff("player", GetSpellInfo(124274))
            and NOC.StaggerValue() > 25
            then return true
        end
    end
    return false
end

-- Props to CML? for this code
function NOC.noControl()
  local eventIndex = C_LossOfControl.GetNumEvents()
	while (eventIndex > 0) do
		local _, _, text = C_LossOfControl.GetEventInfo(eventIndex)
	-- Hunter
		if select(3, UnitClass("player")) == 3 then
			if text == LOSS_OF_CONTROL_DISPLAY_ROOT or text == LOSS_OF_CONTROL_DISPLAY_SNARE then
				return true
			end
		end
	-- Monk
		if select(3, UnitClass("player")) == 10 then
			if text == LOSS_OF_CONTROL_DISPLAY_STUN or text == LOSS_OF_CONTROL_DISPLAY_FEAR or text == LOSS_OF_CONTROL_DISPLAY_ROOT or text == LOSS_OF_CONTROL_DISPLAY_HORROR then
				return true
			end
		end
	eventIndex = eventIndex - 1
	end
	return false
end

function GetSpellCD(MySpell)
  if GetSpellCooldown(MySpell) == 0 then
     return 0
  else
     local Start ,CD = GetSpellCooldown(MySpell)
     local MyCD = Start + CD - GetTime()
     return MyCD
  end
end

-- Return the amount of energy you will have by the time KS is ready to use
function NOC.KSEnergy()
  local MyNRG = UnitPower("player", 3)
  local MyNRGregen = select(2, GetPowerRegen("player"))
  local NRGforKS = MyNRG + (MyNRGregen * GetSpellCD(121253))
  return NRGforKS
end

function NOC.guidtoUnit(guid)
  local inGroup = GetNumGroupMembers()
  if inGroup then
    if IsInRaid("player") then
      for i=1,inGroup do
        if guid == UnitGUID("RAID".. i .. "TARGET") then
          return "RAID".. i .. "TARGET"
        end
      end
    else
      for i=1,inGroup do
        if guid == UnitGUID("PARTY".. i .. "TARGET") then
          return "PARTY".. i .. "TARGET"
        end
      end
      if guid == UnitGUID("PLAYERTARGET") then
        return "PLAYERTARGET"
      end
    end
  else
    if guid == UnitGUID("PLAYERTARGET") then
      return "PLAYERTARGET"
    end
    if guid == UnitGUID("mouseover") then
      return "mouseover"
    end
  end
  return false
end

function NOC.autoSEF()
  -- Initialize 'targets' every call of the function
  local targets = {}

  -- loop through all of the combatTracker enemies and insert only those
  -- that are 'qualified' targets
  for i,_ in pairs(ProbablyEngine.module.combatTracker.enemy) do

    -- because we can't do most of the required operations on the GUID, we
    -- need to translate the GUID to a UnitID. However a UnitID will only
    -- be valid for those units that are essentially currently targetted by the
    -- player or a player's group-mate, or mouseover, which will result in some
    -- situations where there are enemy actors in combat with the player but
    -- not able to be identified. This is a limitation of not using an
    -- ObjectManager based solution
    local unit = NOC.guidtoUnit(ProbablyEngine.module.combatTracker.enemy[i]['guid'])

    if unit
    and UnitGUID(unit) ~= UnitGUID("target")
    and NOC.isValidTarget(unit)
    and not ProbablyEngine.condition["debuff"](unit,138130)
    and ProbablyEngine.condition["distance"](unit) < 40
    and IsSpellInRange(GetSpellInfo(137639), unit)
    and not NOC.isBlacklist(unit)
    and getCreatureType(unit)
    --and (UnitAffectingCombat(unit) or NOC.isException(unit))
    then
      table.insert(targets, { Name = UnitName(unit), Unit = unit, HP = UnitHealth(unit), Range = ProbablyEngine.condition["distance"](unit) } )
    end
  end

  -- sort the qualified targets by health
  table.sort(targets, function(x,y) return x.HP > y.HP end)

  -- auto-cast SE&F on 1 or 2 targets depending on how many enemies are around us
  if #targets > 0 then
    --print(targets[1].Unit..","..targets[1].Name..","..#targets)
    ProbablyEngine.dsl.parsedTarget = targets[1].Unit
    return true
  end
  return false
end


--energy+energy.regen*gcd<50 = powtime < 50
function NOC.energyTime(energycheck)
  if energycheck then
    local energy = UnitPower("player", SPELL_POWER_ENERGY)
    local energy_regen = select(2,GetPowerRegen("player"))
    local gcd = (1.5/GetHaste("player"))+1
    local energytime = (energy + energy_regen)
    if energytime < energycheck then
      DEBUG(5, "NOC.energyTime2 returning: "..energytime.." ("..energy.."+"..energy_regen..")*"..gcd.."")
    end
    return energytime < energycheck
  end
  return false
end

function isSpecialAura(unit)
	--[[--------------------------------------------------------------------------------------------
	UnitExists is a sanity check.
	Loop through the number of possible debuffs, 1-40.
	If we encounter a spellID (select 11) that is nil then we've reached the end of the debuffs for
	this particular Unit. No need to continue.
	Each debuff found, check against the Special Auras table. If a match is found return True.
	--------------------------------------------------------------------------------------------]]--
	if not UnitExists(unit) then
		return false
	end
	for i = 1, 40 do
		local debuff = select(11, UnitDebuff(unit, i))
		if debuff == nil then
			break
		end
		if SpecialAuras[tonumber(debuff)] ~= nil then
			return true
		end
	end
	return false
end
