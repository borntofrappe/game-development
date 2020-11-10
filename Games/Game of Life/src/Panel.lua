Panel = {}
Panel.__index = Panel

function Panel:new(x, y, width, height)
  this = {
    ["x"] = x,
    ["y"] = y,
    ["width"] = width,
    ["height"] = height,
    ["mode"] = "line"
  }

  setmetatable(this, self)
  return this
end

function Panel:highlight()
  self.mode = "fill"
end

function Panel:reset()
  self.mode = "line"
end

function Panel:render()
  love.graphics.setLineWidth(2)
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle(self.mode, self.x, self.y, self.width, self.height, 5)
end
