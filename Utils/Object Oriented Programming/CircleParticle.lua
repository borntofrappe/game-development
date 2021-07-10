CircleParticle = Particle:new()

local RADIUS_MIN = 5
local RADIUS_MAX = 8

function CircleParticle:new(x, y)
  local this = {
    ["x"] = x,
    ["y"] = y,
    ["r"] = love.math.random(RADIUS_MIN, RADIUS_MAX)
  }

  self.__index = self
  setmetatable(this, self)
  return this
end

function CircleParticle:render()
  love.graphics.setColor(0.96, 0.6, 0.34)
  love.graphics.circle("fill", self.x, self.y, self.r)
end
