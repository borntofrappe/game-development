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

function love.load()
  timer = 0
  seconds = 0

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
  timer = timer + dt
  if timer > 1 then
    timer = timer % 1
    seconds = seconds + 1
  end
end

function love.draw()
  push:start()
  love.graphics.printf(
    "Timer:" .. seconds .. " seconds",
    0,
    VIRTUAL_HEIGHT / 2 - font:getHeight() / 2,
    VIRTUAL_WIDTH,
    "center"
  )
  push:finish()
end
