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

  board = generateBoard()

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

  drawBoard(128, 16)

  push:finish()
end

function generateBoard()
  local tiles = {}
  local width = 32
  local height = 32
  for y = 1, 8 do
    table.insert(tiles, {})
    for x = 1, 8 do
      table.insert(
        tiles[y],
        {
          x = (x - 1) * width,
          y = (y - 1) * height,
          color = math.random(#gFrames["tiles"]),
          variety = math.random(#gFrames["tiles"][1])
        }
      )
    end
  end
  return tiles
end

function drawBoard(offsetX, offsetY)
  for k, row in ipairs(board) do
    for key, tile in ipairs(row) do
      tile =
        love.graphics.draw(
        gTextures["match3"],
        gFrames["tiles"][tile.color][tile.variety],
        tile.x + offsetX,
        tile.y + offsetY
      )
    end
  end
end
