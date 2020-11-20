Timer = require "Timer"

WINDOW_WIDTH = 480
WINDOW_HEIGHT = 480

function love.load()
  love.window.setTitle("Tween")
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
        ["r"] = love.math.random(5, 20)
      }
      table.insert(points, point)
      Timer:tween(1, {[point] = {r = 0}})
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

  for i, point in ipairs(points) do
    if point.r == 0 then
      table.remove(points, i)
    end
  end

  Timer:update(dt)
end

function love.draw()
  love.graphics.setColor(0.3, 0.3, 0.3)
  for i, point in ipairs(points) do
    love.graphics.circle("fill", point.cx, point.cy, point.r)
  end

  -- love.graphics.print("There are " .. #Timer.tweens .. " tweens", 8, 8)
  -- love.graphics.print("There are " .. #points .. " circles", 8, 24)
end
