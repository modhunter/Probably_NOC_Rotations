ProbablyEngine.condition.register("petinmelee", function(target)
   return (IsSpellInRange(GetSpellInfo(2649), target) == 1)
end)

ProbablyEngine.condition.register("modifier.enemies", function()
  local count = 0
  for _ in pairs(ProbablyEngine.module.combatTracker.enemy) do count = count + 1 end
  return count
end)

-- Implementing locally until it gets put into the engine
ProbablyEngine.condition.register("chidiff", function(target, spell)
    local max = UnitPowerMax(target, SPELL_POWER_CHI)
    local curr = UnitPower(target, SPELL_POWER_CHI)
    return (max - curr)
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

ProbablyEngine.timer.register("updateCTHealth", function()
  if not ProbablyEngine.module.combatTracker.combatCheck() then
    ProbablyEngine.module.combatTracker.cleanCT()
  end
end, 100)


ProbablyEngine.module.combatTracker.insert = function(guid, unitname, timestamp)
  if ProbablyEngine.module.combatTracker.enemy[guid] == nil then
    ProbablyEngine.module.combatTracker.enemy[guid] = { }
    ProbablyEngine.module.combatTracker.enemy[guid]['name'] = unitname
    ProbablyEngine.module.combatTracker.enemy[guid]['time'] = false
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
