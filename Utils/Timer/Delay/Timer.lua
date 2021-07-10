Timer = {}
Timer.__index = Timer

function Timer:new()
  local this = {
    ["delays"] = {}
  }

  setmetatable(this, self)
  return this
end

function Timer:after(dt, callback)
  local delay = {
    ["timer"] = 0,
    ["dt"] = dt,
    ["callback"] = callback
  }

  table.insert(self.delays, delay)
end

function Timer:update(dt)
  for k, delay in pairs(self.delays) do
    delay.timer = delay.timer + dt
    if delay.timer >= delay.dt then
      delay.callback()
      table.remove(self.delays, k)
    end
  end
end

return Timer:new()
