local WINDOW_WIDTH = 540
local WINDOW_HEIGHT = 400
local POINTS = 100
local Y_BASELINE = WINDOW_HEIGHT * 3 / 4

local cannonball = {
  ["x"] = WINDOW_WIDTH / 2,
  ["y"] = WINDOW_HEIGHT / 4,
  ["r"] = 20
}

local points = {}

for point = 1, POINTS + 1 do
  table.insert(points, (point - 1) * WINDOW_WIDTH / POINTS)
  table.insert(points, Y_BASELINE)
end

function love.load()
  love.window.setTitle("Terrain")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.94, 0.97, 1)
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
    local angle1 = math.pi
    local angle2 = 0

    for point = 1, #points, 2 do
      local x = points[point]
      if x > x1 and x < x2 then
        local angle = angle1 + ((angle2 - angle1) / (x2 - x1)) * (x - x1)
        points[point + 1] = math.min(WINDOW_HEIGHT, points[point + 1] + cannonball.r * math.sin(angle))
      end
      if x > x2 then
        break
      end
    end
  end
end

function love.update(dt)
  local x = love.mouse:getPosition()
  cannonball.x = x
end

function love.draw()
  love.graphics.setColor(0, 0.05, 0.1)

  love.graphics.circle("fill", cannonball.x, cannonball.y, cannonball.r)

  love.graphics.setLineWidth(2)
  love.graphics.line(points)
end
