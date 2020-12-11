Terrain = {}
Terrain.__index = Terrain

function Terrain:create()
  local points = getTerrain()

  this = {
    ["points"] = points,
    ["polygon"] = polygon
  }

  setmetatable(this, self)

  return this
end

function Terrain:render()
  love.graphics.setColor(gColors["dark"].r, gColors["dark"].g, gColors["dark"].b)
  love.graphics.setLineWidth(TERRAIN_LINE_WIDTH)
  love.graphics.line(self.points)
end
