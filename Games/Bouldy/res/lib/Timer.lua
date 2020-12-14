Timer = {}
Timer.__index = Timer

function Timer:new()
  this = {
    ["delays"] = {},
    ["intervals"] = {},
    ["tweens"] = {}
  }

  setmetatable(this, self)
  return this
end

function Timer:after(dt, callback, label)
  local delay = {
    ["timer"] = 0,
    ["dt"] = dt,
    ["callback"] = callback,
    ["label"] = label
  }

  table.insert(self.delays, delay)
end

function Timer:every(dt, callback, isImmediate, label)
  local interval = {
    ["timer"] = 0,
    ["dt"] = dt,
    ["callback"] = callback,
    ["label"] = label
  }

  table.insert(self.intervals, interval)

  if isImmediate then
    callback()
  end
end

function Timer:tween(dt, def, label)
  local tween = {
    ["timer"] = 0,
    ["dt"] = dt,
    ["def"] = {},
    ["label"] = label
  }

  for ref, keyValuePairs in pairs(def) do
    local definition = {
      ["ref"] = ref,
      ["keyValuePairs"] = {}
    }
    for key, value in pairs(keyValuePairs) do
      local keyValuePair = {
        ["key"] = key,
        ["value"] = value,
        ["change"] = (value - ref[key]) / dt
      }
      table.insert(definition.keyValuePairs, keyValuePair)
    end

    table.insert(tween.def, definition)
  end

  table.insert(self.tweens, tween)
end

function Timer:update(dt)
  for i, delay in ipairs(self.delays) do
    delay.timer = delay.timer + dt
    if delay.timer >= delay.dt then
      delay.callback()
      table.remove(self.delays, i)
    end
  end

  for i, interval in ipairs(self.intervals) do
    interval.timer = interval.timer + dt
    if interval.timer >= interval.dt then
      interval.timer = 0
      interval.callback()
    end
  end

  for i, tween in ipairs(self.tweens) do
    tween.timer = tween.timer + dt
    for j, definition in ipairs(tween.def) do
      for k, keyValuePair in ipairs(definition.keyValuePairs) do
        definition.ref[keyValuePair.key] = definition.ref[keyValuePair.key] + keyValuePair.change * dt
      end
    end

    if tween.timer >= tween.dt then
      for j, definition in ipairs(tween.def) do
        for k, keyValuePair in ipairs(definition.keyValuePairs) do
          definition.ref[keyValuePair.key] = keyValuePair.value
        end
      end
      table.remove(self.tweens, i)
    end
  end
end

function Timer:remove(label)
  for i, delays in ipairs(self.delays) do
    if delays.label == label then
      return table.remove(self.delays, i)
    end
  end

  for i, interval in ipairs(self.intervals) do
    if interval.label == label then
      return table.remove(self.intervals, i)
    end
  end

  for i, tween in ipairs(self.tweens) do
    if tween.label == label then
      return table.remove(self.tweens, i)
    end
  end
end

function Timer:reset()
  self.delays = {}
  self.intervals = {}
  self.tweens = {}
end

return Timer:new()
