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

BIRD_IMAGE = love.graphics.newImage("bird.png")
BIRD_WIDTH = BIRD_IMAGE:getWidth()
BIRD_HEIGHT = BIRD_IMAGE:getHeight()

RATE = 2

function love.load()
  timer = 0

  bird = {
    x = 0,
    y = 0
  }

  baseX = 0
  baseY = 0

  destinations = {
    [1] = {x = VIRTUAL_WIDTH - BIRD_WIDTH, y = 0},
    [2] = {x = VIRTUAL_WIDTH - BIRD_WIDTH, y = VIRTUAL_HEIGHT - BIRD_HEIGHT},
    [3] = {x = 0, y = VIRTUAL_HEIGHT - BIRD_HEIGHT},
    [4] = {x = 0, y = 0}
  }

  for k, destination in pairs(destinations) do
    destination.reached = false
  end

  love.window.setTitle("Chain")
  font = love.graphics.newFont("res/fonts/font.ttf", 24)
  love.graphics.setFont(font)

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
  timer = math.min(RATE, timer + dt)
  for i, destination in ipairs(destinations) do
    if not destination.reached then
      bird.x = baseX + (destination.x - baseX) / RATE * timer
      bird.y = baseY + (destination.y - baseY) / RATE * timer

      if timer == RATE then
        destination.reached = true
        baseX = destination.x
        baseY = destination.y
        timer = i == 4 and timer or 0
      end

      break
    end
  end
end

function love.draw()
  push:start()
  love.graphics.printf(timer, 0, VIRTUAL_HEIGHT / 2 - 14, VIRTUAL_WIDTH, "center")

  love.graphics.draw(BIRD_IMAGE, bird.x, bird.y)

  push:finish()
end
