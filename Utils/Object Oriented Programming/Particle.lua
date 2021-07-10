Particle = {}

local GRAVITY = 5

function Particle:new(x, y)
  local this = {
    ["x"] = x,
    ["y"] = y,
    ["dy"] = 0
  }

  self.__index = self
  setmetatable(this, self)
  return this
end

function Particle:update(dt)
  self.y = self.y + self.dy
  self.dy = self.dy + GRAVITY * dt
end

function Particle:render()
end
