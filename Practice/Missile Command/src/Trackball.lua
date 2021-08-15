Trackball = {}

function Trackball:new()
  local this = {
    ["x"] = WINDOW_WIDTH / 2,
    ["y"] = WINDOW_HEIGHT / 2,
    ["size"] = 12
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Trackball:render()
  love.graphics.setColor(0, 0, 0)

  love.graphics.setLineWidth(1)
  love.graphics.line(self.x - self.size, self.y, self.x + self.size, self.y)
  love.graphics.line(self.x, self.y - self.size, self.x, self.y + self.size)
  love.graphics.line(self.x - self.size / 2, self.y - self.size, self.x + self.size / 2, self.y - self.size)
  love.graphics.line(self.x - self.size / 2, self.y + self.size, self.x + self.size / 2, self.y + self.size)
  love.graphics.line(self.x - self.size, self.y - self.size / 2, self.x - self.size, self.y + self.size / 2)
  love.graphics.line(self.x + self.size, self.y - self.size / 2, self.x + self.size, self.y + self.size / 2)
end
