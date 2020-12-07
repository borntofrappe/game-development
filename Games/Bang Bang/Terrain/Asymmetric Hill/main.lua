WINDOW_WIDTH = 620
WINDOW_HEIGHT = 440
POINTS = 300
RADIUS = 12
UPDATE_SPEED = 200
EULER_NUMBER = 2.71828
MU_MIN = math.floor(WINDOW_WIDTH / 3)
MU_MAX = math.floor(WINDOW_WIDTH * 2 / 3)
SIGMA_MIN = 30
SIGMA_MAX = 80
NORMAL_DISTRIBUTION_SCALE_MIN = 12000
NORMAL_DISTRIBUTION_SCALE_MAX = 16000

function love.load()
  love.window.setTitle("Asymmetric Hill")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  player = {
    ["x"] = love.math.random(RADIUS, WINDOW_WIDTH - RADIUS),
    ["y"] = WINDOW_HEIGHT * 3 / 4,
    ["r"] = RADIUS
  }

  terrain = getPoints()
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "r" then
    terrain = getPoints()
  end

  if key == "return" then
    local xStart = player.x - player.r
    local xEnd = player.x + player.r
    local angle = math.pi
    local dAngle = math.pi / (player.r * 2) * WINDOW_WIDTH / POINTS
    for i = 1, #terrain, 2 do
      if terrain[i] >= xStart and terrain[i] <= xEnd then
        terrain[i + 1] = terrain[i + 1] + math.sin(angle) * player.r
        angle = math.max(0, angle - dAngle)
      end
    end
  end
end

function love.update(dt)
  if love.keyboard.isDown("right") then
    player.x = math.min(WINDOW_WIDTH - RADIUS, player.x + UPDATE_SPEED * dt)
  elseif love.keyboard.isDown("left") then
    player.x = math.max(RADIUS, player.x - UPDATE_SPEED * dt)
  end
end

function love.draw()
  love.graphics.setLineWidth(2)
  love.graphics.setColor(0.2, 0.2, 0.2)
  love.graphics.line(terrain)

  love.graphics.setColor(0.2, 0.2, 0.2, 0.5)
  love.graphics.circle("fill", player.x, player.y, player.r)
end

function getPoints(mu, sigma)
  local yStart = love.math.random(math.floor(WINDOW_HEIGHT / 2), WINDOW_HEIGHT)
  local mu = love.math.random(MU_MIN, MU_MAX)
  local sigma = love.math.random(SIGMA_MIN, SIGMA_MAX)

  local points = {}
  local scale1 = love.math.random(NORMAL_DISTRIBUTION_SCALE_MIN, NORMAL_DISTRIBUTION_SCALE_MAX)
  local scale2 = yStart < WINDOW_HEIGHT * 3 / 4 and math.floor(scale1 * 1.5) or math.floor(scale1 * 0.75)
  for i = 1, POINTS + 1 do
    local x = (i - 1) * WINDOW_WIDTH / POINTS
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

function getNormalDistribution(x, mu, sigma)
  return 1 / (sigma * (2 * math.pi) ^ 0.5) * EULER_NUMBER ^ ((-1 / 2) * ((x - mu) / sigma) ^ 2)
end
