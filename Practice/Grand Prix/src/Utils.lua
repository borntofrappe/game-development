function GenerateQuadsCars(atlas)
  local size = CAR_SIZE
  local x = 0
  local y = 0
  local colors = 4
  local frames = 4

  local quads = {}
  for i = 1, colors do
    quads[i] = {}
    for j = 1, frames do
      quads[i][j] = love.graphics.newQuad(x + (j - 1) * size, y + (i - 1) * size, size, size, atlas:getDimensions())
    end
  end

  return quads
end

function GenerateQuadsTextures(atlas)
  local size = TEXTURE_SIZE
  local x = 0
  local y = 64
  local textures = 4

  local quads = {}
  for i = 1, textures do
    table.insert(quads, love.graphics.newQuad(x + (i - 1) * size, y, size, size, atlas:getDimensions()))
  end

  return quads
end
