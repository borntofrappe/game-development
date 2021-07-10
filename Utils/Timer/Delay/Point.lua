Point = {}

local RADIUS_MIN = 5
local RADIUS_MAX = 15

function Point:new(x, y)
  local this = {
    ["x"] = x,
    ["y"] = y,
    ["r"] = love.math.random(RADIUS_MIN, RADIUS_MAX)
  }

  self.__index = self
  setmetatable(this, self)
  return this
end

function Point:render()
  love.graphics.circle("fill", self.x, self.y, self.r)
end
