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
  ["size"] = 10
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
    local dx = (target.x - source.x)
    local dy = (target.y - source.y)

    local nPts = math.max(math.abs(dx), math.abs(dy))

    local pts = {}

    local x = source.x
    local y = source.y

    table.insert(pts, source.x)
    table.insert(pts, source.y)

    for i = 1, nPts, RESOLUTION do
      table.insert(pts, x + math.floor(i * dx) / nPts)
      table.insert(pts, y + math.floor(i * dy) / nPts)
    end

    table.insert(pts, target.x)
    table.insert(pts, target.y)

    Timer:reset()
    local index = 0
    Timer:every(
      1 / #pts,
      function()
        index = index + 2
        if index > #pts then
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

  love.graphics.setLineWidth(1)
  love.graphics.line(target.x - target.size, target.y, target.x + target.size, target.y)
  love.graphics.line(target.x, target.y - target.size, target.x, target.y + target.size)
  love.graphics.line(
    target.x - target.size / 2,
    target.y - target.size,
    target.x + target.size / 2,
    target.y - target.size
  )
  love.graphics.line(
    target.x - target.size / 2,
    target.y + target.size,
    target.x + target.size / 2,
    target.y + target.size
  )
  love.graphics.line(
    target.x - target.size,
    target.y - target.size / 2,
    target.x - target.size,
    target.y + target.size / 2
  )
  love.graphics.line(
    target.x + target.size,
    target.y - target.size / 2,
    target.x + target.size,
    target.y + target.size / 2
  )

  if #points > 2 then
    -- love.graphics.print(#points, 8, 8)
    love.graphics.setLineWidth(0.5)
    love.graphics.line(points)
  end
end
