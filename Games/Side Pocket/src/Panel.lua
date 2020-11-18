Panel = {}
Panel.__index = Panel

function Panel:new(def)
  local def =
    def or
    {
      ["x"] = 8,
      ["y"] = 8,
      ["width"] = 16,
      ["height"] = 16,
      ["lineWidth"] = 2,
      ["rx"] = 2
    }

  this = def

  setmetatable(this, self)
  return this
end

function Panel:render()
  love.graphics.setColor(0.73, 0.42, 0.05)
  love.graphics.setLineWidth(self.lineWidth)
  love.graphics.rectangle("line", self.x, self.y, self.width, self.height, self.rx)
end
