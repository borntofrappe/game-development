Timer = require "Timer"

WINDOW_WIDTH = 480
WINDOW_HEIGHT = 480

function love.load()
  love.window.setTitle("Timer")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  counter = 0
  points = {}

  Timer:every(
    1,
    function()
      counter = counter + 1
    end,
    "counter"
  )
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "r" then
    Timer:remove("counter")
  end
end

function love.mousepressed(x, y, button)
  if button == 1 then
    Timer:after(
      1,
      function()
        table.insert(
          points,
          {
            ["cx"] = x,
            ["cy"] = y,
            ["r"] = love.math.random(5, 15)
          }
        )
      end
    )
  end
end

function love.update(dt)
  Timer:update(dt)
end

function love.draw()
  love.graphics.setColor(0.3, 0.3, 0.3)
  for i, point in ipairs(points) do
    love.graphics.circle("fill", point.cx, point.cy, point.r)
  end
  love.graphics.print(counter, 8, 8)
end
