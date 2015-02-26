local NOC = { }
local DSL = ProbablyEngine.dsl.get

BASESTATSVALUE = {}
BASEMULTISTRIKE = 0
DEBUGLOGLEVEL = 5
DEBUGTOGGLE = false
PRIMARYBASESTATS = {}
SECONDARYBASESTATS = {}

SpecialTargets = {
    -- TRAINING DUMMIES
    31144,      -- Training Dummy - Lvl 80
    31146,      -- Raider's Training Dummy - Lvl ??
    32541,      -- Initiate's Training Dummy - Lvl 55 (Scarlet Enclave)
    32542,      -- Disciple's Training Dummy - Lvl 65
    32545,      -- Initiate's Training Dummy - Lvl 55
    32546,      -- Ebon Knight's Training Dummy - Lvl 80
    32666,      -- Training Dummy - Lvl 60
    32667,      -- Training Dummy - Lvl 70
    46647,      -- Training Dummy - Lvl 85
    60197,      -- Scarlet Monastery Dummy
    67127,      -- Training Dummy - Lvl 90
    87761,      -- Dungeoneer's Training Dummy <Damage> HORDE GARRISON
    88288,      -- Dunteoneer's Training Dummy <Tanking> HORDE GARRISON
    88289,      -- Training Dummy <Healing> HORDE GARRISON
    88314,      -- Dungeoneer's Training Dummy <Tanking> ALLIANCE GARRISON
    88316,      -- Training Dummy <Healing> ALLIANCE GARRISON
    89078,      -- Training Dummy (Garrison)
    87318,      -- Dungeoneer's Training Dummy <Damage>
    -- WOD DUNGEONS/RAIDS
    71075,      -- Small Illusionary Banshee (Proving Grounds)
    75966,      -- Defiled Spirit (Shadowmoon Burial Grounds)
    76220,      -- Blazing Trickster (Auchindoun Normal)
    76267,      -- Solar Zealot (Skyreach)
    76518,      -- Ritual of Bones (Shadowmoon Burial Grounds)
    79511,      -- Blazing Trickster (Auchindoun Heroic)
    81638,      -- Aqueous Globule (The Everbloom)
    153792,     -- Rallying Banner (UBRS Black Iron Grunt)
    77252,      -- Ore Crate (BRF Oregorger)
    79504,      -- Ore Crate (BRF Oregorger)
    86644,      -- Ore Crate (BRF Oregorger)
    77665,      -- Iron Bomber (BRF Blackhand)
    77891,      -- Grasping Earth (BRF Kromog)
    77893,      -- Grasping Earth (BRF Kromog)
    78583,      -- Dominator Turret (BRF Iron Maidens)
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

-- Credit to StinkyTwitch for the routines to check primary stat buffs
function BaseStatsInit()
    for i=1, 5 do
        BASESTATSVALUE[#BASESTATSVALUE+1] = UnitStat("player", i)
        --local stat = UnitStat("player", i)
        --DEBUG(5, "i: "..BASESTATSVALUE[#BASESTATSVALUE+1].." = " ..stat)
    end
    BASEMULTISTRIKE = GetMultistrike()
    DEBUG(5, "GetMultistrike = "..BASEMULTISTRIKE)
end


function BaseStatsUpdate()
    if not UnitAffectingCombat("player") then
        for i=1, 5 do
            local stat = UnitStat("player", i)
            if BASESTATSVALUE[i] ~= stat then
                DEBUG(5, "Updating BASESTATSVALUE[i] ("..BASESTATSVALUE[i]..") = " ..stat)
                BASESTATSVALUE[i] = stat
            end
        end
        local multistrike = GetMultistrike()
        if BASEMULTISTRIKE ~= multistrike then
            DEBUG(5, "Updating BASEMULTISTRIKE ("..BASEMULTISTRIKE..") = " ..multistrike)
            BASEMULTISTRIKE = multistrike
        end
    end
end


function NOC.StatProcs(index)
  local index = string.lower(index)

  if index == "strength" then
      index = 1
  elseif index == "agility" then
      index = 2
  elseif index == "stamina" then
      index = 3
  elseif index == "intellect" then
      index = 4
  elseif index == "spirit" then
      index = 5
  elseif index == "multistrike" then
    local multistrike = GetMultistrike()
    if multistrike > BASEMULTISTRIKE then
        DEBUG(5, "StatProcs(multistrike): TRUE ("..multistrike.." > "..BASEMULTISTRIKE..")")
        return true
    else
        --DEBUG(5, "StatProcs(multistrike): FALSE ("..multistrike.." <= "..BASEMULTISTRIKE..")")
        return false
    end
  else
      return false
  end

  local current_stat = UnitStat("player", index)

  if current_stat > BASESTATSVALUE[index] then
      DEBUG(5, "StatProcs(): TRUE ("..current_stat.." > "..BASESTATSVALUE[index]..")")
      return true
  else
      --DEBUG(5, "StatProcs(): FALSE ("..current_stat.." <= "..BASESTATSVALUE[index]..")")
      return false
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

function NOC.SpecialTargetCheck(unit)
    local unit = unit
    local count = table.getn(SpecialTargets)

    if not UnitExists(unit) then
        return false
    end

    if UnitGUID(unit) then
        targets_guid = tonumber(string.match(UnitGUID(unit), "-(%d+)-%x+$"))
    else
        targets_guid = 0
    end

    for i=1, count do
        if targets_guid == SpecialTargets[i] then
            return true
        end
    end

    return false
end


function NOC.immuneEvents(unit)
  if NOC.isException(unit) then return true end
  if not UnitAffectingCombat(unit) then return false end
  -- Crowd Control
  local cc = {
    49203, -- Hungering Cold
     6770, -- Sap
     1776, -- Gouge
    51514, -- Hex
     9484, -- Shackle Undead
      118, -- Polymorph
    28272, -- Polymorph (pig)
    28271, -- Polymorph (turtle)
    61305, -- Polymorph (black cat)
    61025, -- Polymorph (serpent) -- FIXME: gone ?
    61721, -- Polymorph (rabbit)
    61780, -- Polymorph (turkey)
     3355, -- Freezing Trap
    19386, -- Wyvern Sting
    20066, -- Repentance
    90337, -- Bad Manner (Monkey) -- FIXME: to check
     2637, -- Hibernate
    82676, -- Ring of Frost
   115078, -- Paralysis
    76780, -- Bind Elemental
     9484, -- Shackle Undead
     1513, -- Scare Beast
   115268, -- Mesmerize
     6358, -- Seduction
      339, -- Entangling Roots
  }
  if NOC.hasDebuffTable(unit, cc) then return false end
  if UnitAura(unit,GetSpellInfo(116994))
		or UnitAura(unit,GetSpellInfo(122540))
		or UnitAura(unit,GetSpellInfo(123250))
		or UnitAura(unit,GetSpellInfo(106062))
		or UnitAura(unit,GetSpellInfo(110945))
		or UnitAura(unit,GetSpellInfo(143593)) -- General Nazgrim: Defensive Stance
    or UnitAura(unit,GetSpellInfo(143574)) -- Heroic Immerseus: Swelling Corruption
    --or UnitAura(unit,GetSpellInfo(166591)) -- Sanguine Sphere?
		then return false end
  return true
end

function NOC.hasDebuffTable(target, spells)
  for i = 1, 40 do
    local _,_,_,_,_,_,_,_,_,_,spellId = _G['UnitDebuff'](target, i)
    for k,v in pairs(spells) do
      if spellId == v then return true end
    end
  end
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

-- Thanks to StinkyTwitch for the routine
function NOC.isException(unit)
  local unit = unit
  local count = table.getn(SpecialTargets)

  if not UnitExists(unit) then
      return false
  end

  if UnitGUID(unit) then
      targets_guid = tonumber(string.match(UnitGUID(unit), "-(%d+)-%x+$"))
  else
      targets_guid = 0
  end

  for i=1, count do
      if targets_guid == SpecialTargets[i] then
          return true
      end
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

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
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
    --and not UnitIsUnit("target",unit)
    and not ProbablyEngine.condition["debuff"](unit,138130)
    and ProbablyEngine.condition["distance"](unit) < 40
    and getCreatureType(unit)
    and NOC.immuneEvents(unit)
    and (UnitAffectingCombat(unit) or NOC.isException(unit))
    and IsSpellInRange(GetSpellInfo(137639), unit)
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
    --local energy = getPower("player")
    local energy = UnitPower("player", SPELL_POWER_ENERGY)
    --local energy_regen = 1.0 / select(2,GetPowerRegen("player"))
    local energy_regen = select(2,GetPowerRegen("player"))
    local gcd = (1.5/GetHaste("player"))+1
    --local energytime = (energy + energy_regen)*gcd
    local energytime = (energy + energy_regen)
    if energytime < energycheck then
      DEBUG(5, "NOC.energyTime2 returning: "..energytime.." ("..energy.."+"..energy_regen..")*"..gcd.."")
    end
    return energytime < energycheck
  end
  return false
end

function SpecialAurasCheck(unit)
  local unit = unit
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

function PrimaryStatsTableInit()
  for i=1, 5 do
    PRIMARYBASESTATS[#PRIMARYBASESTATS+1] = UnitStat("player", i)
  end
end

function PrimaryStatsTableUpdate()
  if not UnitAffectingCombat("player") then
    for i=1, 5 do
      local stat = UnitStat("player", i)
      if PRIMARYBASESTATS[i] ~= stat then
        PRIMARYBASESTATS[i] = stat
      end
    end
  end
end

function SecondaryStatsTableInit()
  SECONDARYBASESTATS[1] = GetCritChance()
  SECONDARYBASESTATS[2] = GetHaste()
  SECONDARYBASESTATS[3] = GetMastery()
  SECONDARYBASESTATS[4] = GetMultistrike()
  SECONDARYBASESTATS[5] = GetCombatRating(29)
end

function SecondaryStatsTableUpdate()
  if not UnitAffectingCombat("player") then
    local crit = GetCritChance()
    local haste = GetHaste()
    local mastery = GetMastery()
    local multistrike = GetMultistrike()
    local versatility = GetCombatRating(29)

    if SECONDARYBASESTATS[1] ~= crit then
      SECONDARYBASESTATS[1] = crit
    end
    if SECONDARYBASESTATS[2] ~= haste then
      SECONDARYBASESTATS[2] = haste
    end
    if SECONDARYBASESTATS[3] ~= mastery then
      SECONDARYBASESTATS[3] = mastery
    end
    if SECONDARYBASESTATS[4] ~= multistrike then
      SECONDARYBASESTATS[4] = multistrike
    end
    if SECONDARYBASESTATS[5] ~= versatility then
      SECONDARYBASESTATS[5] = versatility
    end
  end
end

ProbablyEngine.library.register("NOC", NOC)
