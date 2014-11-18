local NOC = { }
local DSL = ProbablyEngine.dsl.get

NOC.items = { }
NOC.flagged = GetTime()
NOC.unflagged = GetTime()
NOC.queueSpell = nil
NOC.queueTime = 0

------------------------------------
--TODO: replace all of following messaging and queuing logic below with the new 'UI' - look at MrTheSoulz for examples
------------------------------------
-- Props for Chumii for all of the messaging and toggle code below
local function onUpdate(self,elapsed)
   if self.time < GetTime() - 2.5 then
      if self:GetAlpha() == 0 then self:Hide() else self:SetAlpha(self:GetAlpha() - .05) end
      end
end
mww = CreateFrame("Frame",nil,ChatFrame1)
mww:SetSize(ChatFrame1:GetWidth(),30)
mww:Hide()
mww:SetScript("OnUpdate",onUpdate)
mww:SetPoint("TOPLEFT",0,150)
mww.text = mww:CreateFontString(nil,"OVERLAY","MovieSubtitleFont")
mww.text:SetAllPoints()
mww.texture = mww:CreateTexture()
mww.texture:SetAllPoints()
mww.texture:SetTexture(0,0,0,.50)
mww.time = 0
function mww:message(message)
   self.text:SetText(message)
   self:SetAlpha(1)
   self.time = GetTime()
   self:Show()
end


------- "/mWW" handling ------
ProbablyEngine.command.register('mWW', function(msg, box)
  local command, text = msg:match("^(%S*)%s*(.-)$")

  if command == 'toggle' then
    if ProbablyEngine.config.read('button_states', 'MasterToggle', false) then
        ProbablyEngine.buttons.toggle('MasterToggle')
        mww:message("|cFFB30000NOC off")
    else
        ProbablyEngine.buttons.toggle('MasterToggle')
        mww:message("|cFF00B34ANOC on")
    end
  end
  if command == 'kick' then
    if ProbablyEngine.config.read('button_states', 'interrupt', false) then
      ProbablyEngine.buttons.toggle('interrupt')
      mww:message("|cFFB30000Interrupts off")
    else
      ProbablyEngine.buttons.toggle('interrupt')
      mww:message("|cFF00B34AInterrupts on")
    end
  end

  if command == 'cds' then
    if ProbablyEngine.config.read('button_states', 'cooldowns', false) then
      ProbablyEngine.buttons.toggle('cooldowns')
      mww:message("|cFFB30000Xuen off")
    else
      ProbablyEngine.buttons.toggle('cooldowns')
      mww:message("|cFF00B34AXuen on")
    end
  end

  if command == 'aoe' then
    if ProbablyEngine.config.read('button_states', 'multitarget', false) then
      ProbablyEngine.buttons.toggle('multitarget')
      mww:message("|cFFB30000AoE off")
    else
      ProbablyEngine.buttons.toggle('multitarget')
      mww:message("|cFF00B34AAoE on")
    end
  end

  if command == 'chistacker' then
    if ProbablyEngine.config.read('button_states', 'chistacker', false) then
      ProbablyEngine.buttons.toggle('chistacker')
      mww:message("|cFFB30000Auto Chi Stacking off")
    else
      ProbablyEngine.buttons.toggle('chistacker')
      mww:message("|cFF00B34AAuto Chi Stacking on")
    end
  end

  if command == 'autosef' then
    if ProbablyEngine.config.read('button_states', 'autosef', false) then
      ProbablyEngine.buttons.toggle('autosef')
      mww:message("|cFFB30000Automatic SE&F Mouseover off")
    else
      ProbablyEngine.buttons.toggle('autosef')
      mww:message("|cFF00B34AAutomatic SE&F Mouseover on")
    end
  end

  if command == "qKarma" or command == 122470 then
    NOC.queueSpell = 122470 -- Touch of Karma
    mww.message("Touch of Karma queued")
  elseif command == "qLust" or command == 116841 then
    NOC.queueSpell = 116841 -- Tiger's Lust
    mww.message("Tger's Lust queued")
  elseif command == "qTfour" then
    if select(2,GetTalentRowSelectionInfo(4)) == 10 then
        NOC.queueSpell = 116844 -- Ring of Peace
        mww.message("Ring of Peace queued")
    elseif select(2,GetTalentRowSelectionInfo(4)) == 11 then
        NOC.queueSpell = 119392 -- Charging Ox Wave
        mww.message("Charging Ox Wave queued")
    elseif select(2,GetTalentRowSelectionInfo(4)) == 12 then
        NOC.queueSpell = 119381 -- Leg Sweep
        mww.message("Leg Sweep queued")
    end
  elseif command == "qTfive" then
    if select(2,GetTalentRowSelectionInfo(5)) == 14 then
        NOC.queueSpell = 122278 -- Dampen Harm
        mww.message("Dampen Harm queued")
    elseif select(2,GetTalentRowSelectionInfo(5)) == 15 then
        NOC.queueSpell = 122783 -- Diffuse Magic
        mww.message("Diffuse Magic queued")
    end
  else
    NOC.queueSpell = nil
  end
  if NOC.queueSpell ~= nil then NOC.queueTime = GetTime() end
end)


