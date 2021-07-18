Firework = {}

local SPEED = 150
local RADIUS = 4

function Firework:new()
  local this = {
    ["x"] = WINDOW_WIDTH / 2 - RADIUS / 2,
    ["y"] = WINDOW_HEIGHT + RADIUS,
    ["r"] = RADIUS,
    ["dy"] = SPEED * -1,
    ["inPlay"] = true
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Firework:update(dt)
  self.y = self.y + self.dy * dt
end

function Firework:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.circle("fill", self.x, self.y, self.r)
end
