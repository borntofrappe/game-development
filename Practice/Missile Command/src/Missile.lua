Missile = {}

function Missile:new(x1, y1, x2, y2)
  local this = {
    ["points"] = {x1, y1, x2, y2}
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Missile:render()
  love.graphics.setColor(0, 0, 0)
  love.graphics.setLineWidth(0.5)
  love.graphics.line(self.points)
end
