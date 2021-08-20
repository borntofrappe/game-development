function GenerateQuadsCars(atlas)
  local tileSize = TILE_SIZE.car
  local x = 0
  local y = 0
  local colors = 4
  local frames = 4

  local quads = {}
  for i = 1, colors do
    quads[i] = {}
    for j = 1, frames do
      quads[i][j] =
        love.graphics.newQuad(x + (j - 1) * tileSize, y + (i - 1) * tileSize, tileSize, tileSize, atlas:getDimensions())
    end
  end

  return quads
end

function GenerateQuadsTextures(atlas)
  local tileSize = TILE_SIZE.texture
  local x = 0
  local y = 64
  local textures = 7

  local quads = {}
  for i = 1, textures do
    table.insert(quads, love.graphics.newQuad(x + (i - 1) * tileSize, y, tileSize, tileSize, atlas:getDimensions()))
  end

  return quads
end

function formatTimer(timer)
  local seconds = math.floor(timer)
  local minutes = math.floor(seconds / 60)
  seconds = seconds - minutes * 60

  return string.format("%02d:%02d", minutes, seconds)
end
