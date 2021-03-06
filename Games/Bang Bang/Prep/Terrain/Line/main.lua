WINDOW_WIDTH = 620
WINDOW_HEIGHT = 440
POINTS = 100

function love.load()
  love.window.setTitle("Line")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  terrain = getPoints()
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.draw()
  love.graphics.setLineWidth(2)
  love.graphics.setColor(0.2, 0.2, 0.2)
  love.graphics.line(terrain)
end

function getPoints()
  local points = {}

  for i = 1, POINTS + 1 do
    local x = (i - 1) * WINDOW_WIDTH / POINTS
    local y = WINDOW_HEIGHT * 3 / 4
    table.insert(points, x)
    table.insert(points, y)
  end

  return points
end
