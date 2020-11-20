Timer = require "Timer"

WINDOW_WIDTH = 480
WINDOW_HEIGHT = 480

function love.load()
  love.window.setTitle("Timer")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  point = nil
  points = {}

  seconds = 0
  Timer:every(
    1,
    function()
      seconds = seconds + 1
    end,
    "seconds"
  )
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "r" then
    Timer:remove("seconds")
  end
end

function addPoint(x, y)
  Timer:after(
    0.05,
    function()
      table.insert(
        points,
        {
          ["cx"] = x,
          ["cy"] = y,
          ["r"] = love.math.random(4, 12)
        }
      )
    end
  )
end

function love.update(dt)
  if love.mouse.isDown(1) then
    if point then
      local x, y = love.mouse:getPosition()
      if x ~= point.x and y ~= point.y then
        point.x = x
        point.y = y
        addPoint(point.x, point.y)
      end
    else
      local x, y = love.mouse:getPosition()
      point = {
        ["x"] = x,
        ["y"] = y
      }
      addPoint(point.x, point.y)
    end
  end

  Timer:update(dt)
end

function love.draw()
  love.graphics.setColor(0.3, 0.3, 0.3)
  for i, point in ipairs(points) do
    love.graphics.circle("fill", point.cx, point.cy, point.r)
  end

  love.graphics.print("Elapsed time: " .. seconds .. " seconds", 8, 8)
  love.graphics.print("Press r to stop counting", 8, 24)
end
