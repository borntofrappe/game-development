WINDOW_WIDTH = 500
WINDOW_HEIGHT = 400

local points = {}

function love.load()
  love.window.setTitle("Terrain")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.12, 0.12, 0.12)

  local n = 100
  local y = WINDOW_HEIGHT / 2
  for i = 1, n + 1 do
    local x = (i - 1) * WINDOW_WIDTH / n
    table.insert(points, x)
    table.insert(points, y)
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.draw()
  love.graphics.setColor(0.95, 0.95, 0.95)
  love.graphics.setLineWidth(2)

  love.graphics.line(points)
end
