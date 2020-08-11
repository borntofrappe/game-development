push = require "res/lib/push"
Timer = require "res/lib/knife/timer"

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

  Timer.tween(
    RATE,
    {
      [bird] = {x = VIRTUAL_WIDTH - BIRD_WIDTH, y = 0}
    }
  ):finish(
    function()
      timer = 0
      Timer.tween(
        RATE,
        {
          [bird] = {x = VIRTUAL_WIDTH - BIRD_WIDTH, y = VIRTUAL_HEIGHT - BIRD_HEIGHT}
        }
      ):finish(
        function()
          timer = 0
          Timer.tween(
            RATE,
            {
              [bird] = {x = 0, y = VIRTUAL_HEIGHT - BIRD_HEIGHT}
            }
          ):finish(
            function()
              timer = 0
              Timer.tween(
                RATE,
                {
                  [bird] = {x = 0, y = 0}
                }
              )
            end
          )
        end
      )
    end
  )

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
  Timer.update(dt)
end

function love.draw()
  push:start()
  love.graphics.printf(timer, 0, VIRTUAL_HEIGHT / 2 - 14, VIRTUAL_WIDTH, "center")

  love.graphics.draw(BIRD_IMAGE, bird.x, bird.y)

  push:finish()
end
