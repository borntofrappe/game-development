function table.slice(table, first, last, step)
  local slice = {}

  for i = first or 1, last or #table, step or 1 do
    slice[#slice + 1] = table[i]
  end

  return slice
end

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

function GenerateQuadsBalls(atlas)
  --[[ start at (96, 48)
    7 colors detailed in two rows containing 4 sprites max
  ]]
  x = 96
  y = 48

  local counter = 1
  local quads = {}

  for i = 0, 1 do
    for j = 0, 3 do
      quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
      counter = counter + 1
      x = x + 8
    end
    x = 96
    y = y + 8
  end

  return table.slice(quads, 1, #quads - 1)
end

function GenerateQuadsBricks(atlas)
  quads = table.slice(GenerateQuads(atlas, 32, 16), 1, 21)
  quads[#quads + 1] = love.graphics.newQuad(160, 48, 32, 16, atlas:getDimensions())
  return quads
end

function GenerateQuadsPowerups(atlas)
  --[[ start at (0, 192)
    10 varieties of a 16x16 size
  ]]
  x = 0
  y = 192

  local quads = {}

  for i = 1, 10 do
    quads[i] = love.graphics.newQuad(x, y, 16, 16, atlas:getDimensions())
    x = x + 16
  end

  return quads
end
