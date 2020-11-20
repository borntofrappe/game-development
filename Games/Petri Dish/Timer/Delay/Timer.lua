Timer = {}
Timer.__index = Timer

function Timer:new()
  this = {
    ["delays"] = {}
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

function Timer:update(dt)
  for i, delay in ipairs(self.delays) do
    delay.timer = delay.timer + dt
    if delay.timer >= delay.dt then
      delay.callback()
      table.remove(self.delays, i)
    end
  end
end

return Timer:new()
