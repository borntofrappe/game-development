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

function GenerateQuadsObjects(atlas, width, height)
  local quads = {}
  local x = 0
  local y = 0

  local colors = math.floor(atlas:getHeight() / height)
  local varieties = math.floor(atlas:getWidth() / width)

  for i = 1, colors do
    quads[i] = {}
    x = 0
    for j = 1, varieties do
      quads[i][j] = love.graphics.newQuad(x, y, width, height, atlas:getDimensions())
      x = x + width
    end
    y = y + height
  end

  return quads
end
