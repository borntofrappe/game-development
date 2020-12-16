-- good luck

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 400
CHARACTER_WIDTH = 16
CHARACTER_HEIGHT = 32
SCALE_SPRITE = math.floor(math.min(WINDOW_WIDTH, WINDOW_HEIGHT) / CHARACTER_HEIGHT / 3)

function GenerateQuadsCharacter(atlas)
  local characterWidth = CHARACTER_WIDTH
  local characterHeight = CHARACTER_HEIGHT

  local modes = {"default", "pot-picking", "pot-walking", "sword-slashing"}
  local directions = {"down", "left", "right", "up"}

  local quads = {}

  local x = 0
  local y = 0

  for i, mode in pairs(modes) do
    quads[mode] = {}
    local frames = mode == "pot-picking" and 3 or 4

    y = 0
    if mode == "sword-slashing" then
      x = 0
      y = y + #directions * characterHeight
      characterWidth = CHARACTER_WIDTH * 2
    end

    for j, direction in pairs(directions) do
      quads[mode][direction] = {}
      for frame = 1, frames do
        quads[mode][direction][frame] =
          love.graphics.newQuad(x, y, characterWidth, characterHeight, atlas:getDimensions())
        x = x + characterWidth
      end
      y = y + characterHeight
      x = x - characterWidth * frames
    end

    x = x + characterWidth * frames + CHARACTER_WIDTH
  end

  return quads
end

function love.load()
  love.window.setTitle("Spritesheet — Character")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)
  love.graphics.setDefaultFilter("nearest")
  gTexture = love.graphics.newImage("character.png")
  gFrames = GenerateQuadsCharacter(gTexture)

  character = {
    ["mode"] = "default",
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
      character.frame = character.frame == #gFrames[character.mode][character.direction] and 1 or character.frame + 1
    else
      character.direction = key
      character.frame = 1
    end
  end

  if key == "tab" or key == "r" then
    while true do
      local modes = {"default", "pot-picking", "pot-walking", "sword-slashing"}
      local indexMode = love.math.random(#modes)
      local mode = modes[indexMode]
      if mode ~= character.mode then
        character.mode = mode
        break
      end
    end
  end
end

function love.draw()
  love.graphics.setColor(1, 1, 1, 1)

  if character.mode == "sword-slashing" then
    love.graphics.draw(
      gTexture,
      gFrames[character.mode][character.direction][character.frame],
      WINDOW_WIDTH / 2 - CHARACTER_WIDTH * SCALE_SPRITE / 2 - (CHARACTER_WIDTH / 2 * SCALE_SPRITE),
      WINDOW_HEIGHT / 2 - CHARACTER_HEIGHT * SCALE_SPRITE / 2,
      0,
      SCALE_SPRITE,
      SCALE_SPRITE
    )
  else
    love.graphics.draw(
      gTexture,
      gFrames[character.mode][character.direction][character.frame],
      WINDOW_WIDTH / 2 - CHARACTER_WIDTH * SCALE_SPRITE / 2,
      WINDOW_HEIGHT / 2 - CHARACTER_HEIGHT * SCALE_SPRITE / 2,
      0,
      SCALE_SPRITE,
      SCALE_SPRITE
    )
  end
end
