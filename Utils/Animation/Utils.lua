function GenerateQuads(atlas, x, y, tileSize)
  local frames = math.floor(atlas:getWidth() / tileSize)

  local quads = {}

  for i = 1, frames do
    table.insert(quads, love.graphics.newQuad(x + (i - 1) * tileSize, y, tileSize, tileSize, atlas:getDimensions()))
  end

  return quads
end
