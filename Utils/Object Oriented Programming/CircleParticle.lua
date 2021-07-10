CircleParticle = Particle:new()

local RADIUS_MIN = 4
local RADIUS_MAX = 7

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
  love.graphics.circle("fill", self.x, self.y, self.r)
end
