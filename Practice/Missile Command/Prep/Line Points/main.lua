Timer = require "Timer"

local WINDOW_WIDTH = 420
local WINDOW_HEIGHT = 380
local UPDATE_SPEED = 70
local RESOLUTION = 5

local source = {
  ["x"] = WINDOW_WIDTH / 2,
  ["y"] = WINDOW_HEIGHT
}

local target = {
  ["x"] = WINDOW_WIDTH / 2,
  ["y"] = WINDOW_HEIGHT / 2,
  ["size"] = 12
}

local points = {}

function love.load()
  love.window.setTitle("Line Points")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "return" then
    local dx = (target.x - source.x) / RESOLUTION
    local dy = (target.y - source.y) / RESOLUTION

    local nPts = math.max(math.abs(dx), math.abs(dy))

    local pts = {}

    local x = source.x
    local y = source.y

    for i = 1, nPts + 1 do
      table.insert(pts, x + math.floor(i * dx) / nPts * RESOLUTION)
      table.insert(pts, y + math.floor(i * dy) / nPts * RESOLUTION)
    end

    Timer:reset()
    local index = 0
    Timer:every(
      1 / nPts,
      function()
        index = index + 2
        if index >= #pts then
          Timer:reset()
        else
          points = {}
          for i = 1, index do
            table.insert(points, pts[i])
          end
        end
      end
    )
  end
end

function love.update(dt)
  Timer:update(dt)
  if love.keyboard.isDown("up") then
    target.y = target.y - UPDATE_SPEED * dt
  elseif love.keyboard.isDown("down") then
    target.y = target.y + UPDATE_SPEED * dt
  end

  if love.keyboard.isDown("right") then
    target.x = target.x + UPDATE_SPEED * dt
  elseif love.keyboard.isDown("left") then
    target.x = target.x - UPDATE_SPEED * dt
  end
end

function love.draw()
  love.graphics.setColor(0, 0, 0)
  love.graphics.circle("fill", source.x, source.y, 10)

  love.graphics.setLineWidth(2)
  love.graphics.line(target.x - target.size, target.y, target.x + target.size, target.y)
  love.graphics.line(target.x, target.y - target.size, target.x, target.y + target.size)

  if #points > 2 then
    -- love.graphics.print(#points, 8, 8)
    love.graphics.setLineWidth(0.5)
    love.graphics.line(points)
  end
end
