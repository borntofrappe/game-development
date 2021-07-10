Timer = {}
Timer.__index = Timer

function Timer:new()
  local this = {
    ["delays"] = {},
    ["intervals"] = {}
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
end

return Timer:new()
