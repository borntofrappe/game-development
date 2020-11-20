WINDOW_WIDTH = 400
WINDOW_HEIGHT = 480
CELL_SIZE = 5
OFFSET_INCREMENT = 0.02
OFFSET_INITIAL_MAX = 1000

GRID_WIDTH = WINDOW_WIDTH
GRID_HEIGHT = 360

POINTS = 100

REFRESH_INTERVAL = 0.1

function love.load()
  love.window.setTitle("2D Noise walk")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  timer = 0

  offsetStart = love.math.random(OFFSET_INITIAL_MAX)
  grid = makeGrid(GRID_WIDTH, GRID_HEIGHT, CELL_SIZE)
  points = getPoints(GRID_WIDTH / 2, GRID_HEIGHT / 2, GRID_HEIGHT / 4)

  values = {}
  for i = 1, POINTS * 2 + 2, 2 do
    local x = points[i]
    local y = points[i + 1]
    local column = math.floor(x / CELL_SIZE) + 1
    local row = math.floor(y / CELL_SIZE) + 1
    local alpha = grid[column][row].alpha
    table.insert(values, (i - 1) / 2 * WINDOW_WIDTH / POINTS)
    table.insert(values, GRID_HEIGHT + alpha * (WINDOW_HEIGHT - GRID_HEIGHT))
  end

  index = 1
end

function getPoints(startX, startY, radius)
  local points = {}
  for i = 0, math.pi * 2, math.pi * 2 / POINTS do
    local x = startX + radius * math.cos(i)
    local y = startY + radius * math.sin(i)
    table.insert(points, x)
    table.insert(points, y)
  end

  return points
end

function makeGrid(width, height, cellSize)
  local columns = math.floor(width / cellSize) + 1
  local rows = math.floor(height / cellSize) + 1

  local grid = {}
  local offsetColumn = offsetStart
  local offsetRow = offsetStart

  for column = 1, columns do
    offsetRow = offsetStart
    grid[column] = {}
    for row = 1, rows do
      grid[column][row] = {
        ["column"] = column,
        ["row"] = row,
        ["size"] = cellSize,
        ["alpha"] = love.math.noise(offsetColumn, offsetRow)
      }
      offsetRow = offsetRow + OFFSET_INCREMENT
    end
    offsetColumn = offsetColumn + OFFSET_INCREMENT
  end

  return grid
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
  timer = timer + dt
  if timer > REFRESH_INTERVAL then
    timer = timer % REFRESH_INTERVAL
    index = index + 2
    if index >= #points then
      index = 1
    end
  end
end

function love.draw()
  for c, column in ipairs(grid) do
    for r, cell in ipairs(column) do
      love.graphics.setColor(0.3, 0.3, 0.3, cell.alpha)
      love.graphics.rectangle("fill", (cell.column - 1) * cell.size, (cell.row - 1) * cell.size, cell.size, cell.size)
    end
  end

  -- love.graphics.setColor(1, 1, 1)
  -- love.graphics.setLineWidth(2)
  -- love.graphics.line(points)

  love.graphics.setColor(0, 1, 0)
  love.graphics.circle("fill", points[index], points[index + 1], 5)

  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", 0, GRID_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT - GRID_HEIGHT)

  love.graphics.setColor(1, 1, 1)
  love.graphics.setLineWidth(2)
  love.graphics.line(values)

  love.graphics.setColor(0, 1, 0)
  love.graphics.circle("fill", values[index], values[index + 1], 5)
end
