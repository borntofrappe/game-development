Timer = require "Timer"

WINDOW_WIDTH = 480
WINDOW_HEIGHT = 480

function love.load()
  love.window.setTitle("Delay")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  point = nil
  points = {}
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function addPoint(x, y)
  Timer:after(
    0.05,
    function()
      local point = {
        ["cx"] = x,
        ["cy"] = y,
        ["r"] = love.math.random(4, 12)
      }
      table.insert(points, point)
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
end
