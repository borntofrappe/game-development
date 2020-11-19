WINDOW_WIDTH = 480
WINDOW_HEIGHT = 480
RADIUS = WINDOW_WIDTH / 4
OFFSET_INCREMENT = 0.1
POINTS = 50

function love.load()
  love.window.setTitle("Circle noise")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  points = makeCircle(OFFSET_INCREMENT)
  previousIncrement = OFFSET_INCREMENT
end

function makeCircle(offsetIncrement)
  local points = {}
  local offset = love.math.random(1000)
  for i = 0, math.pi * 2, math.pi * 2 / POINTS do
    -- local r = RADIUS / 2 + love.math.random() * RADIUS / 2
    local r = RADIUS / 2 + love.math.noise(offset) * RADIUS / 2
    local x = r * math.cos(i)
    local y = r * math.sin(i)
    table.insert(points, x)
    table.insert(points, y)

    offset = offset + offsetIncrement
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
  local offsetIncrement = x / WINDOW_WIDTH
  if offsetIncrement ~= previousIncrement then
    points = makeCircle(offsetIncrement)
    previousIncrement = offsetIncrement
  end
end

function love.draw()
  love.graphics.translate(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
  love.graphics.setColor(0.3, 0.3, 0.3)
  love.graphics.setLineWidth(3)
  love.graphics.polygon("line", points)
end
