WINDOW_WIDTH = 620
WINDOW_HEIGHT = 440
POINTS = 300
RADIUS = 12
SPEED = 100
GRAVITY = 9.81

function love.load()
  love.window.setTitle("Range")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  yStart = WINDOW_HEIGHT * 3 / 4

  point = {
    ["r"] = RADIUS,
    ["x"] = RADIUS * 2,
    ["y"] = yStart,
    ["velocity"] = 50,
    ["angle"] = 30
  }
  selection = "velocity"

  point.range = getRange(point.velocity, point.angle)

  points = {}
  for i = 1, POINTS + 1 do
    local x = (i - 1) * WINDOW_WIDTH / POINTS
    local y = yStart
    table.insert(points, x)
    table.insert(points, y)
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "v" then
    selection = "velocity"
  end
  if key == "tab" or key == "t" then
    selection = selection == "velocity" and "angle" or "velocity"
  end

  if key == "a" then
    selection = "angle"
  end

  if key == "return" then
    local xStart = point.x + point.range - point.r
    local xEnd = point.x + point.range + point.r
    local angle = math.pi
    local dAngle = math.pi / (point.r * 2) * WINDOW_WIDTH / POINTS
    for i = 1, #points, 2 do
      if points[i] >= xStart and points[i] <= xEnd then
        points[i + 1] = points[i + 1] + math.sin(angle) * point.r
        angle = math.max(0, angle - dAngle)
      end
    end
  end
end

function love.update(dt)
  if love.keyboard.isDown("up") then
    if selection == "velocity" then
      point.velocity = math.min(100, math.floor(point.velocity + SPEED * dt))
    else
      point.angle = math.min(90, math.floor(point.angle + SPEED * dt))
    end
    point.range = getRange(point.velocity, point.angle)
  elseif love.keyboard.isDown("down") then
    if selection == "velocity" then
      point.velocity = math.max(0, math.floor(point.velocity - SPEED * dt))
    else
      point.angle = math.max(0, math.floor(point.angle - SPEED * dt))
    end
    point.range = getRange(point.velocity, point.angle)
  end
end

function love.draw()
  love.graphics.setColor(0.2, 0.2, 0.22)
  if selection == "velocity" then
    love.graphics.circle("fill", 8, 16, 4)
  else
    love.graphics.circle("fill", 8, 32, 4)
  end
  love.graphics.print("Velocity: " .. point.velocity, 14, 8)
  love.graphics.print("Angle: " .. point.angle, 14, 24)
  love.graphics.print("Range: " .. point.range, 14, 40)

  love.graphics.setLineWidth(2)
  love.graphics.setColor(0.2, 0.2, 0.22)
  love.graphics.line(points)

  love.graphics.circle("fill", point.x, point.y, point.r)

  love.graphics.circle("line", point.x + point.range, point.y, point.r)
end

function getRange(v, a)
  local theta = math.rad(a)
  return math.floor((v ^ 2 * math.sin(2 * theta)) / GRAVITY)
end
