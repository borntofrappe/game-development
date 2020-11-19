WINDOW_WIDTH = 480
WINDOW_HEIGHT = 480
RADIUS = WINDOW_WIDTH / 4
OFFSET_INCREMENT = 0.1

function love.load()
  love.window.setTitle("Circle noise")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  points = makeCircle(RADIUS, OFFSET_INCREMENT)
end

function makeCircle(radius, increment)
  local points = {}
  local offset = 0

  for i = 0, math.pi * 2, math.pi * 2 / 50 do
    -- local r = radius / 2 + love.math.random() * radius / 2
    local r = radius / 2 + love.math.noise(offset) * radius / 2
    local x = r * math.cos(i)
    local y = r * math.sin(i)
    table.insert(points, x)
    table.insert(points, y)

    offset = offset + increment
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
  if x then
    local increment = x / WINDOW_WIDTH
    points = makeCircle(RADIUS, increment)
  end
end

function love.draw()
  love.graphics.translate(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
  love.graphics.setColor(0.3, 0.3, 0.3)
  love.graphics.setLineWidth(2)
  love.graphics.polygon("line", points)
end
