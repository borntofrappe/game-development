local WINDOW_WIDTH = 420
local WINDOW_HEIGHT = 380
local UPDATE_SPEED = 70

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
  love.window.setTitle("Line Vertices")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "return" then
    points = {source.x, source.y, target.x, target.y}
  end
end

function love.update(dt)
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
    love.graphics.setLineWidth(0.5)
    love.graphics.line(points)
  end
end
