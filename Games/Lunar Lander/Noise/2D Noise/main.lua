WINDOW_WIDTH = 400
WINDOW_HEIGHT = 400
OFFSET_INCREMENT = 0.01
OFFSET_INCREMENT_MAX = 0.05
OFFSET_INCREMENT_MIN = 0.005
OFFSET_INCREMENT_CHANGE = 0.005

function love.load()
  love.window.setTitle("2D Noise")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.8, 0.8, 0.8)

  offsetIncrement = OFFSET_INCREMENT
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

  if key == "down" then
    offsetIncrement = math.max(OFFSET_INCREMENT_MIN, offsetIncrement - OFFSET_INCREMENT_CHANGE)
    grid = makeGrid(offsetIncrement)
  elseif key == "up" then
    offsetIncrement = math.min(OFFSET_INCREMENT_MAX, offsetIncrement + OFFSET_INCREMENT_CHANGE)
    grid = makeGrid(offsetIncrement)
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
