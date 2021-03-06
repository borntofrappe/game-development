push = require "res/lib/push"
Timer = require "res/lib/timer"

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
        opacity = 0,
        duration = math.random() * TIMER_MAX
      }
    )
  end

  for k, bird in pairs(birds) do
    Timer.tween(
      bird.duration,
      {
        [bird] = {x = VIRTUAL_WIDTH - BIRD_WIDTH, opacity = 1}
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
    Timer.clear()

    timer = 0

    for k, bird in pairs(birds) do
      bird.x = 0
      bird.y = math.random(0, VIRTUAL_HEIGHT - BIRD_HEIGHT)
      bird.opacity = 0
      bird.duration = math.random() * TIMER_MAX
      Timer.tween(
        bird.duration,
        {
          [bird] = {x = VIRTUAL_WIDTH - BIRD_WIDTH, opacity = 1}
        }
      )
    end
  end
end

function love.update(dt)
  if timer < TIMER_MAX then
    timer = timer + dt
    Timer.update(dt)
  end
end

function love.draw()
  push:start()

  love.graphics.print(timer, 8, 8)
  for k, bird in pairs(birds) do
    love.graphics.setColor(1, 1, 1, bird.opacity)
    love.graphics.draw(BIRD_IMAGE, bird.x, bird.y)
  end

  push:finish()
end
