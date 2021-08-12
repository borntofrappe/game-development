TILE_SIZE = 16

local WINDOW_WIDTH = 500
local WINDOW_HEIGHT = 360
local SCALE = 5
local ANIMATION_INTERVAL = 0.15

require "Utils"
require "Animation"

function love.load()
  love.window.setTitle("Animation")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.99, 0.97, 0.95)

  love.graphics.setDefaultFilter("nearest", "nearest")

  gTextures = {
    ["spritesheet"] = love.graphics.newImage("spritesheet.png")
  }

  gQuads = {
    ["player"] = GenerateQuadsPlayer(gTextures["spritesheet"]),
    ["dog"] = GenerateQuadsDog(gTextures["spritesheet"])
  }

  local playerFrames = {}
  for i = 1, #gQuads["player"] do
    table.insert(playerFrames, i)
  end

  idleAnimation = Animation:new({1}, 1)
  walkingAnimation = Animation:new(playerFrames, ANIMATION_INTERVAL)

  playerAnimation = idleAnimation

  local dogFrames = {}
  for i = 1, #gQuads["dog"] do
    table.insert(dogFrames, i)
  end
  dogAnimation = Animation:new(dogFrames, ANIMATION_INTERVAL)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
  dogAnimation:update(dt)
  playerAnimation:update(dt)

  if love.keyboard.isDown("down") then
    playerAnimation = walkingAnimation
  else
    playerAnimation = idleAnimation
  end
end

function love.draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(
    gTextures["spritesheet"],
    gQuads["player"][playerAnimation:getCurrentFrame()],
    WINDOW_WIDTH / 2 - TILE_SIZE * SCALE / 2,
    WINDOW_HEIGHT / 2 - TILE_SIZE * SCALE / 2,
    0,
    SCALE,
    SCALE
  )

  love.graphics.draw(
    gTextures["spritesheet"],
    gQuads["dog"][dogAnimation:getCurrentFrame()],
    WINDOW_WIDTH - TILE_SIZE * SCALE - 16,
    WINDOW_HEIGHT - TILE_SIZE * SCALE - 16,
    0,
    SCALE,
    SCALE
  )
end
