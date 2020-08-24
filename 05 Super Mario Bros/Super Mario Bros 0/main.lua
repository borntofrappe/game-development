require "src/Dependencies"

function love.load()
  love.window.setTitle("Super Mario Bros")
  math.randomseed(os.time())

  love.graphics.setDefaultFilter("nearest", "nearest")
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  gTextures = {
    ["tiles"] = love.graphics.newImage("res/graphics/tiles.png"),
    ["tops"] = love.graphics.newImage("res/graphics/tile_tops.png"),
    ["backgrounds"] = love.graphics.newImage("res/graphics/backgrounds.png"),
    ["character"] = love.graphics.newImage("res/graphics/character.png")
  }

  gFrames = {
    ["tiles"] = GenerateQuadsTiles(gTextures["tiles"]),
    ["tops"] = GenerateQuadsTileTops(gTextures["tops"]),
    ["backgrounds"] = GenerateQuads(gTextures["backgrounds"], 256, 128),
    ["character"] = GenerateQuads(gTextures["character"], CHARACTER_WIDTH, CHARACTER_HEIGHT)
  }

  variety_backgrounds = math.random(#gFrames.backgrounds)
  variety_tiles = math.random(#gFrames.tiles)
  variety_tops = math.random(#gFrames.tops)

  characterX = VIRTUAL_WIDTH / 2 - CHARACTER_WIDTH / 2
  characterY = TILE_SIZE * (ROWS_SKY - 1) - CHARACTER_HEIGHT
  characterDY = 0
  jumping = false

  cameraScroll = 0

  idleAnimation =
    Animation(
    {
      frames = {1},
      interval = 1
    }
  )

  movingAnimation =
    Animation(
    {
      frames = {10, 11},
      interval = 0.2
    }
  )

  jumpingAnimation =
    Animation(
    {
      frames = {3},
      interval = 0.3
    }
  )

  currentAnimation = idleAnimation
  direction = "right"

  mapWidth = 30
  mapHeight = 20
  tiles = GenerateLevel(mapWidth, mapHeight)

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
    variety_backgrounds = math.random(#gFrames.backgrounds)
    variety_tiles = math.random(#gFrames.tiles)
    variety_tops = math.random(#gFrames.tops)
  elseif key == "space" then
    if not jumping then
      jumping = true
      characterDY = -CHARACTER_JUMP_SPEED
      currentAnimation = jumpingAnimation
    end
  end
end

function love.update(dt)
  currentAnimation:update(dt)

  if love.keyboard.isDown("right") then
    characterX = math.min(mapWidth * TILE_SIZE - CHARACTER_WIDTH, characterX + CHARACTER_MOVEMENT_SPEED * dt)
    direction = "right"
    if not jumping then
      currentAnimation = movingAnimation
    end
  elseif love.keyboard.isDown("left") then
    characterX = math.max(0, characterX - CHARACTER_MOVEMENT_SPEED * dt)
    direction = "left"
    if not jumping then
      currentAnimation = movingAnimation
    end
  else
    if not jumping then
      currentAnimation = idleAnimation
    end
  end

  cameraScroll =
    math.max(0, math.min(mapWidth * TILE_SIZE - VIRTUAL_WIDTH, characterX + CHARACTER_WIDTH / 2 - VIRTUAL_WIDTH / 2))

  if jumping then
    characterDY = characterDY + GRAVITY
    characterY = characterY + characterDY * dt
  end

  if characterY > TILE_SIZE * (ROWS_SKY - 1) - CHARACTER_HEIGHT then
    characterY = TILE_SIZE * (ROWS_SKY - 1) - CHARACTER_HEIGHT
    characterDY = 0
    jumping = false
    currentAnimation = idleAnimation
  end
end

function love.resize(width, height)
  push:resize(width, height)
end

function love.draw()
  push:start()

  love.graphics.draw(gTextures["backgrounds"], gFrames["backgrounds"][variety_backgrounds], 0, 0)
  love.graphics.translate(-math.floor(cameraScroll), 0)
  love.graphics.setColor(1, 1, 1, 1)

  for x, column in ipairs(tiles) do
    for y, tile in ipairs(column) do
      love.graphics.draw(
        gTextures["tiles"],
        gFrames["tiles"][variety_tiles][tile.id],
        (x - 1) * TILE_SIZE,
        (y - 1) * TILE_SIZE
      )
      if tile.topper then
        love.graphics.draw(
          gTextures["tops"],
          gFrames["tops"][variety_tops][1],
          (x - 1) * TILE_SIZE,
          (y - 1) * TILE_SIZE
        )
      end
    end
  end

  love.graphics.draw(
    gTextures["character"],
    gFrames["character"][currentAnimation:getCurrentFrame()],
    direction == "right" and math.floor(characterX) or math.floor(characterX + CHARACTER_WIDTH),
    math.floor(characterY),
    0,
    direction == "right" and 1 or -1,
    1
  )

  push:finish()
end

function GenerateLevel(width, height)
  local tiles = {}
  for x = 1, width do
    tiles[x] = {}

    local rows_sky = ROWS_SKY

    local isChasm = math.random(5) == 1
    if isChasm then
      rows_sky = height
    else
      local isPillar = math.random(5) == 1
      if isPillar then
        rows_sky = rows_sky - 2
      end
    end

    for y = 1, height do
      local tile = {
        id = y < rows_sky and TILE_SKY or TILE_GROUND,
        topper = y == rows_sky
      }
      tiles[x][y] = tile
    end
  end

  return tiles
end
