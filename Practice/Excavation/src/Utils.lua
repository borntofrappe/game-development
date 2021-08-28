function GenerateQuadsTextures(atlas)
  local quads = {}
  local types = TEXTURE_TYPES
  local size = TEXTURE_SIZE

  for i = 1, types do
    table.insert(quads, love.graphics.newQuad((i - 1) * size, 0, size, size, atlas:getDimensions()))
  end

  return quads
end

function GenerateQuadsGems(atlas)
  local quads = {}

  local maxSize = GEM_SIZES[#GEM_SIZES]
  local x = 0
  local y = 8

  for i, color in ipairs(GEM_COLORS) do
    quads[color] = {}
    for j, size in ipairs(GEM_SIZES) do
      table.insert(quads[color], love.graphics.newQuad(x, y, size, size, atlas:getDimensions()))
      x = x + size
    end
    x = 0
    y = y + maxSize
  end

  return quads
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

  return quads
end

function GenerateQuadSelection(atlas)
  local x = 0
  local y = 180
  local size = TEXTURE_SIZE

  return love.graphics.newQuad(x, y, size, size, atlas:getDimensions())
end

function GenerateQuadsProgressBar(atlas)
  local x = 36
  local y = 180
  local height = 16

  local quads = {}

  for i, width in ipairs(PROGRESS_WIDTHS) do
    x = x - width
    table.insert(quads, love.graphics.newQuad(x, y, width, height, atlas:getDimensions()))
  end

  return quads
end

function GenerateOffsets(numberOffsets, numberRotations)
  local numberOffsets = numberOffsets or 20
  local numberRotations = numberRotations or 3
  local angle = math.pi * 2 * numberRotations
  local increment = angle / numberOffsets

  local offsets = {}

  for a = 0, angle, increment do
    table.insert(offsets, math.sin(a))
  end

  return offsets
end
