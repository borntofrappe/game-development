function GenerateQuads(atlas, tileWidth, tileHeight)
  local sheetWidth = atlas:getWidth() / tileWidth
  local sheetHeight = atlas:getHeight() / tileHeight

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

function GenerateQuadsObstacles(atlas)
  local quads = {
    ["horizontal"] = {},
    ["vertical"] = {}
  }

  local hX = 0
  local hY = 0
  for i = 1, #H_OBSTACLES do
    quads["horizontal"][i] = {}
    hX = 0
    local width = H_OBSTACLES[i].width
    local height = H_OBSTACLES[i].height
    for j = 1, 2 do
      quads["horizontal"][i][j] = love.graphics.newQuad(hX, hY, width, height, atlas:getDimensions())
      hX = hX + width
    end
    hY = hY + height
  end

  local vX = 220
  local vY = 0
  for i = 1, #V_OBSTACLES do
    quads["vertical"][i] = {}
    vY = 0
    local width = V_OBSTACLES[i].width
    local height = V_OBSTACLES[i].height
    for j = 1, 2 do
      quads["vertical"][i][j] = love.graphics.newQuad(vX, vY, width, height, atlas:getDimensions())
      vY = vY + height
    end
    vX = vX + width
  end

  return quads
end
