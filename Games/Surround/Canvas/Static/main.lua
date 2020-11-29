WINDOW_WIDTH = 520
WINDOW_HEIGHT = 380
CANVAS_WIDTH = math.floor(WINDOW_WIDTH / 2)
CANVAS_HEIGHT = 380
CELL_SIZE = 20

function love.load()
  love.window.setTitle("Static Canvas")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  grid = {}
  for column = 1, math.floor(CANVAS_WIDTH / CELL_SIZE) do
    grid[column] = {}
    for row = 1, math.floor(CANVAS_HEIGHT / CELL_SIZE) do
      local everyOther = (column + row) % 2 == 1
      local color =
        everyOther and
        {
          ["r"] = 0.15,
          ["g"] = 0.66,
          ["b"] = 0.88,
          ["a"] = 0.65
        } or
        {
          ["r"] = 0.9,
          ["g"] = 0.29,
          ["b"] = 0.6,
          ["a"] = 0.65
        }

      grid[column][row] = {
        ["column"] = column,
        ["row"] = row,
        ["size"] = CELL_SIZE,
        ["color"] = color
      }
    end
  end

  canvas = love.graphics.newCanvas(CANVAS_WIDTH, CANVAS_HEIGHT)
  love.graphics.setCanvas(canvas)
  love.graphics.clear()
  for c = 1, #grid do
    for r = 1, #grid[c] do
      love.graphics.setColor(grid[c][r].color.r, grid[c][r].color.g, grid[c][r].color.b, grid[c][r].color.a)
      love.graphics.rectangle(
        "fill",
        (grid[c][r].column - 1) * grid[c][r].size,
        (grid[c][r].row - 1) * grid[c][r].size,
        grid[c][r].size,
        grid[c][r].size
      )
    end
  end
  love.graphics.setCanvas()
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.draw()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setBlendMode("alpha", "premultiplied")
  love.graphics.draw(canvas)

  love.graphics.translate(CANVAS_WIDTH, 0)
  love.graphics.setBlendMode("alpha")
  love.graphics.draw(canvas)
end
