ProgressBar = Class {}

function ProgressBar:init(def)
  local def = def or {}
  self.x = def.x or 4
  self.y = def.y or 4

  self.width = def.width or VIRTUAL_WIDTH / 2.2
  self.height = def.height or 8
  self.rx = def.rx or 5

  self.lineColor =
    def.lineColor or
    {
      ["r"] = 0.1,
      ["g"] = 0.1,
      ["b"] = 0.1
    }
  self.lineWidth = def.lineWidth or 2

  self.fillColor =
    def.fillColor or
    {
      ["r"] = 0.82,
      ["g"] = 0.18,
      ["b"] = 0.18
    }

  local fillPercentage = def.fillPercentage or 100
  self.fillWidth = self.width / 100 * fillPercentage
end

function ProgressBar:render()
  love.graphics.setColor(self.fillColor.r, self.fillColor.g, self.fillColor.b)
  love.graphics.rectangle("fill", self.x + 1, self.y + 1, self.fillWidth - 2, self.height - 2)
  love.graphics.setLineWidth(self.lineWidth)
  love.graphics.setColor(self.lineColor.r, self.lineColor.g, self.lineColor.b)
  love.graphics.rectangle("line", self.x, self.y, self.width, self.height, self.rx)
end