------- "/mBM" handling ------
ProbablyEngine.command.register('mBM', function(msg, box)
  local command, text = msg:match("^(%S*)%s*(.-)$")
  if command == 'toggle' then
    if ProbablyEngine.config.read('button_states', 'MasterToggle', false) then
        ProbablyEngine.buttons.toggle('MasterToggle')
        mww:message("|cFFB30000Into the Brew off")
    else
        ProbablyEngine.buttons.toggle('MasterToggle')
        mww:message("|cFF00B34AInto the Brew on")
    end
  end
  if command == 'kick' then
    if ProbablyEngine.config.read('button_states', 'interrupt', false) then
      ProbablyEngine.buttons.toggle('interrupt')
      mww:message("|cFFB30000Interrupts off")
    else
      ProbablyEngine.buttons.toggle('interrupt')
      mww:message("|cFF00B34AInterrupts on")
    end
  end

  if command == 'xuen' then
    if ProbablyEngine.config.read('button_states', 'cooldowns', false) then
      ProbablyEngine.buttons.toggle('cooldowns')
      mww:message("|cFFB30000Xuen off")
    else
      ProbablyEngine.buttons.toggle('cooldowns')
      mww:message("|cFF00B34AXuen on")
    end
  end

  if command == 'aoe' then
    if ProbablyEngine.config.read('button_states', 'multitarget', false) then
      ProbablyEngine.buttons.toggle('multitarget')
      mww:message("|cFFB30000AoE off")
    else
      ProbablyEngine.buttons.toggle('multitarget')
      mww:message("|cFF00B34AAoE on")
    end
  end

  if command == 'taunt' then
    if ProbablyEngine.config.read('button_states', 'taunt', false) then
      ProbablyEngine.buttons.toggle('taunt')
      mww:message("|cFFB30000SoO Auto Taunt off")
    else
      ProbablyEngine.buttons.toggle('taunt')
      mww:message("|cFF00B34ASoO Auto Taunt on")
    end
  end

  if command == 'def' then
    if ProbablyEngine.config.read('button_states', 'def', false) then
      ProbablyEngine.buttons.toggle('def')
      mww:message("|cFFB30000Defensive Cooldowns off")
    else
      ProbablyEngine.buttons.toggle('def')
      mww:message("|cFF00B34ADefensive Cooldowns on")
    end
  end

  if command == 'ksmash' then
    if ProbablyEngine.config.read('button_states', 'kegsmash', false) then
      ProbablyEngine.buttons.toggle('kegsmash')
      mww:message("|cFFB30000Keg Smash off")
    else
      ProbablyEngine.buttons.toggle('kegsmash')
      mww:message("|cFF00B34AKeg Smash on")
    end
  end

-- Spell Queue -- thank you merq for basic code --------------------------------------------------------------------
  if command == "qGuard" or command == 123402 then
    NOC.queueSpell = 123402
    mww:message("Guard queued")
  elseif command == "qBrew" or command == 115203 then
    NOC.queueSpell = 115203
    mww:message("Fortifying Brew queued")
  elseif command == "qZen" or command == 115176 then
    NOC.queueSpell = 115176
    mww:message("Zen Meditation queued")
  elseif command == "qPara" or command == 115078 then
    NOC.queueSpell = 115078
    mww:message("Paralysis (mouseover) queued")
  elseif command == "qOx" or command == 115315 then
    NOC.queueSpell = 115315
    mww:message("Statue of the Ox queued")
  elseif command == "qTfour" then
    if select(2,GetTalentRowSelectionInfo(4)) == 10 then
        NOC.queueSpell = 116844
        mww:message("Ring of Peace queued")
    elseif select(2,GetTalentRowSelectionInfo(4)) == 11 then
        NOC.queueSpell = 119392
        mww:message("Charging Ox Wave queued")
    elseif select(2,GetTalentRowSelectionInfo(4)) == 12 then
        NOC.queueSpell = 119381
        mww:message("Leg Sweep queued")
    end
  elseif command == "qTfive" then
    if select(2,GetTalentRowSelectionInfo(5)) == 14 then
        NOC.queueSpell = 122278
        mww:message("Dampen Harm queued")
    elseif select(2,GetTalentRowSelectionInfo(5)) == 15 then
        NOC.queueSpell = 122783
        mww:message("Diffuse Magic queued")
    end
  else
    NOC.queueSpell = nil
  end
  if NOC.queueSpell ~= nil then NOC.queueTime = GetTime() end
end)

