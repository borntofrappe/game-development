WINDOW_WIDTH = 480
WINDOW_HEIGHT = 480

function love.load()
  love.window.setTitle("2D Noise")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  offsetIncrement = 0.01
  grid = makeGrid(offsetIncrement)
end

function makeGrid(increment)
  local grid = {}
  local offsetX = 0
  local offsetY = 0

  for x = 1, WINDOW_WIDTH + 1 do
    offsetY = 0
    grid[x] = {}
    for y = 1, WINDOW_HEIGHT + 1 do
      grid[x][y] = love.math.noise(offsetX, offsetY)
      offsetY = offsetY + increment
    end
    offsetX = offsetX + increment
  end

  return grid
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.draw()
  for x = 1, WINDOW_WIDTH + 1 do
    for y = 1, WINDOW_HEIGHT + 1 do
      love.graphics.setColor(0.3, 0.3, 0.3, grid[x][y])
      love.graphics.rectangle("fill", (x - 1), (y - 1), 1, 1)
    end
  end
end
