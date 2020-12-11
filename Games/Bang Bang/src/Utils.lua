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

function getNormalDistribution(x, mu, sigma)
  return 1 / (sigma * (2 * math.pi) ^ 0.5) * EULER_NUMBER ^ ((-1 / 2) * ((x - mu) / sigma) ^ 2)
end

function getTerrain()
  local yStart = love.math.random(math.floor(WINDOW_HEIGHT * 2 / 3), WINDOW_HEIGHT)
  local mu = love.math.random(MU_MIN, MU_MAX)
  local sigma = love.math.random(SIGMA_MIN, SIGMA_MAX)

  local points = {}
  local scale1 = love.math.random(NORMAL_DISTRIBUTION_SCALE_MIN, NORMAL_DISTRIBUTION_SCALE_MAX)
  local scale2 = yStart < WINDOW_HEIGHT * 3 / 4 and math.floor(scale1 * 1.5) or math.floor(scale1 * 0.75)
  for i = 1, TERRAIN_POINTS + 1 do
    local x = (i - 1) * WINDOW_WIDTH / TERRAIN_POINTS
    local dy = getNormalDistribution(x, mu, sigma)
    if x < mu then
      dy = dy * scale1
    else
      dy = dy * scale2 - (getNormalDistribution(mu, mu, sigma) * scale2 - getNormalDistribution(mu, mu, sigma) * scale1)
    end
    local y = yStart - dy
    table.insert(points, x)
    table.insert(points, y)
  end

  return points
end
