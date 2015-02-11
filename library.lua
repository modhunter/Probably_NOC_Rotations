local NOC = { }
local DSL = ProbablyEngine.dsl.get


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

-- return true when the rotation should be paused
function NOC.pause()
  if SpellIsTargeting()
    or (not UnitCanAttack("player", "target") and not UnitIsPlayer("target") and UnitExists("target"))
    --or UnitIsDeadOrGhost("player")
    or (UnitIsDeadOrGhost("target") and not UnitIsPlayer("target"))
    or UnitBuff("player",80169) -- Eating
    or UnitBuff("player",87959) -- Drinking
    or UnitBuff("target",104934) -- Eating
    or UnitBuff("player",11392) -- Invisibility
    or UnitBuff("player",9265) -- Deep Sleep(SM)
	then
		return true;
	else
		return false;
	end
end

-- thanks to CML for this routine
function NOC.isException(unit)
    if not unit then unit = "target" else unit = tostring(unit) end

    -- units to exempt
    local units = {
      -- TRAINING DUMMIES
      [31144] = true,		-- Training Dummy - Lvl 80
      [31146] = true,		-- Raider's Training Dummy - Lvl ??
      [32541] = true,		-- Initiate's Training Dummy - Lvl 55 (Scarlet Enclave)
      [32542] = true,		-- Disciple's Training Dummy - Lvl 65
      [32545] = true,		-- Initiate's Training Dummy - Lvl 55
      [32546] = true,		-- Ebon Knight's Training Dummy - Lvl 80
      [32666] = true,		-- Training Dummy - Lvl 60
      [32667] = true,		-- Training Dummy - Lvl 70
      [46647] = true,		-- Training Dummy - Lvl 85
      [60197] = true,		-- Scarlet Monastery Dummy
      [67127] = true,		-- Training Dummy - Lvl 90
      [87761] = true,		-- Dungeoneer's Training Dummy <Damage> HORDE GARRISON
      [88288] = true,		-- Dunteoneer's Training Dummy <Tanking> HORDE GARRISON
      [88289] = true,		-- Training Dummy <Healing> HORDE GARRISON
      [88314] = true,		-- Dungeoneer's Training Dummy <Tanking> ALLIANCE GARRISON
      [87322] = true,		-- Dungeoneer's Training Dummy <Tanking> (Stormshield)
      [88836] = true,		-- Dungeoneer's Training Dummy <Tanking> (Warspear)
      [88316] = true,		-- Training Dummy <Healing> ALLIANCE GARRISON
      [89078] = true,		-- Training Dummy (Garrison)
      [87318] = true,		-- Dungeoneer's Training Dummy <Damage>

      -- WOD DUNGEONS/RAIDS
      [71075] = true,		-- Small Illusionary Banshee (Proving Grounds)
      [75966] = true,		-- Defiled Spirit (Shadowmoon Burial Grounds)
      [76220] = true,		-- Blazing Trickster (Auchindoun Normal)
      [76267] = true,		-- Solar Zealot (Skyreach)
      [76518] = true,		-- Ritual of Bones (Shadowmoon Burial Grounds)
      [76598] = true,		-- Ritual of Bones?
      [79511] = true,		-- Blazing Trickster (Auchindoun Heroic)
      [81638] = true,		-- Aqueous Globule (The Everbloom)
      [153792] = true,	-- Rallying Banner (UBRS Black Iron Grunt)
      [76585] = true,		-- Ragewing <Boss in UBRS>
      [77252] = true,		-- Ore Crate (BRF Oregorger)
      [79504] = true,		-- Ore Crate (BRF Oregorger)
      [86644] = true,		-- Ore Crate (BRF Oregorger)
      [77891] = true,		-- Grasping Earth (BRF Kromog)
      [77893] = true,		-- Grasping Earth (BRF Kromog)
      [78583] = true,		-- Turrets (BRF Iron Maidens)
      [78584] = true,		-- Turrets (BRF Iron Maidens)
      [77665] = true,    -- Iron Bomber on blackhand
    }

    -- Fetch mob ID
    local _,_,_,_,_,mobID = strsplit("-", UnitGUID(unit))

    -- Compare
    if not not UnitExists(unit) and units[mobID] ~= nil then return true end
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

function NOC.autoTOD()
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
    --and not ProbablyEngine.condition["buff"]("player",121125)
    and ((math.floor((UnitHealth(unit)/UnitHealthMax(unit))*100) < 10) or (UnitHealth(unit) < UnitHealthMax("player")))
    and ProbablyEngine.condition["distance"](unit) <= 5
    and getCreatureType(unit)
    and NOC.immuneEvents(unit)
    and (UnitAffectingCombat(unit) or NOC.isException(unit))
    and IsSpellInRange(GetSpellInfo(115080), unit)
    then
      table.insert(targets, { Name = UnitName(unit), Unit = unit, HP = UnitHealth(unit), Range = ProbablyEngine.condition["distance"](unit) } )
    end
  end

  -- sort the qualified targets by health
  table.sort(targets, function(x,y) return x.HP > y.HP end)

  if #targets > 0 then
    print("Auto ToD candidate: "..targets[1].Unit..","..targets[1].Name..","..#targets)
    ProbablyEngine.dsl.parsedTarget = targets[1].Unit
    return true
  end
  return false
end

ProbablyEngine.library.register("NOC", NOC)
