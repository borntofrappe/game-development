WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 384
VIRTUAL_HEIGHT = 216

OPTIONS = {
  fullscreen = false,
  vsync = true,
  resizable = true
}

push = require "res/lib/push"
Timer = require("res/lib/knife/timer")

function love.load()
  intervals = {1, 0.5, 4, 3, 2}
  seconds = {0, 0, 0, 0, 0}

  for i, interval in ipairs(intervals) do
    Timer.every(
      interval,
      function()
        seconds[i] = seconds[i] + 1
      end
    )
  end

  love.window.setTitle("Timer")
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
  Timer.update(dt)
end

function love.draw()
  push:start()

  for i, interval in ipairs(intervals) do
    love.graphics.printf(
      "Timer:" .. seconds[i] .. " seconds (" .. interval .. "s)",
      0,
      VIRTUAL_HEIGHT / 2 - font:getHeight() / 2 + font:getHeight() * (i - #intervals / 2),
      VIRTUAL_WIDTH,
      "center"
    )
  end

  push:finish()
end
