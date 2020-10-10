Panel = Class()

function Panel:init(def)
  self.x = def.x or 4
  self.y = def.y or 4
  self.width = def.width or VIRTUAL_WIDTH - 8
  self.height = def.height or 56

  self.rx = def.rx or 5

  self.lineWidth = def.lineWidth or 4
  self.lineColor =
    def.lineColor or
    {
      ["r"] = 1,
      ["g"] = 1,
      ["b"] = 1
    }
  self.fillColor =
    def.fillColor or
    {
      ["r"] = 0.1,
      ["g"] = 0.1,
      ["b"] = 0.1
    }
end

function Panel:render()
  love.graphics.setLineWidth(self.lineWidth)
  love.graphics.setColor(self.lineColor.r, self.lineColor.g, self.lineColor.b)
  love.graphics.rectangle("line", self.x, self.y, self.width, self.height, self.rx)
  love.graphics.setColor(self.fillColor.r, self.fillColor.g, self.fillColor.b)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, self.rx)
end
