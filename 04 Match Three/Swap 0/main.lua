require "src/Dependencies"

function love.load()
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
end

function love.update(dt)
end

function love.draw()
  push:start()

  love.graphics.draw(gTextures["background"], 0, 0)

  love.graphics.translate(VIRTUAL_WIDTH / 2 - #board[1] * TILE_WIDTH / 2, VIRTUAL_HEIGHT / 2 - #board * TILE_HEIGHT / 2)
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
          color = math.random(#gFrames["tiles"]),
          variety = math.random(#gFrames["tiles"][1])
        }
      )
    end
  end
  return tiles
end

function drawBoard(board)
  for y, row in ipairs(board) do
    for x, tile in ipairs(row) do
      love.graphics.draw(
        gTextures["match3"],
        gFrames["tiles"][tile.color][tile.variety],
        (x - 1) * TILE_WIDTH,
        (y - 1) * TILE_HEIGHT
      )
    end
  end
end
