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

function GenerateQuads(atlas)
  local quads = {}
  for x = 1, math.floor(atlas:getWidth() / TILE_SIZE) do
    for y = 1, math.floor(atlas:getHeight() / TILE_SIZE) do
      table.insert(
        quads,
        love.graphics.newQuad((x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE, TILE_SIZE, TILE_SIZE, atlas:getDimensions())
      )
    end
  end

  return quads
end

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

  tilesheet = love.graphics.newImage("res/tilesheet.png")
  quads = GenerateQuads(tilesheet)
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

  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(tilesheet, quads[1], 0, 0)
  love.graphics.draw(tilesheet, quads[2], TILE_SIZE, 0)
  love.graphics.draw(tilesheet, quads[3], TILE_SIZE * 2, TILE_SIZE)
  love.graphics.draw(tilesheet, quads[4], TILE_SIZE * 3, 0)
end
