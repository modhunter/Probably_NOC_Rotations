local NOC = { }
local DSL = ProbablyEngine.dsl.get

NOC.items = { }
NOC.flagged = GetTime()
NOC.unflagged = GetTime()
NOC.queueSpell = nil
NOC.queueTime = 0
NOC.sefUnits = {}
NOC.lastSEFCount = 0
NOC.lastSEFTarget = nil
NOC.HMDelay = nil
NOC.HMTargetGUID = nil

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
-- Toggle -------------------------------------------------------------------------------------------------------
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


NOC.setFlagged = function (self, ...)
  NOC.flagged = GetTime()
end


NOC.setUnflagged = function (self, ...)
  NOC.unflagged = GetTime()
  if NOC.items[77589] then
    NOC.items[77589].exp = NOC.unflagged + 60
  end
end


NOC.eventHandler = function(self, ...)
  local subEvent		= select(1, ...)
  local source		= select(4, ...)
  local destGUID		= select(7, ...)
  local spellID		= select(11, ...)
  local failedType = select(14, ...)
  if UnitName("player") == source then
    if subEvent == "SPELL_CAST_SUCCESS" then
      if spellID == 5512 then -- Healthstone
        NOC.items[5512] = { lastCast = GetTime() }
      end
      if spellID == 124199 then -- Landshark (itemId 77589)
        NOC.items[77589] = { lastCast = GetTime(), exp = 0 }
      end
    end
  end
end


ProbablyEngine.listener.register("NOC", "COMBAT_LOG_EVENT_UNFILTERED", NOC.eventHandler)
ProbablyEngine.listener.register("NOC", "PLAYER_REGEN_DISABLED", NOC.setFlagged)
ProbablyEngine.listener.register("NOC", "PLAYER_REGEN_DISABLED", NOC.resetLists)
ProbablyEngine.listener.register("NOC", "PLAYER_REGEN_DISABLED", NOC.setUnflagged)
ProbablyEngine.listener.register("NOC", "PLAYER_REGEN_ENABLED", NOC.resetLists)


function NOC.spellCooldown(spell)
  local spellName = GetSpellInfo(spell)
  if spellName then
    local spellCDstart,spellCDduration,_ = GetSpellCooldown(spellName)
    if spellCDduration == 0 then
      return 0
    elseif spellCDduration > 0 then
      local spellCD = spellCDstart + spellCDduration - GetTime()
      return spellCD
    end
  end
  return 0
end


function NOC.fillBlackout()
  local energy = UnitPower("player")
  local regen = select(2, GetPowerRegen("player"))
  local start, duration, enabled = GetSpellCooldown(107428)
  if not start then return false end
  if start ~= 0 then
    local remains = start + duration - GetTime()
    return (energy + regen * remains) >= 40
  end
  return 0
end


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

-- TODO: Deprecated, should remove
function NOC.SEF()
  if (UnitGUID('target') ~= nil) then
	  local count = DSL('buff.count')('player', '137639')
	  if count > NOC.lastSEFCount and NOC.lastSEFTarget then
		NOC.sefUnits[NOC.lastSEFTarget], NOC.lastSEFCount, NOC.lastSEFTarget = true, count, nil
	  end
	  if count < 2 and DSL('enemy')('mouseover') then
		local mouseover, target = UnitGUID('mouseover'), UnitGUID('target')
		if mouseover and target ~= mouseover and not NOC.sefUnits[mouseover] then
		  NOC.lastSEFTarget = mouseover
		  return true
		end
	  end
	  if (count == 0) then
		NOC.sefUnits, NOC.lastSEFCount, NOC.lastSEFTarget = {}, 0, nil
	  end
  end
  return false
end

function NOC.cancelSEF()
  if DSL('buff')('player', '137639') then
     --and DSL('modifier.enemies')() < 2 then
    NOC.sefUnits, NOC.lastSEFCount, NOC.lastSEFTarget = {}, 0, nil
    return true
  end
  return false
end

-- Props to MrTheSoulz for this code: Check Mouseover and target are not equal
function NOC.mouseNotEqualTarget()
   if (UnitGUID('target')) ~= (UnitGUID('mouseover')) then return true end
 return false
end

--Props to MrTheSoulz for this code:  Check Mouseover and target are equal
function NOC.mouseEqualTarget()
   if (UnitGUID('target')) ~= (UnitGUID('mouseover')) then return false end
 return true
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
	if (IsMounted() and getUnitID("target") ~= 56877)
		or SpellIsTargeting()
		or (not UnitCanAttack("player", "target") and not UnitIsPlayer("target") and UnitExists("target"))
		or UnitCastingInfo("player")
		or UnitChannelInfo("player")
		or UnitIsDeadOrGhost("player")
		or (UnitIsDeadOrGhost("target") and not UnitIsPlayer("target"))
		or UnitBuff("player",80169) -- Eating
		or UnitBuff("player",87959) -- Drinking
		or UnitBuff("target",104934) --Eating
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

ProbablyEngine.library.register("NOC", NOC)
