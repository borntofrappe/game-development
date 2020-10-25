require "src/Dependencies"

function love.load()
  math.randomseed(os.time())
  love.window.setTitle("Tetris")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(
    gColors["background"].r,
    gColors["background"].g,
    gColors["background"].b,
    gColors["background"].a
  )

  grid = {
    ["columns"] = COLUMNS,
    ["rows"] = ROWS
  }

  showGrid = false

  score =
    DescriptionList:new(
    {
      ["term"] = "Score",
      ["description"] = 123,
      ["column"] = 4 + grid.columns,
      ["row"] = 2,
      ["width"] = 5,
      ["height"] = 3
    }
  )

  lines =
    DescriptionList:new(
    {
      ["term"] = "Lines",
      ["description"] = 4,
      ["column"] = 4 + grid.columns,
      ["row"] = 6,
      ["width"] = 5,
      ["height"] = 2
    }
  )

  panel =
    Panel:new(
    {
      ["column"] = 4.5 + grid.columns,
      ["row"] = 9,
      ["width"] = 4,
      ["height"] = 4
    }
  )

  tetriminoses = {
    ["current"] = Tetriminos:new(
      {
        ["column"] = 5,
        ["row"] = 4
      }
    ),
    ["next"] = Tetriminos:new(
      {
        ["column"] = 4 + grid.columns,
        ["row"] = 9
      }
    )
  }

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

  if love.keyboard.wasPressed("space") then
    tetriminoses.current.color = math.random(#gFrames["tiles"] - 1)
  end

  if love.keyboard.wasPressed("up") then
    tetriminoses.current.row = tetriminoses.current.row - 1
  elseif love.keyboard.wasPressed("right") then
    tetriminoses.current.column = tetriminoses.current.column + 1
  elseif love.keyboard.wasPressed("down") then
    tetriminoses.current.row = tetriminoses.current.row + 1
  elseif love.keyboard.wasPressed("left") then
    tetriminoses.current.column = tetriminoses.current.column - 1
  end

  love.keyboard.keyPressed = {}
end

function love.draw()
  for row = 1, grid.rows + 1 do
    love.graphics.draw(gTextures["tiles"], gFrames["tiles"][#gFrames["tiles"]], 0, (row - 1) * TILE_SIZE)
    love.graphics.draw(
      gTextures["tiles"],
      gFrames["tiles"][#gFrames["tiles"]],
      TILE_SIZE + grid.columns * TILE_SIZE,
      (row - 1) * TILE_SIZE
    )
  end

  score:render()
  lines:render()
  panel:render()
  tetriminoses.current:render()
  tetriminoses.next:render()

  if showGrid then
    love.graphics.setLineWidth(1)
    love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, 0.5)
    for column = 1, math.floor(WINDOW_WIDTH / TILE_SIZE) + 1 do
      love.graphics.line((column - 1) * TILE_SIZE, 0, (column - 1) * TILE_SIZE, WINDOW_HEIGHT)
    end
    for row = 1, math.floor(WINDOW_HEIGHT / TILE_SIZE) + 1 do
      love.graphics.line(0, (row - 1) * TILE_SIZE, WINDOW_WIDTH, (row - 1) * TILE_SIZE)
    end
    love.graphics.setColor(1, 1, 1, 1)
  end
end
