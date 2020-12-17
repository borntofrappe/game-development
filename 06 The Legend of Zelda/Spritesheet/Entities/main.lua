-- good luck

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 400
TILE_SIZE = 16
SCALE_SPRITE = math.floor(math.min(WINDOW_WIDTH, WINDOW_HEIGHT) / TILE_SIZE / 3)

function GenerateQuadsEntities(atlas)
  local varietiesMovement = 3
  local directions = {"down", "left", "right", "up"}

  local quads = {}
  local counter = 1

  local characterColumns = math.floor(atlas:getWidth() / TILE_SIZE / varietiesMovement)
  local characterRows = math.floor(atlas:getHeight() / TILE_SIZE / #directions)

  for characterRow = 1, characterRows do
    for characterColumn = 1, characterColumns do
      quads[counter] = {}
      for i, direction in ipairs(directions) do
        quads[counter][direction] = {}
        for j = 1, varietiesMovement do
          quads[counter][direction][j] =
            love.graphics.newQuad(
            (j - 1) * TILE_SIZE + (characterColumn - 1) * TILE_SIZE * varietiesMovement,
            (i - 1) * TILE_SIZE + (characterRow - 1) * TILE_SIZE * #directions,
            TILE_SIZE,
            TILE_SIZE,
            atlas:getDimensions()
          )
        end
      end
      counter = counter + 1
    end
  end

  return quads
end

function love.load()
  love.window.setTitle("Spritesheet — Entities")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)
  love.graphics.setDefaultFilter("nearest")
  gTexture = love.graphics.newImage("entities.png")
  gFrames = GenerateQuadsEntities(gTexture)

  character = {
    ["entity"] = 1,
    ["direction"] = "down",
    ["frame"] = 1
  }
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "up" or key == "right" or key == "down" or key == "left" then
    if character.direction == key then
      character.frame = character.frame == #gFrames[character.entity][character.direction] and 1 or character.frame + 1
    else
      character.direction = key
    end
  end

  if key == "tab" or key == "r" then
    while true do
      local entity = love.math.random(#gFrames)
      if entity ~= character.entity then
        character.entity = entity
        break
      end
    end
  end
end

function love.draw()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(
    gTexture,
    gFrames[character.entity][character.direction][character.frame],
    WINDOW_WIDTH / 2 - TILE_SIZE * SCALE_SPRITE / 2,
    WINDOW_HEIGHT / 2 - TILE_SIZE * SCALE_SPRITE / 2,
    0,
    SCALE_SPRITE,
    SCALE_SPRITE
  )
end
