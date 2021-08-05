local WINDOW_WIDTH = 540
local WINDOW_HEIGHT = 400
local POINTS = 100

local CANNONBALL_RADIUS = 20

local cannonball = {
  ["x"] = WINDOW_WIDTH / 2,
  ["y"] = WINDOW_HEIGHT / 4,
  ["r"] = CANNONBALL_RADIUS
}

local points = {}

for point = 1, POINTS + 1 do
  local x = (point - 1) * WINDOW_WIDTH / POINTS
  local y = WINDOW_HEIGHT * 3 / 4

  table.insert(points, x)
  table.insert(points, y)
end

function love.load()
  love.window.setTitle("Terrain")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.95, 0.95, 0.95)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.mousepressed(x, y, button)
  if button == 1 then
    local x1 = cannonball.x - cannonball.r
    local x2 = cannonball.x + cannonball.r
    for i = 1, #points, 2 do
      if points[i] > x1 and points[i] < x2 then
        points[i + 1] = points[i + 1] + 5
      end
    end
  -- modify terrain
  end
end

function love.update(dt)
  local x = love.mouse:getPosition()
  cannonball.x = x
end

function love.draw()
  love.graphics.setColor(0.14, 0.14, 0.14)
  love.graphics.circle("fill", cannonball.x, cannonball.y, cannonball.r)

  love.graphics.setLineWidth(2)
  love.graphics.line(points)
end
