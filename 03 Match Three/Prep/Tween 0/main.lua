push = require "res/lib/push"

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 384
VIRTUAL_HEIGHT = 216

OPTIONS = {
  fullscreen = false,
  vsync = true,
  resizable = true
}

MOVE_DURATION = 2

BIRD_IMAGE = love.graphics.newImage("res/graphics/bird.png")
BIRD_WIDTH = BIRD_IMAGE:getWidth()
BIRD_HEIGHT = BIRD_IMAGE:getHeight()

function love.load()
  love.window.setTitle("Tween")
  font = love.graphics.newFont("res/fonts/font.ttf", 24)
  love.graphics.setFont(font)

  love.graphics.setDefaultFilter("nearest", "nearest")
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  timer = 0

  bird = {
    x = 0,
    y = VIRTUAL_HEIGHT / 2 - BIRD_HEIGHT / 2
  }
end

function love.resize(width, height)
  push:resize(width, height)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "r" then
    bird.x = 0
    timer = 0
  end
end

function love.update(dt)
  if timer < MOVE_DURATION then
    timer = timer + dt
    bird.x = math.min(VIRTUAL_WIDTH - BIRD_WIDTH, bird.x + (VIRTUAL_WIDTH - BIRD_WIDTH) / MOVE_DURATION * dt)
  end
end

function love.draw()
  push:start()

  love.graphics.print(timer, 8, 8)
  love.graphics.draw(BIRD_IMAGE, bird.x, bird.y)

  push:finish()
end