NOC.checkQueue = function (spellId)
    if (GetTime() - NOC.queueTime) > 10 then
        NOC.queueTime = 0
        NOC.queueSpell = nil
    return false
    else
    if NOC.queueSpell then
        if NOC.queueSpell == spellId then
            if ProbablyEngine.parser.lastCast == GetSpellName(spellId) then
                NOC.queueSpell = nil
                NOC.queueTime = 0
            end
        return true
        end
    end
    end
    return false
end
------------------------------------



-- TODO: clean-up this function and update for WoD wher enecessary
function NOC.immuneEvents(unit)
  if NOC.isDummy(unit) then return true end
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
  }
  if NOC.hasDebuffTable(unit, cc) then return false end
  if UnitAura(unit,GetSpellInfo(116994))
		or UnitAura(unit,GetSpellInfo(122540))
		or UnitAura(unit,GetSpellInfo(123250))
		or UnitAura(unit,GetSpellInfo(106062))
		or UnitAura(unit,GetSpellInfo(110945))
		or UnitAura(unit,GetSpellInfo(143593)) -- General Nazgrim: Defensive Stance
    or UnitAura(unit,GetSpellInfo(143574)) -- Heroic Immerseus: Swelling Corruption
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
function getCreatureType(Unit)
   local CreatureTypeList = {"Critter", "Totem", "Non-combat Pet", "Wild Pet"}
   for i=1, #CreatureTypeList do
      if UnitCreatureType(Unit) == CreatureTypeList[i]
      then
        return false
      end
   end
   if UnitIsBattlePet(Unit) and UnitIsWildBattlePet(Unit)
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
	if (IsMounted() and ((getUnitID("target") ~= 56877) or (UnitBuffID("player",164222) == nil) or (UnitBuffID("player",165803) == nil)))
    or SpellIsTargeting()
    or UnitInVehicle("Player")
    or (not UnitCanAttack("player", "target") and not UnitIsPlayer("target") and UnitExists("target"))
    or UnitCastingInfo("player")
    or UnitChannelInfo("player")
    or UnitIsDeadOrGhost("player")
    or (UnitIsDeadOrGhost("target") and not UnitIsPlayer("target"))
    or UnitBuff("player",80169) -- Eating
    or UnitBuff("player",87959) -- Drinking
    or UnitBuff("target",104934) --Eating
    or UnitBuffID("player",11392)
    or UnitBuffID("player",9265) -- Deep Sleep(SM)
	then
		return true;
	else
		return false;
	end
end

function NOC.isInCombat(Unit)
  if UnitAffectingCombat(Unit) then return true; else return false; end
end

-- thanks to CML for this routine
function NOC.isDummy(Unit)
	if Unit == nil then Unit = "target"; else Unit = tostring(Unit) end
    dummies = {
        31144, --Training Dummy - Lvl 80
        --31146, --Raider's Training Dummy - Lvl ??
        32541, --Initiate's Training Dummy - Lvl 55 (Scarlet Enclave)
        32542, --Disciple's Training Dummy - Lvl 65
        32545, --Initiate's Training Dummy - Lvl 55
        32546, --Ebon Knight's Training Dummy - Lvl 80
        32666, --Training Dummy - Lvl 60
        32667, --Training Dummy - Lvl 70
        46647, --Training Dummy - Lvl 85
        60197, --Scarlet Monastery Dummy
        67127, --Training Dummy - Lvl 90
        87761, --Dungeoneer's Training Dummy <Damage>
        88314, --Dungeoneer's Training Dummy <Tanking>
        88316, --Training Dummy <Healing>
        89078, --Training Dummy (Garrison)
        87318 --Dungeoneer's Training Dummy <Damage>
    }
    for i=1, #dummies do
        if UnitExists(Unit) and UnitGUID(Unit) then
            dummyID = tonumber(string.match(UnitGUID(Unit), "-(%d+)-%x+$"))
        else
            dummyID = 0
        end
        if dummyID == dummies[i] then
            return true
        end
    end
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

function NOC.isAttackingPlayer()
  if ( UnitIsUnit("targettarget", "player") ) then
    return true
  else
    return false
  end
end

ProbablyEngine.library.register("NOC", NOC)
