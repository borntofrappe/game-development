Timer = require "Timer"

local WINDOW_WIDTH = 480
local WINDOW_HEIGHT = 480

local RADIUS_MIN = 5
local RADIUS_MAX = 10

local point = nil -- keep track of the point to avoid overlapping circles
local points = {}
local DELAY = 0.1

function love.load()
  love.window.setTitle("Timer Delay")
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
      local point = {
        ["x"] = x,
        ["y"] = y,
        ["r"] = love.math.random(RADIUS_MIN, RADIUS_MAX)
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
  love.graphics.setColor(0.96, 0.6, 0.34)
  for i, point in ipairs(points) do
    love.graphics.circle("fill", point.x, point.y, point.r)
  end
end
