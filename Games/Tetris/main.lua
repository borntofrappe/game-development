require "src/Dependencies"

function love.load()
  math.randomseed(os.time())
  love.window.setTitle("Tetris")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.98, 0.92, 0.87)

  grid = {
    ["columns"] = COLUMNS,
    ["rows"] = ROWS,
    ["cellSize"] = TILE_SIZE
  }
  showGrid = false

  score =
    DescriptionList:new(
    {
      ["term"] = "Score",
      ["description"] = 123,
      ["x"] = TILE_SIZE * 3 + TILE_SIZE * grid.columns,
      ["y"] = 16,
      ["width"] = TILE_SIZE * 5,
      ["height"] = TILE_SIZE * 2.5,
      ["padding"] = 8
    }
  )

  lines =
    DescriptionList:new(
    {
      ["term"] = "Lines",
      ["description"] = 4,
      ["x"] = TILE_SIZE * 3 + TILE_SIZE * grid.columns,
      ["y"] = 32 + TILE_SIZE * 2.5,
      ["width"] = TILE_SIZE * 5,
      ["height"] = TILE_SIZE * 2,
      ["padding"] = 8
    }
  )

  panel =
    Panel:new(
    {
      ["x"] = TILE_SIZE * 3 + TILE_SIZE * grid.columns + TILE_SIZE / 2,
      ["y"] = 64 + TILE_SIZE * 4.5,
      ["width"] = TILE_SIZE * 4,
      ["height"] = TILE_SIZE * 4
    }
  )

  tetriminos =
    Tetriminos:new(
    {
      ["x"] = TILE_SIZE * 3 + TILE_SIZE * grid.columns + TILE_SIZE,
      ["y"] = 64 + TILE_SIZE * 5.5
    }
  )

  love.keyboard.keyPressed = {}
end

function love.keypressed(key)
  love.keyboard.keyPressed[key] = true
end

function love.keyboard.wasPressed(key)
  return love.keyboard.keyPressed[key]
end

function love.update(dt)
  if love.keyboard.wasPressed("escape") then
    love.event.quit()
  end
  if love.keyboard.wasPressed("g") then
    showGrid = not showGrid
  end

  love.keyboard.keyPressed = {}
end

function love.draw()
  for y = 1, grid.rows + 1 do
    love.graphics.draw(gTextures["tiles"], gFrames["tiles"][TILE_BACKGROUND], 0, (y - 1) * grid.cellSize)
    love.graphics.draw(
      gTextures["tiles"],
      gFrames["tiles"][TILE_BACKGROUND],
      grid.cellSize + grid.columns * grid.cellSize,
      (y - 1) * grid.cellSize
    )
  end

  score:render()
  lines:render()
  panel:render()
  tetriminos:render()

  if showGrid then
    love.graphics.setLineWidth(1)
    love.graphics.setColor(0.1, 0.1, 0.1, 0.25)
    for x = 1, grid.columns + 1 do
      love.graphics.line(
        TILE_SIZE + (x - 1) * grid.cellSize,
        0,
        TILE_SIZE + (x - 1) * grid.cellSize,
        grid.rows * grid.cellSize
      )
    end
    for y = 1, grid.rows + 1 do
      love.graphics.line(
        TILE_SIZE,
        (y - 1) * grid.cellSize,
        TILE_SIZE + grid.columns * grid.cellSize,
        (y - 1) * grid.cellSize
      )
    end
  end
end
