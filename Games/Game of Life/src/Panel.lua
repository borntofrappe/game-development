Panel = {}
Panel.__index = Panel

function Panel:new(x, y, width, height)
  this = {
    ["x"] = x,
    ["y"] = y,
    ["width"] = width,
    ["height"] = height
  }

  setmetatable(this, self)
  return this
end

function Panel:render()
  love.graphics.setLineWidth(2)
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("line", self.x, self.y, self.width, self.height, 5)
end
