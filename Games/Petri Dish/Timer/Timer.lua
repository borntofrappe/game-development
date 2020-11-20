Timer = {}
Timer.__index = Timer

function Timer:new()
  this = {
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

function Timer:tween()
  -- ???
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
end

function Timer:reset()
  self.delays = {}
  self.intervals = {}
end

return Timer:new()
