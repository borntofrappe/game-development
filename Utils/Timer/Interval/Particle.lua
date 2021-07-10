Particle = {}

local RADIUS_MIN = 5
local RADIUS_MAX = 15

function Particle:new()
  local r = love.math.random(RADIUS_MIN, RADIUS_MAX)
  local this = {
    ["x"] = love.math.random(WINDOW_WIDTH),
    ["y"] = -r,
    ["r"] = r,
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
  love.graphics.circle("fill", self.x, self.y, self.r)
end
