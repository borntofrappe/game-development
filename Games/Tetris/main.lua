TILE_SIZE = 24
COLUMNS = 10
ROWS = 15
PADDING = {
  ["top"] = 64,
  ["left"] = 64,
  ["right"] = 64,
  ["bottom"] = 32
}

WINDOW_WIDTH = TILE_SIZE * COLUMNS + PADDING.left + PADDING.right
WINDOW_HEIGHT = TILE_SIZE * ROWS + PADDING.top + PADDING.bottom

function love.load()
  love.window.setTitle("Tetris")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.1, 0.15, 0.18)

  grid = {
    ["columns"] = COLUMNS,
    ["rows"] = ROWS,
    ["cellSize"] = TILE_SIZE
  }

  score = 0

  gFonts = {
    ["big"] = love.graphics.newFont("res/font.ttf", 36),
    ["normal"] = love.graphics.newFont("res/font.ttf", 20),
    ["small"] = love.graphics.newFont("res/font.ttf", 14)
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
  love.graphics.translate(PADDING.left, PADDING.top)
  love.graphics.setLineWidth(2)
  love.graphics.setColor(0.9, 0.9, 0.9)
  for x = 1, grid.columns + 1 do
    love.graphics.line((x - 1) * grid.cellSize, 0, (x - 1) * grid.cellSize, grid.rows * grid.cellSize)
  end
  for y = 1, grid.rows + 1 do
    love.graphics.line(0, (y - 1) * grid.cellSize, grid.columns * grid.cellSize, (y - 1) * grid.cellSize)
  end
end
