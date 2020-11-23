WINDOW_WIDTH = 620
WINDOW_HEIGHT = 440
POINTS = 200
POINTS_PLATFORMS = 30
POINTS_HILL = POINTS - POINTS_PLATFORMS * 2

function love.load()
  love.window.setTitle("Hills")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 0.95, 1)

  terrain = getPoints()
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.draw()
  -- love.graphics.setColor(0.2, 0.7, 0.5)
  -- love.graphics.polygon("fill", terrain)
  love.graphics.setColor(0, 0, 0)
  love.graphics.setLineWidth(4)
  love.graphics.line(terrain)
end

function getPoints()
  local yPlatform1 = WINDOW_HEIGHT / 2 + love.math.random() * WINDOW_HEIGHT / 2
  local yPlatform2 = WINDOW_HEIGHT / 2 + love.math.random() * WINDOW_HEIGHT / 2
  local heightHill = love.math.random() * WINDOW_HEIGHT / 2
  local points = {}

  local x = 0
  local y = yPlatform1
  local xGap = WINDOW_WIDTH / POINTS

  for i = 0, POINTS_PLATFORMS do
    table.insert(points, x)
    table.insert(points, y)

    x = x + xGap
  end

  local offset = -0.05 * POINTS_HILL / 2
  local mu = 0
  local std = 1

  for i = 0, POINTS_HILL do
    local yChange = 1 / (std * (2 * math.pi) ^ 0.5) * 2.71828183 ^ ((-1 / 2) * ((offset - mu) / std) ^ 2)
    table.insert(points, x)
    table.insert(points, y - yChange * 200)

    x = x + xGap
    offset = offset + 0.05
  end

  for i = 0, POINTS_PLATFORMS do
    table.insert(points, x)
    table.insert(points, y)

    x = x + xGap
  end

  return points
end
