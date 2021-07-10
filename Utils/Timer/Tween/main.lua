Timer = require "Timer"
require "Point"

local WINDOW_WIDTH = 460
local WINDOW_HEIGHT = 380

local previousCoords  -- keep track of the point to avoid overlapping circles

local points = {}
local DELAY = 0.1

function love.load()
  love.window.setTitle("Tween")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.94, 0.94, 0.94)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function addPoint(x, y)
  Timer:after(
    DELAY,
    function()
      local point = Point:new(x, y)
      table.insert(points, point)

      Timer:tween(1, {[point] = {r = 0}})
    end
  )
end

function love.update(dt)
  if love.mouse.isDown(1) then
    if previousCoords then
      local x, y = love.mouse:getPosition()
      if x ~= previousCoords.x and y ~= previousCoords.y then
        addPoint(x, y)

        previousCoords.x = x
        previousCoords.y = y
      end
    else
      local x, y = love.mouse:getPosition()
      addPoint(x, y)

      previousCoords = {
        ["x"] = x,
        ["y"] = y
      }
    end
  end

  for k, point in pairs(points) do
    if point.r == 0 then
      table.remove(points, k)
    end
  end

  Timer:update(dt)
end

function love.draw()
  love.graphics.setColor(0.3, 0.3, 0.3)
  for k, point in pairs(points) do
    point:render()
  end

  --[[ debugging
    love.graphics.setColor(0, 1, 0)
    love.graphics.print(#Timer.tweens, 8, 8)
  --]]
end
