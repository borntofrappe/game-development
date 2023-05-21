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

  local quads = {}

  for y = 0, sheetHeight - 1 do
    for x = 0, sheetWidth - 1 do
      quads[#quads + 1] =
        love.graphics.newQuad(x * tileWidth, y * tileHeight, tileWidth, tileHeight, atlas:getDimensions())
    end
  end

  return quads
end

function GenerateQuadsPaddles(atlas)
  --[[ start at (0, 64)
    4 colors, coming in four different sizes
    (32x16), (64x16), (96x16), (128x16)
  ]]
  local x = 0
  local y = 64

  local quads = {}

  for i = 0, 3 do
    quads[#quads + 1] = love.graphics.newQuad(x, y, 32, 16, atlas:getDimensions())

    quads[#quads + 1] = love.graphics.newQuad(x + 32, y, 64, 16, atlas:getDimensions())

    quads[#quads + 1] = love.graphics.newQuad(x + 96, y, 96, 16, atlas:getDimensions())

    -- (128x16) is on the row below
    quads[#quads + 1] = love.graphics.newQuad(x, y + 16, 128, 16, atlas:getDimensions())

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
  local x = 96
  local y = 48

  local quads = {}

  for i = 0, 1 do
    for j = 0, 3 do
      quads[#quads + 1] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())

      x = x + 8
    end
    x = 96
    y = y + 8
  end

  return table.slice(quads, 1, #quads - 1)
end

function GenerateQuadsBricks(atlas)
  return table.slice(GenerateQuads(atlas, 32, 16), 1, 20)
end
