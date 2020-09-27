Appendage = {}
Appendage.__index = Appendage

function Appendage:create(x, y, direction)
end

function Appendage:render()
  love.graphics.setColor(gColors["snake"].r, gColors["snake"].g, gColors["snake"].b)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
  love.graphics.setColor(gColors["background"].r, gColors["background"].g, gColors["background"].b, 0.2)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end
