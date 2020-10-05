function GenerateQuadsAliens(atlas)
  local width = ALIEN_WIDTH
  local height = ALIEN_HEIGHT
  local colors = math.floor(atlas:getWidth() / width)
  local varieties = math.floor(atlas:getHeight() / height)

  local x = 0
  local y = 0

  local quads = {}
  for i = 1, colors do
    y = 0
    quads[i] = {}
    for j = 1, varieties do
      quads[i][j] = love.graphics.newQuad(x, y, width, height, atlas:getDimensions())
      y = y + height
    end
    x = x + width
  end

  return quads
end

function GenerateQuadsBackground(atlas)
  local width = VIRTUAL_WIDTH
  local height = VIRTUAL_HEIGHT
  local varieties = math.floor(atlas:getHeight() / height)
  local quads = {}
  for i = 1, varieties do
    quads[i] = love.graphics.newQuad(0, height * (i - 1), width, height, atlas:getDimensions())
  end
  return quads
end
