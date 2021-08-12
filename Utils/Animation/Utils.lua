function GenerateQuadsPlayer(atlas)
  local x = 0
  local y = 0
  local frames = 4

  local quads = {}

  for i = 1, frames do
    table.insert(quads, love.graphics.newQuad(x + (i - 1) * TILE_SIZE, y, TILE_SIZE, TILE_SIZE, atlas:getDimensions()))
  end

  return quads
end

function GenerateQuadsDog(atlas)
  local x = 0
  local y = 16
  local frames = 3

  local quads = {}

  for i = 1, frames do
    table.insert(quads, love.graphics.newQuad(x + (i - 1) * TILE_SIZE, y, TILE_SIZE, TILE_SIZE, atlas:getDimensions()))
  end

  return quads
end
