require "src/Dependencies"

function love.load()
  love.window.setTitle("Tiles")
  math.randomseed(os.time())

  love.graphics.setDefaultFilter("nearest", "nearest")
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  tilesheet = love.graphics.newImage("res/graphics/tiles2.png")
  quads = GenerateQuads(tilesheet, TILE_SIZE, TILE_SIZE)

  tiles = {}
  mapWidth = 20
  mapHeight = 20

  for y = 1, mapHeight do
    tiles[y] = {}
    for x = 1, mapWidth do
      local tile = {id = y <= math.ceil(VIRTUAL_HEIGHT / TILE_SIZE / 2) and TILE_SKY or TILE_GROUND}
      tiles[y][x] = tile
    end
  end

  background = {
    ["r"] = math.random(255) / 255,
    ["g"] = math.random(255) / 255,
    ["b"] = math.random(255) / 255
  }
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  elseif key == "r" then
    background.r = math.random(255) / 255
    background.g = math.random(255) / 255
    background.b = math.random(255) / 255
  end
end

function love.resize(width, height)
  push:resize(width, height)
end

function love.draw()
  push:start()

  love.graphics.setColor(background.r, background.g, background.b, 1)
  love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

  love.graphics.setColor(1, 1, 1, 1)
  for y = 1, mapHeight do
    for x = 1, mapWidth do
      local tile = tiles[y][x]
      love.graphics.draw(tilesheet, quads[tile.id], (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE)
    end
  end

  push:finish()
end
