COLUMNS = 10
ROWS = 10

function love.load()
  love.window.setTitle("Game of Life")
  love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
  love.window.setMode(0, 0)

  width, height = love.graphics.getDimensions()
  grid = {}
  for column = 1, COLUMNS do
    grid[column] = {}
    for row = 1, ROWS do
      grid[column][row] = {
        ["column"] = column,
        ["row"] = row,
        ["isAlive"] = math.random(2) == 1
      }
    end
  end

  gridSize = math.min(math.floor(width / 3 * 2), math.floor(height / 10 * 8))
  cellSize = gridSize / ROWS
  padding = {
    ["top"] = math.floor((height - gridSize) / 2),
    ["left"] = math.floor((width - gridSize) / 2)
  }
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
end

function love.draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.translate(padding.left, padding.top)

  love.graphics.rectangle("line", 0, 0, gridSize, gridSize)
  for column = 1, COLUMNS do
    for row = 1, ROWS do
      if grid[column][row].isAlive then
        love.graphics.rectangle("fill", (column - 1) * cellSize, (row - 1) * cellSize, cellSize, cellSize)
      end
    end
  end
end
