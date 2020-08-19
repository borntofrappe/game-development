push = require("res/lib/push")

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 256
VIRTUAL_HEIGHT = 144

OPTIONS = {
  fullscreen = false,
  vsync = true,
  resizable = true
}

TILE_SIZE = 16
TILE_GROUND = 1
TILE_SKY = 2

function love.load()
  love.window.setTitle("Tiles")
  math.randomseed(os.time())

  love.graphics.setDefaultFilter("nearest", "nearest")
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  tilesheet = love.graphics.newImage("tiles.png")
  quads = GenerateQuads(tilesheet, TILE_SIZE, TILE_SIZE)

  tiles = {}
  mapWidth = 20
  mapHeight = 20

  for y = 1, mapHeight do
    tiles[y] = {}
    for x = 1, mapWidth do
      local tile = {id = y < 5 and TILE_SKY or TILE_GROUND}
      tiles[y][x] = tile
    end
  end

  background = {
    ["r"] = math.random(255) / 255,
    ["g"] = math.random(255) / 255,
    ["b"] = math.random(255) / 255
  }
end

function love.draw()
  push:start()

  love.graphics.setColor(background.r, background.g, background.b, 1)
  love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

  for y = 1, mapHeight do
    for x = 1, mapWidth do
      local tile = tiles[y][x]
      love.graphics.draw(tilesheet, quads[tile.id], (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE)
    end
  end

  push:finish()
end

function GenerateQuads(atlas, tileWidth, tileHeight)
  local sheetWidth = atlas:getWidth() / tileWidth
  local sheetHeight = atlas:getHeight() / tileHeight

  local counter = 1
  local spritesheet = {}

  for y = 0, sheetHeight - 1 do
    for x = 0, sheetWidth - 1 do
      local sprite = love.graphics.newQuad(x * tileWidth, y * tileHeight, tileWidth, tileHeight, atlas:getDimensions())
      spritesheet[counter] = sprite
      counter = counter + 1
    end
  end

  return spritesheet
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.resize(width, height)
  push:resize(width, height)
end
