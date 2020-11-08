function GenerateQuads(atlas, tileWidth, tileHeight)
  local sheetWidth = math.floor(atlas:getWidth() / tileWidth)
  local sheetHeight = math.floor(atlas:getHeight() / tileHeight)

  local counter = 1
  local spritesheet = {}

  for y = 0, sheetHeight - 1 do
    for x = 0, sheetWidth - 1 do
      local sprite = love.graphics.newQuad(x * tileWidth, y * tileHeight, tileWidth, tileHeight, atlas:getDimensions())
      spritesheet[counter] = sprite
      counter = counter + 1
    end
  end

  return spritesheet
end

function GenerateQuadsBushes(atlas)
  local width = BUSH_WIDTH
  local height = BUSH_HEIGHT

  local colors = math.floor(atlas:getWidth() / width)
  local variants = math.floor(atlas:getHeight() / height)

  local quads = {}

  for y = 1, colors do
    quads[y] = {}
    for x = 1, variants do
      quads[y][x] = love.graphics.newQuad((x - 1) * width, (y - 1) * height, width, height, atlas:getDimensions())
    end
  end

  return quads
end
