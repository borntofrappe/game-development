require "src/Dependencies"

function love.load()
  love.window.setTitle("Tiles")
  math.randomseed(os.time())

  love.graphics.setDefaultFilter("nearest", "nearest")
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  gTextures = {
    ["tiles"] = love.graphics.newImage("res/graphics/tiles2.png"),
    ["character"] = love.graphics.newImage("res/graphics/character.png")
  }

  gFrames = {
    ["tiles"] = GenerateQuads(gTextures["tiles"], TILE_SIZE, TILE_SIZE),
    ["character"] = GenerateQuads(gTextures["character"], CHARACTER_WIDTH, CHARACTER_HEIGHT)
  }

  characterX = VIRTUAL_WIDTH / 2 - CHARACTER_WIDTH / 2
  characterY = TILE_SIZE * (ROWS_SKY - 1) - CHARACTER_HEIGHT

  cameraScroll = 0

  tiles = {}
  mapWidth = 30
  mapHeight = 20

  for y = 1, mapHeight do
    tiles[y] = {}
    for x = 1, mapWidth do
      local tile = {id = y < ROWS_SKY and TILE_SKY or TILE_GROUND}
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

function love.update(dt)
  if love.keyboard.isDown("right") then
    characterX = math.min(mapWidth * TILE_SIZE - CHARACTER_WIDTH, characterX + CHARACTER_MOVEMENT_SPEED * dt)
  elseif love.keyboard.isDown("left") then
    characterX = math.max(0, characterX - CHARACTER_MOVEMENT_SPEED * dt)
  end

  cameraScroll =
    math.max(0, math.min(mapWidth * TILE_SIZE - VIRTUAL_WIDTH, characterX + CHARACTER_WIDTH / 2 - VIRTUAL_WIDTH / 2))
end

function love.resize(width, height)
  push:resize(width, height)
end

function love.draw()
  push:start()

  love.graphics.setColor(background.r, background.g, background.b, 1)
  love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

  love.graphics.translate(-math.floor(cameraScroll), 0)
  love.graphics.setColor(1, 1, 1, 1)
  for y = 1, mapHeight do
    for x = 1, mapWidth do
      local tile = tiles[y][x]
      love.graphics.draw(gTextures["tiles"], gFrames["tiles"][tile.id], (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE)
    end
  end

  love.graphics.draw(gTextures["character"], gFrames["character"][1], math.floor(characterX), math.floor(characterY))

  push:finish()
end
