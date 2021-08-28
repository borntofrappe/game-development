Panel = {}

function Panel:new(x, y, width, height)
  local this = {
    ["x"] = x,
    ["y"] = y,
    ["width"] = width,
    ["height"] = height
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Panel:render()
  love.graphics.setColor(0.357, 0.306, 0.251)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
  love.graphics.setColor(0.475, 0.404, 0.239)
  love.graphics.rectangle("fill", self.x + 1, self.y + 1, self.width - 2, self.height - 2)
end
