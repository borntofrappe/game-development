WINDOW_WIDTH = 480
WINDOW_HEIGHT = 480
RADIUS = WINDOW_WIDTH / 4
OFFSET_MULTIPLIER = 0.1
OFFSET_INITIAL_MAX = 1000
POINTS = 50

function love.load()
  love.window.setTitle("Circle 2D noise")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  points = getPoints(OFFSET_MULTIPLIER)
  previousMultiplier = OFFSET_MULTIPLIER
end

function getPoints(multiplier)
  local points = {}
  local offsetStart = love.math.random(OFFSET_INITIAL_MAX)

  for i = 0, math.pi * 2, math.pi * 2 / POINTS do
    local offsetX = offsetStart + math.cos(i) * multiplier
    local offsetY = offsetStart + math.sin(i) * multiplier

    local r = RADIUS / 2 + love.math.noise(offsetX, offsetY) * RADIUS / 2
    local x = r * math.cos(i)
    local y = r * math.sin(i)
    table.insert(points, x)
    table.insert(points, y)
  end

  return points
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
  local x, y = love.mouse:getPosition()
  local offsetMultiplier = x / WINDOW_WIDTH
  if offsetMultiplier ~= previousMultiplier then
    points = getPoints(offsetMultiplier)
    previousMultiplier = offsetMultiplier
  end
end

function love.draw()
  love.graphics.translate(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
  love.graphics.setColor(0.3, 0.3, 0.3)
  love.graphics.setLineWidth(3)
  love.graphics.polygon("line", points)
end
