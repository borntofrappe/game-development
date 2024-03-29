require "src/Dependencies"

function love.load()
  math.randomseed(os.time())
  love.window.setTitle("Swap")
  font = love.graphics.newFont("res/fonts/font.ttf", 24)
  love.graphics.setFont(font)

  gTextures = {
    ["background"] = love.graphics.newImage("res/graphics/background.png"),
    ["match3"] = love.graphics.newImage("res/graphics/match3.png")
  }

  gFrames = {
    ["tiles"] = GenerateQuadsTiles(gTextures["match3"])
  }

  board = generateBoard(ROWS, COLUMNS)

  selectedTile = {
    x = math.random(COLUMNS),
    y = math.random(ROWS)
  }

  highlightedTile = nil

  love.graphics.setDefaultFilter("nearest", "nearest")
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)
end

function love.resize(width, height)
  push:resize(width, height)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "right" then
    selectedTile.x = math.min(COLUMNS, selectedTile.x + 1)
  end

  if key == "left" then
    selectedTile.x = math.max(1, selectedTile.x - 1)
  end

  if key == "up" then
    selectedTile.y = math.max(1, selectedTile.y - 1)
  end

  if key == "down" then
    selectedTile.y = math.min(ROWS, selectedTile.y + 1)
  end

  if key == "enter" or key == "return" then
    if not highlightedTile then
      highlightedTile = {
        x = selectedTile.x,
        y = selectedTile.y
      }
    else
      local tile1 = board[selectedTile.y][selectedTile.x]
      local tile2 = board[highlightedTile.y][highlightedTile.x]
      if math.abs(tile1.x - tile2.x) + math.abs(tile1.y - tile2.y) == 1 then
        tempX, tempY = tile1.x, tile1.y

        Timer.tween(
          0.2,
          {
            [tile1] = {x = tile2.x, y = tile2.y},
            [tile2] = {x = tempX, y = tempY}
          }
        )

        board[tile1.y][tile1.x], board[tile2.y][tile2.x] = board[tile2.y][tile2.x], board[tile1.y][tile1.x]
      end

      highlightedTile = nil
    end
  end
end

function love.update(dt)
  Timer.update(dt)
end

function love.draw()
  push:start()

  love.graphics.draw(gTextures["background"], 0, 0)

  drawBoard(board)

  push:finish()
end

function generateBoard(rows, columns)
  local tiles = {}
  for y = 1, rows do
    table.insert(tiles, {})
    for x = 1, columns do
      table.insert(
        tiles[y],
        {
          x = x,
          y = y,
          color = math.random(#gFrames["tiles"]),
          variety = math.random(#gFrames["tiles"][1])
        }
      )
    end
  end
  return tiles
end

function drawBoard(board)
  love.graphics.translate(VIRTUAL_WIDTH / 2 - #board[1] * TILE_WIDTH / 2, VIRTUAL_HEIGHT / 2 - #board * TILE_HEIGHT / 2)

  for y, row in ipairs(board) do
    for x, tile in ipairs(row) do
      love.graphics.draw(
        gTextures["match3"],
        gFrames["tiles"][tile.color][tile.variety],
        (tile.x - 1) * TILE_WIDTH,
        (tile.y - 1) * TILE_HEIGHT
      )
    end
  end

  if highlightedTile then
    love.graphics.setColor(1, 1, 1, 0.4)
    love.graphics.rectangle(
      "fill",
      (highlightedTile.x - 1) * TILE_WIDTH,
      (highlightedTile.y - 1) * TILE_HEIGHT,
      TILE_WIDTH,
      TILE_HEIGHT,
      4
    )
    love.graphics.setColor(1, 1, 1, 1)
  end

  love.graphics.setLineWidth(4)
  love.graphics.setColor(1, 0.1, 0.1, 1)
  love.graphics.rectangle(
    "line",
    (selectedTile.x - 1) * TILE_WIDTH,
    (selectedTile.y - 1) * TILE_HEIGHT,
    TILE_WIDTH,
    TILE_HEIGHT,
    4
  )
end
