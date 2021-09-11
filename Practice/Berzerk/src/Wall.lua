Wall = {}

function Wall:new(x, y, width, height)
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

function Wall:render()
  love.graphics.setColor(0.427, 0.459, 0.906)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end
