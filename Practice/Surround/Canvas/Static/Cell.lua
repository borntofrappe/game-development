Cell = {}

function Cell:new(x, y, size, color)
  local this = {
    ["x"] = x,
    ["y"] = y,
    ["size"] = size,
    ["color"] = color
  }
  self.__index = self
  setmetatable(this, self)
  return this
end

function Cell:render()
  love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
  love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
end
