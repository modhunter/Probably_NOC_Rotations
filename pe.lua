ProbablyEngine.condition.register("petinmelee", function(target)
   return (IsSpellInRange(GetSpellInfo(2649), target) == 1)
end)

ProbablyEngine.condition.register("modifier.enemies", function()
  local count = 0
  for _ in pairs(ProbablyEngine.module.combatTracker.enemy) do count = count + 1 end
  return count
end)

-- Returns the number of chi you have left till max (e.g. you have a max of 5 chi and 3 chi now, so it will return 2)
ProbablyEngine.condition.register("chidiff", function(target, spell)
    local max = UnitPowerMax(target, SPELL_POWER_CHI)
    local curr = UnitPower(target, SPELL_POWER_CHI)
    return (max - curr)
end)

ProbablyEngine.condition.register("cc", function(target)
  if not UnitExists(target) then
    return false
  else
    if SpecialAurasCheck(target) then
      return true
    else
      return false
    end
  end
end)

ProbablyEngine.condition.register("focus.deficit", function(target)
  local max_power = UnitPowerMax(target)
  local cur_power = UnitPower(target)
  return max_power - cur_power
end)

ProbablyEngine.condition.register("anystats.proc", function(target, spell)
  -- Check Primary Stats
  for i=1, 5 do
    local stat = UnitStat("player", i)
    if stat > PRIMARYBASESTATS[i] then
      return true
    end
  end
  -- Check Secondary Stats
  local crit = GetCritChance()
  local haste = GetHaste()
  local mastery = GetMastery()
  local multistrike = GetMultistrike()
  local versatility = GetCombatRating(29)

  if crit > SECONDARYSTATSTABLE[1] then
    return true
  end
  if haste > SECONDARYSTATSTABLE[2] then
    return true
  end
  if mastery > SECONDARYSTATSTABLE[3] then
    return true
  end
  if multistrike > SECONDARYSTATSTABLE[4] then
    return true
  end
  if versatility > SECONDARYSTATSTABLE[5] then
    return true
  end

  return false
end)

ProbablyEngine.condition.register("strength.proc", function(target, spell)
  local stat = UnitStat("player", 1)

  if stat > PRIMARYBASESTATS[1] then
    return true
  else
    return false
  end
end)

ProbablyEngine.condition.register("agility.proc", function(target, spell)
  local stat = UnitStat("player", 2)

  if stat > PRIMARYBASESTATS[2] then
    return true
  else
    return false
  end
end)

ProbablyEngine.condition.register("stamina.proc", function(target, spell)
  local stat = UnitStat("player", 3)

  if stat > PRIMARYBASESTATS[3] then
    return true
  else
    return false
  end
end)

ProbablyEngine.condition.register("intellect.proc", function(target, spell)
  local stat = UnitStat("player", 4)

  if stat > PRIMARYBASESTATS[4] then
    return true
  else
    return false
  end
end)

ProbablyEngine.condition.register("spirit.proc", function(target, spell)
  local stat = UnitStat("player", 5)

  if stat > PRIMARYBASESTATS[5] then
    return true
  else
    return false
  end
end)

ProbablyEngine.condition.register("crit.proc", function(target, spell)
  local crit = GetCritChance()

  if crit > SECONDARYBASESTATS[1] then
    return true
  else
    return false
  end
end)

ProbablyEngine.condition.register("haste.proc", function(target, spell)
  local haste = GetHaste()

  if haste > SECONDARYBASESTATS[2] then
    return true
  else
    return false
  end
end)

ProbablyEngine.condition.register("mastery.proc", function(target, spell)
  local mastery = GetMastery()

  if mastery > SECONDARYBASESTATS[3] then
    return true
  else
    return false
  end
end)

ProbablyEngine.condition.register("multistrike.proc", function(target, spell)
  local multistrike = GetMultistrike()

  if multistrike > SECONDARYBASESTATS[4] then
    return true
  else
    return false
  end
end)

ProbablyEngine.condition.register("versatility.proc", function(target, spell)
  local versatility = GetCombatRating(29)

  if versatility > SECONDARYBASESTATS[5] then
    return true
  else
    return false
  end
end)

ProbablyEngine.condition.register("power.regen", function(target)
  return select(2, GetPowerRegen(target))
end)

ProbablyEngine.condition.register("spell.regen", function(target, spell)
  local name, rank, icon, cast_time, min_range, max_range = GetSpellInfo(spell)
  if cast_time == 0 then
    cast_time = 1
  end
  local cur_regen = select(2, GetPowerRegen(target))
  local cast_time_in_seconds = cast_time / 1000.0

  return cast_time_in_seconds * cur_regen
end)

