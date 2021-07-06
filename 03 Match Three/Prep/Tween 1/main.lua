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

BIRD_IMAGE = love.graphics.newImage("res/graphics/bird.png")
BIRD_WIDTH = BIRD_IMAGE:getWidth()
BIRD_HEIGHT = BIRD_IMAGE:getHeight()

TIMER_MAX = 10

function love.load()
  math.randomseed(os.time())

  timer = 0

  birds = {}
  for i = 1, 100 do
    table.insert(
      birds,
      {
        x = 0,
        y = math.random(0, VIRTUAL_HEIGHT - BIRD_HEIGHT),
        duration = math.random() * TIMER_MAX
      }
    )
  end

  love.window.setTitle("Tween")
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

  if key == "r" then
    timer = 0
    for k, bird in pairs(birds) do
      bird.x = 0
      bird.y = math.random(0, VIRTUAL_HEIGHT - BIRD_HEIGHT)
      -- bird.duration = math.random(TIMER_MAX)
      bird.duration = math.random() * TIMER_MAX
    end
  end
end

function love.update(dt)
  if timer < TIMER_MAX then
    timer = timer + dt
    for k, bird in pairs(birds) do
      bird.x = math.min(VIRTUAL_WIDTH - BIRD_WIDTH, bird.x + (VIRTUAL_WIDTH - BIRD_WIDTH) / bird.duration * dt)
    end
  end
end

function love.draw()
  push:start()

  love.graphics.print(timer, 8, 8)
  for k, bird in pairs(birds) do
    love.graphics.draw(BIRD_IMAGE, bird.x, bird.y)
  end

  push:finish()
end
