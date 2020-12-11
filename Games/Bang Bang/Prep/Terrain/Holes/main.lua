WINDOW_WIDTH = 620
WINDOW_HEIGHT = 440
POINTS = 300
RADIUS = 12
UPDATE_SPEED = 200

function love.load()
  love.window.setTitle("Holes")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  player = {
    ["x"] = love.math.random(RADIUS, WINDOW_WIDTH - RADIUS),
    ["y"] = WINDOW_HEIGHT * 3 / 4,
    ["r"] = RADIUS
  }

  terrain = getPoints()
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "return" then
    local xStart = player.x - player.r
    local xEnd = player.x + player.r
    local angle = math.pi
    local dAngle = math.pi / (player.r * 2) * WINDOW_WIDTH / POINTS
    for i = 1, #terrain, 2 do
      if terrain[i] >= xStart and terrain[i] <= xEnd then
        terrain[i + 1] = terrain[i + 1] + math.sin(angle) * player.r
        angle = math.max(0, angle - dAngle)
      end
    end
  end
end

function love.update(dt)
  if love.keyboard.isDown("right") then
    player.x = math.min(WINDOW_WIDTH - RADIUS, player.x + UPDATE_SPEED * dt)
  elseif love.keyboard.isDown("left") then
    player.x = math.max(RADIUS, player.x - UPDATE_SPEED * dt)
  end
end

function love.draw()
  love.graphics.setLineWidth(2)
  love.graphics.setColor(0.2, 0.2, 0.2)
  love.graphics.line(terrain)

  love.graphics.setColor(0.2, 0.2, 0.2, 0.5)
  love.graphics.circle("fill", player.x, player.y, player.r)
end

function getPoints()
  local points = {}

  for i = 1, POINTS + 1 do
    local x = (i - 1) * WINDOW_WIDTH / POINTS
    local y = WINDOW_HEIGHT * 3 / 4
    table.insert(points, x)
    table.insert(points, y)
  end

  return points
end
