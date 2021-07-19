Player = {}

local WIDTH = 24
local HEIGHT = 32
local IMPULSE = 10
local FRICTION = 2

function Player:new()
  local this = {
    ["x"] = WINDOW_WIDTH / 2 - WIDTH / 2,
    ["y"] = WINDOW_HEIGHT / 2 - HEIGHT / 2,
    ["width"] = WIDTH,
    ["height"] = HEIGHT,
    ["impulse"] = IMPULSE,
    ["friction"] = FRICTION,
    ["dx"] = 0,
    ["dy"] = 0
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Player:push(direction)
  if direction == "up" then
    self.dy = self.dy - self.impulse
  elseif direction == "right" then
    self.dx = self.dx + self.impulse
  elseif direction == "down" then
    self.dy = self.dy + self.impulse
  elseif direction == "left" then
    self.dx = self.dx - self.impulse
  end
end

function Player:update(dt)
  self.x = self.x + self.dx
  self.y = self.y + self.dy

  if self.dx > 0 then
    self.dx = math.max(0, self.dx - self.friction)
  elseif self.dx < 0 then
    self.dx = math.min(0, self.dx + self.friction)
  end

  if self.dy > 0 then
    self.dy = math.max(0, self.dy - self.friction)
  elseif self.dy < 0 then
    self.dy = math.min(0, self.dy + self.friction)
  end
end

function Player:render()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end
