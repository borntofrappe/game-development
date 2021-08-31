function GenerateQuadsTiles(atlas)
  local quads = {}
  local types = TILE_TYPES
  local size = TILE_SIZE

  for i = 1, types do
    table.insert(quads, love.graphics.newQuad((i - 1) * size, 0, size, size, atlas:getDimensions()))
  end

  return quads -- quads[n]
end

function GenerateQuadsGems(atlas)
  local quads = {}

  local maxSize = GEM_SIZES[#GEM_SIZES] * TILE_SIZE
  local x = 0
  local y = 8

  for i, color in ipairs(GEM_COLORS) do
    quads[color] = {}
    for j, gemSize in ipairs(GEM_SIZES) do
      local size = gemSize * TILE_SIZE
      quads[color][gemSize] = love.graphics.newQuad(x, y, size, size, atlas:getDimensions())
      x = x + size
    end
    x = 0
    y = y + maxSize
  end

  return quads -- quads[color][size]
end

function GenerateQuadsTools(atlas)
  local x = 0
  local y = 136
  local width = TOOLS_WIDTH
  local height = TOOLS_HEIGHT

  local quads = {}
  for i, tool in ipairs(TOOLS) do
    quads[tool] = {}
    for j, type in ipairs(TOOLS_TYPE) do
      quads[tool][type] = love.graphics.newQuad(x, y, width, height, atlas:getDimensions())
      x = x + width
    end
    x = 0
    y = y + height
  end

  return quads -- quads[name][type]
end

function GenerateQuadSelection(atlas)
  local x = 48
  local y = 0
  local size = TILE_SIZE

  return love.graphics.newQuad(x, y, size, size, atlas:getDimensions()) -- quad
end

function GenerateQuadsProgressBar(atlas)
  local x = 28
  local y = 180
  local height = 16

  local quads = {}

  for i, width in ipairs(PROGRESS_WIDTHS) do
    x = x - width
    table.insert(quads, love.graphics.newQuad(x, y, width, height, atlas:getDimensions()))
  end

  return quads -- quads[n]
end

function GenerateOffsets(numberOffsets)
  local numberOffsets = numberOffsets or 10

  local offsets = {}

  for i = 1, numberOffsets - 1 do
    table.insert(offsets, math.sin((math.pi * 2) * (i - 1) / numberOffsets))
  end

  table.insert(offsets, 0)

  return offsets
end
