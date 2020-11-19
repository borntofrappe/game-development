WINDOW_WIDTH = 480
WINDOW_HEIGHT = 480
RADIUS = WINDOW_WIDTH / 4
OFFSET_MULTIPLIER = 0.1

function love.load()
  love.window.setTitle("Circle 2D noise")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  offsetStart = love.math.random(1000)
  points = makeCircle(RADIUS, OFFSET_MULTIPLIER)
end

function makeCircle(radius, multiplier)
  local points = {}

  for i = 0, math.pi * 2, math.pi * 2 / 50 do
    local offsetX = offsetStart + math.cos(i) * multiplier
    local offsetY = offsetStart + math.sin(i) * multiplier

    local r = radius / 2 + love.math.noise(offsetX, offsetY) * radius / 2
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
  if x then
    local multiplier = x / WINDOW_WIDTH
    points = makeCircle(RADIUS, multiplier)
  end
end

function love.draw()
  love.graphics.translate(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
  love.graphics.setColor(0.3, 0.3, 0.3)
  love.graphics.setLineWidth(2)
  love.graphics.polygon("line", points)
end
