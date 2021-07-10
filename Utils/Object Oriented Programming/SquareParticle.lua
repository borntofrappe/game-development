SquareParticle = Particle:new()

local SIDE_MIN = 7
local SIDE_MAX = 14

function SquareParticle:new(x, y)
  local side = love.math.random(SIDE_MIN, SIDE_MAX)
  local this = {
    ["x"] = x - side / 2,
    ["y"] = y - side / 2,
    ["side"] = side
  }

  self.__index = self
  setmetatable(this, self)
  return this
end

function SquareParticle:render()
  love.graphics.rectangle("fill", self.x, self.y, self.side, self.side)
end
