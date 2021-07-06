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
  counter = 0
  seconds = 0
  interval = 1

  counter2 = 0
  seconds2 = 0
  interval2 = 0.5

  counter3 = 0
  seconds3 = 0
  interval3 = 4

  counter4 = 0
  seconds4 = 0
  interval4 = 3

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
  counter = counter + dt
  if counter > interval then
    counter = counter % interval
    seconds = seconds + 1
  end

  counter2 = counter2 + dt
  if counter2 > interval2 then
    counter2 = counter2 % interval2
    seconds2 = seconds2 + 1
  end

  counter3 = counter3 + dt
  if counter3 > interval3 then
    counter3 = counter3 % interval3
    seconds3 = seconds3 + 1
  end

  counter4 = counter4 + dt
  if counter4 > interval4 then
    counter4 = counter4 % interval4
    seconds4 = seconds4 + 1
  end
end

function love.draw()
  push:start()
  love.graphics.printf(
    "Timer:" .. seconds .. " seconds (" .. interval .. "s)",
    0,
    VIRTUAL_HEIGHT / 2 - font:getHeight() / 2 - font:getHeight() * 1.5,
    VIRTUAL_WIDTH,
    "center"
  )

  love.graphics.printf(
    "Timer:" .. seconds2 .. " seconds (" .. interval2 .. "s)",
    0,
    VIRTUAL_HEIGHT / 2 - font:getHeight() / 2 - font:getHeight() * 0.5,
    VIRTUAL_WIDTH,
    "center"
  )

  love.graphics.printf(
    "Timer:" .. seconds3 .. " seconds (" .. interval3 .. "s)",
    0,
    VIRTUAL_HEIGHT / 2 - font:getHeight() / 2 + font:getHeight() * 0.5,
    VIRTUAL_WIDTH,
    "center"
  )

  love.graphics.printf(
    "Timer:" .. seconds4 .. " seconds (" .. interval4 .. "s)",
    0,
    VIRTUAL_HEIGHT / 2 - font:getHeight() / 2 + font:getHeight() * 1.5,
    VIRTUAL_WIDTH,
    "center"
  )
  push:finish()
end
