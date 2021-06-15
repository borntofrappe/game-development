function GenerateQuads(atlas, tileWidth, tileHeight)
  local sheetWidth = atlas:getWidth() / tileWidth
  local sheetHeight = atlas:getHeight() / tileHeight

  local sheetCounter = 1
  local spritesheet = {}

  for y = 0, sheetHeight - 1 do
    for x = 0, sheetWidth - 1 do
      spritesheet[sheetCounter] =
        love.graphics.newQuad(x * tileWidth, y * tileHeight, tileWidth, tileHeight, atlas:getDimensions())

      sheetCounter = sheetCounter + 1
    end
  end

  return spritesheet
end

function table.slice(table, first, last, step)
  local slice = {}

  for i = first or 1, last or #table, step or 1 do
    slice[#slice + 1] = table[i]
  end

  return slice
end

function GenerateQuadsPaddles(atlas)
  --[[ start at (0, 64)
  4 colors, coming in four different sizes
  (32x16), (64x16), (96x16), (128x16)
  ]]
  local x = 0
  local y = 64

  local counter = 1
  local quads = {}

  for i = 0, 3 do
    quads[counter] = love.graphics.newQuad(x, y, 32, 16, atlas:getDimensions())
    counter = counter + 1

    quads[counter] = love.graphics.newQuad(x + 32, y, 64, 16, atlas:getDimensions())
    counter = counter + 1

    quads[counter] = love.graphics.newQuad(x + 96, y, 96, 16, atlas:getDimensions())
    counter = counter + 1

    -- (128x16) is on the row below
    quads[counter] = love.graphics.newQuad(x, y + 16, 128, 16, atlas:getDimensions())
    counter = counter + 1

    x = 0
    -- jump two rows down
    y = y + 32
  end

  return quads
end
