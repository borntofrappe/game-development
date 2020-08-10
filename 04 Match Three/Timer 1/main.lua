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

  timer2 = 0
  seconds2 = 0

  timer3 = 0
  seconds3 = 0

  timer4 = 0
  seconds4 = 0

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

  timer2 = timer2 + dt
  if timer2 > 0.5 then
    timer2 = timer2 % 0.5
    seconds2 = seconds2 + 1
  end

  timer3 = timer3 + dt
  if timer3 > 4 then
    timer3 = timer3 % 4
    seconds3 = seconds3 + 1
  end

  timer4 = timer4 + dt
  if timer4 > 3 then
    timer4 = timer4 % 3
    seconds4 = seconds4 + 1
  end
end

function love.draw()
  push:start()
  love.graphics.printf(
    "Timer:" .. seconds .. " seconds (1s)",
    0,
    VIRTUAL_HEIGHT / 2 - 12 - 28 - 2,
    VIRTUAL_WIDTH,
    "center"
  )

  love.graphics.printf(
    "Timer:" .. seconds2 .. " seconds (0.5s)",
    0,
    VIRTUAL_HEIGHT / 2 - 12 - 1,
    VIRTUAL_WIDTH,
    "center"
  )

  love.graphics.printf("Timer:" .. seconds3 .. " seconds (4s)", 0, VIRTUAL_HEIGHT / 2 + 12 + 1, VIRTUAL_WIDTH, "center")

  love.graphics.printf(
    "Timer:" .. seconds4 .. " seconds (3s)",
    0,
    VIRTUAL_HEIGHT / 2 + 12 + 28 + 2,
    VIRTUAL_WIDTH,
    "center"
  )
  push:finish()
end
