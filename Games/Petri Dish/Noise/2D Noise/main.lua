WINDOW_WIDTH = 480
WINDOW_HEIGHT = 480
CELL_SIZE = 5
OFFSET_INCREMENT = 0.02

function love.load()
  love.window.setTitle("2D Noise")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  offsetIncrement = 0.01
  grid = makeGrid(WINDOW_WIDTH, WINDOW_HEIGHT, CELL_SIZE)
end

function makeGrid(width, height, cellSize)
  local columns = math.floor(width / cellSize) + 1
  local rows = math.floor(height / cellSize) + 1

  local grid = {}
  local offsetColumn = 0
  local offsetRow = 0

  for column = 1, columns do
    offsetRow = 0
    grid[column] = {}
    for row = 1, rows + 1 do
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

function love.draw()
  for c, column in ipairs(grid) do
    for r, cell in ipairs(column) do
      love.graphics.setColor(0.3, 0.3, 0.3, cell.alpha)
      love.graphics.rectangle("fill", (cell.column - 1) * cell.size, (cell.row - 1) * cell.size, cell.size, cell.size)
    end
  end
end
