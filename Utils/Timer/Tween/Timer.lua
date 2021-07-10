Timer = {}
Timer.__index = Timer

function Timer:new()
  local this = {
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

function Timer:every(dt, callback, label)
  local interval = {
    ["timer"] = 0,
    ["dt"] = dt,
    ["callback"] = callback,
    ["label"] = label
  }

  table.insert(self.intervals, interval)
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
  for k, delay in pairs(self.delays) do
    delay.timer = delay.timer + dt
    if delay.timer >= delay.dt then
      delay.callback()
      table.remove(self.delays, k)
    end
  end

  for k, interval in pairs(self.intervals) do
    interval.timer = interval.timer + dt
    if interval.timer >= interval.dt then
      interval.callback()
      interval.timer = interval.timer % interval.dt
    end
  end

  for k, tween in pairs(self.tweens) do
    tween.timer = tween.timer + dt
    for j, definition in pairs(tween.def) do
      for k, keyValuePair in pairs(definition.keyValuePairs) do
        definition.ref[keyValuePair.key] = definition.ref[keyValuePair.key] + keyValuePair.change * dt
      end
    end

    if tween.timer >= tween.dt then
      for j, definition in pairs(tween.def) do
        for k, keyValuePair in pairs(definition.keyValuePairs) do
          definition.ref[keyValuePair.key] = keyValuePair.value
        end
      end
      table.remove(self.tweens, k)
    end
  end
end

function Timer:remove(label)
  for k, delay in pairs(self.delays) do
    if delay.label == label then
      return table.remove(self.delays, k)
    end
  end

  for k, interval in pairs(self.intervals) do
    if interval.label == label then
      return table.remove(self.intervals, k)
    end
  end

  for k, tween in pairs(self.tweens) do
    if tween.label == label then
      return table.remove(self.tweens, k)
    end
  end
end

function Timer:reset()
  self.delays = {}
  self.intervals = {}
  self.tweens = {}
end

return Timer:new()
