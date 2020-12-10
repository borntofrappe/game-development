Terrain = {}
Terrain.__index = Terrain

function Terrain:create()
  this = {
    points = getTerrain()
  }

  setmetatable(this, self)

  return this
end

function Terrain:render()
  love.graphics.setColor(gColors["dark"].r, gColors["dark"].g, gColors["dark"].b)
  love.graphics.setLineWidth(6)
  love.graphics.line(self.points)
end
