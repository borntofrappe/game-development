WINDOW_WIDTH = 620
WINDOW_HEIGHT = 440
POINTS = 300
RADIUS = 12
SPEED = 200
EULER_NUMBER = 2.71828
MU_MIN = math.floor(WINDOW_WIDTH / 3)
MU_MAX = math.floor(WINDOW_WIDTH * 2 / 3)
SIGMA_MIN = 30
SIGMA_MAX = 80
NORMAL_DISTRIBUTION_SCALE = 15000

function love.load()
  love.window.setTitle("Normal distribution")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  point = {
    ["r"] = RADIUS,
    ["x"] = love.math.random(RADIUS, WINDOW_WIDTH - RADIUS),
    ["y"] = WINDOW_HEIGHT / 4
  }

  points = getPoints()
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "r" then
    points = getPoints()
  end

  if key == "return" then
    local xStart = point.x - point.r
    local xEnd = point.x + point.r
    local angle = math.pi
    local dAngle = math.pi / (point.r * 2) * WINDOW_WIDTH / POINTS
    for i = 1, #points, 2 do
      if points[i] >= xStart and points[i] <= xEnd then
        points[i + 1] = points[i + 1] + math.sin(angle) * point.r
        angle = math.max(0, angle - dAngle)
      end
    end
    -- move the point to a random coordinate
    point.x = love.math.random(RADIUS, WINDOW_WIDTH - RADIUS)
  end
end

function love.update(dt)
  if love.keyboard.isDown("right") then
    point.x = math.min(WINDOW_WIDTH - RADIUS, point.x + SPEED * dt)
  elseif love.keyboard.isDown("left") then
    point.x = math.max(RADIUS, point.x - SPEED * dt)
  end
end

function love.draw()
  love.graphics.setLineWidth(2)
  love.graphics.setColor(0.2, 0.2, 0.22)
  love.graphics.line(points)

  love.graphics.circle("fill", point.x, point.y, point.r)
end

function getPoints(mu, sigma)
  local mu = love.math.random(MU_MIN, MU_MAX)
  local sigma = love.math.random(SIGMA_MIN, SIGMA_MAX)

  local points = {}
  for i = 1, POINTS + 1 do
    local x = (i - 1) * WINDOW_WIDTH / POINTS
    local y = WINDOW_HEIGHT * 3 / 4 - getNormalDistribution(x, mu, sigma) * NORMAL_DISTRIBUTION_SCALE
    table.insert(points, x)
    table.insert(points, y)
  end

  return points
end

function getNormalDistribution(x, mu, sigma)
  return 1 / (sigma * (2 * math.pi) ^ 0.5) * EULER_NUMBER ^ ((-1 / 2) * ((x - mu) / sigma) ^ 2)
end