ProbablyEngine.condition.register("gcd", function(target)
  local gcd = (1.5/GetHaste(target))
  if gcd < 1 then
    return 1
  else
    return gcd
  end
end)

-- Implementing native API combat tracker for # of enemies
local band = bit.band

local HostileEvents = {
        ['SWING_DAMAGE'] = true,
        ['SWING_MISSED'] = true,
        ['RANGE_DAMAGE'] = true,
        ['RANGE_MISSED'] = true,
        ['SPELL_DAMAGE'] = true,
        ['SPELL_PERIODIC_DAMAGE'] = true,
        ['SPELL_MISSED'] = true
}

ProbablyEngine.listener.register("COMBAT_LOG_EVENT_UNFILTERED", function(...)
  local timeStamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, _ = ...
  if sourceName and destName and sourceName ~= '' and destName ~= '' then
    if HostileEvents[event] then
      if band(destFlags, COMBATLOG_OBJECT_AFFILIATION_OUTSIDER) == 0 and band(sourceFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) == 0 then
        ProbablyEngine.module.combatTracker.tagUnit(sourceGUID, sourceName, timeStamp)
      elseif band(sourceFlags, COMBATLOG_OBJECT_AFFILIATION_OUTSIDER) == 0 and band(destFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) == 0 then
        ProbablyEngine.module.combatTracker.tagUnit(destGUID, destName, timeStamp)
      end
    end
  elseif (event == 'UNIT_DIED' or event == 'UNIT_DESTROYED' or event == 'UNIT_DISSIPATES') then
    ProbablyEngine.module.combatTracker.killUnit(destGUID)
  end
end)

ProbablyEngine.module.register("combatTracker", {
  current = 0,
  expire = 15,
  friendly = { },
  enemy = { },
  dead = { },
  named = { },
  blacklist = { },
  healthCache = { },
  healthCacheCount = { },
  units = { },
})

-- TODO: merge this with aquireRange so we accomplish both in the same function
ProbablyEngine.module.combatTracker.aquireHealth = function(guid, maxHealth, name)
  if maxHealth then health = UnitHealthMax else health = UnitHealth end
  local inGroup = GetNumGroupMembers()
  if inGroup then
    if IsInRaid("player") then
      for i=1,inGroup do
        if guid == UnitGUID("RAID".. i .. "TARGET") then
          return health("RAID".. i .. "TARGET")
        end
      end
    else
      for i=1,inGroup do
        if guid == UnitGUID("PARTY".. i .. "TARGET") then
          return health("PARTY".. i .. "TARGET")
        end
      end
      if guid == UnitGUID("PLAYERTARGET") then
        return health("PLAYERTARGET")
      end
    end
  else
    print(guid, UnitGUID("PLAYERTARGET"))
    if guid == UnitGUID("PLAYERTARGET") then
      return health("PLAYERTARGET")
    end
    if guid == UnitGUID("MOUSEOVER") then
      return health("MOUSEOVER")
    end
  end
  -- All health checks failed, do we have a cache of this units health ?
  if maxHealth then
    if ProbablyEngine.module.combatTracker.healthCache[name] ~= nil then
      return ProbablyEngine.module.combatTracker.healthCache[name]
    end
  end
  return false
end

ProbablyEngine.module.combatTracker.aquireRange = function(guid)
  range = ProbablyEngine.condition["distance"]
  local inGroup = GetNumGroupMembers()
  if inGroup then
    if IsInRaid("player") then
      for i=1,inGroup do
        if guid == UnitGUID("RAID".. i .. "TARGET") then
          return range("RAID".. i .. "TARGET")
        end
      end
    else
      for i=1,inGroup do
        if guid == UnitGUID("PARTY".. i .. "TARGET") then
          return range("PARTY".. i .. "TARGET")
        end
      end
      if guid == UnitGUID("PLAYERTARGET") then
        return range("PLAYERTARGET")
      end
    end
  else
    print(guid, UnitGUID("PLAYERTARGET"))
    if guid == UnitGUID("PLAYERTARGET") then
      return range("PLAYERTARGET")
    end
    if guid == UnitGUID("MOUSEOVER") then
      return range("MOUSEOVER")
    end
  end
  return false
end

