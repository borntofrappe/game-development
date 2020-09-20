require "src/Dependencies"

function love.load()
  showGrid = true

  love.window.setTitle("Snake")

  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "g" then
    showGrid = not showGrid
  end
end

function love.draw()
  love.graphics.clear(0.035, 0.137, 0.298, 1)

  if showGrid then
    renderGrid()
  end
end

function renderGrid()
  local columns = WINDOW_WIDTH / CELL_SIZE
  local rows = WINDOW_HEIGHT / CELL_SIZE

  love.graphics.setColor(0.224, 0.824, 0.604)
  for x = 1, columns do
    for y = 1, rows do
      love.graphics.rectangle("line", (x - 1) * CELL_SIZE, (y - 1) * CELL_SIZE, CELL_SIZE, CELL_SIZE)
    end
  end
end