ProbablyEngine.module.combatTracker.combatCheck = function()
  local inGroup = GetNumGroupMembers()
  local inCombat = false
  if inGroup then
    if IsInRaid("player") then
      for i = 1, inGroup do
        if UnitAffectingCombat("RAID".. i) then return true end
      end
    else
      for i = 1, inGroup do
        if UnitAffectingCombat("PARTY".. i) then return true end
      end
    end
    if UnitAffectingCombat("PLAYER") then return true end
  else
    if UnitAffectingCombat("PLAYER") then return true end
  end
  return false
end

-- TODO: rename this to just updateCT
ProbablyEngine.timer.register("updateCTHealth", function()
  if ProbablyEngine.module.combatTracker.combatCheck() then
    for guid,table in pairs(ProbablyEngine.module.combatTracker.enemy) do
      local health = ProbablyEngine.module.combatTracker.aquireHealth(guid)
      if health then
        -- attempt to aquire max health again
        if ProbablyEngine.module.combatTracker.enemy[guid]['maxHealth'] == false then
          local name = ProbablyEngine.module.combatTracker.enemy[guid]['name']
          ProbablyEngine.module.combatTracker.enemy[guid]['maxHealth'] = ProbablyEngine.module.combatTracker.           aquireHealth(guid, true, name)
        end
        ProbablyEngine.module.combatTracker.enemy[guid].health = health
      end
      local range = ProbablyEngine.module.combatTracker.aquireRange(guid)
      if range then
        ProbablyEngine.module.combatTracker.enemy[guid].range = range
      end
    end
  else
    ProbablyEngine.module.combatTracker.cleanCT()
  end
end, 100)


ProbablyEngine.module.combatTracker.insert = function(guid, unitname, timestamp)
  if ProbablyEngine.module.combatTracker.enemy[guid] == nil then

    local maxHealth = ProbablyEngine.module.combatTracker.aquireHealth(guid, true, unitname)
    local health = ProbablyEngine.module.combatTracker.aquireHealth(guid)
    local range = ProbablyEngine.module.combatTracker.aquireRange(guid)

    ProbablyEngine.module.combatTracker.enemy[guid] = { }
    ProbablyEngine.module.combatTracker.enemy[guid]['maxHealth'] = maxHealth
    ProbablyEngine.module.combatTracker.enemy[guid]['health'] = health
    ProbablyEngine.module.combatTracker.enemy[guid]['range'] = range
    ProbablyEngine.module.combatTracker.enemy[guid]['name'] = unitname
    ProbablyEngine.module.combatTracker.enemy[guid]['time'] = false
    ProbablyEngine.module.combatTracker.enemy[guid]['guid'] = guid

    if maxHealth then
      -- we got a health value from aquire, store it for later usage
      if ProbablyEngine.module.combatTracker.healthCacheCount[unitname] then
        -- we've alreadt seen this type, average it
        local currentAverage = ProbablyEngine.module.combatTracker.healthCache[unitname]
        local currentCount = ProbablyEngine.module.combatTracker.healthCacheCount[unitname]
        local newAverage = (currentAverage + maxHealth) / 2
        ProbablyEngine.module.combatTracker.healthCache[unitname] = newAverage
        ProbablyEngine.module.combatTracker.healthCacheCount[unitname] = currentCount + 1
      else
        -- this is new to use, save it
        ProbablyEngine.module.combatTracker.healthCache[unitname] = maxHealth
        ProbablyEngine.module.combatTracker.healthCacheCount[unitname] = 1
      end
    end
  end
end

ProbablyEngine.module.combatTracker.cleanCT = function()
  -- clear tables but save the memory
  for k,_ in pairs(ProbablyEngine.module.combatTracker.enemy) do
    ProbablyEngine.module.combatTracker.enemy[k] = nil
  end
  for k,_ in pairs(ProbablyEngine.module.combatTracker.blacklist) do
    ProbablyEngine.module.combatTracker.blacklist[k] = nil
  end
end

ProbablyEngine.module.combatTracker.remove = function(guid)
  ProbablyEngine.module.combatTracker.enemy[guid] = nil
end

ProbablyEngine.module.combatTracker.tagUnit = function(guid, name)
  if not ProbablyEngine.module.combatTracker.blacklist[guid] then
    ProbablyEngine.module.combatTracker.insert(guid, name)
  end
end

ProbablyEngine.module.combatTracker.killUnit = function(guid)
  ProbablyEngine.module.combatTracker.remove(guid, name)
  ProbablyEngine.module.combatTracker.blacklist[guid] = true
end
