Timer = require "Timer"

WINDOW_WIDTH = 620
WINDOW_HEIGHT = 440
POINTS = 300
RADIUS = 12
SPEED = 100
GRAVITY = 9.81

function love.load()
  love.window.setTitle("Fire")
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
  cannonball = {
    ["r"] = RADIUS,
    ["x"] = point.x,
    ["y"] = point.y
  }

  selection = "velocity"
  isFiring = false

  point.range = getRange(point.velocity, point.angle)

  terrain = {}
  for i = 1, POINTS + 1 do
    local x = (i - 1) * WINDOW_WIDTH / POINTS
    local y = yStart
    table.insert(terrain, x)
    table.insert(terrain, y)
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
    fire(point.x, point.y, point.velocity, point.angle)
  end
end

function love.update(dt)
  Timer:update(dt)

  if love.keyboard.isDown("up") then
    if selection == "velocity" then
      point.velocity = math.min(100, math.floor(point.velocity + SPEED * dt))
    else
      point.angle = math.min(90, math.floor(point.angle + SPEED * dt))
    end
    point.range = getRange(point.velocity, point.angle)
  elseif love.keyboard.isDown("down") then
    if selection == "velocity" then
      point.velocity = math.max(5, math.floor(point.velocity - SPEED * dt))
    else
      point.angle = math.max(5, math.floor(point.angle - SPEED * dt))
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
  love.graphics.line(terrain)

  love.graphics.circle("fill", point.x, point.y, point.r)
  love.graphics.circle("fill", cannonball.x, cannonball.y, cannonball.r)
end

function fire(xOffset, yOffset, v, a)
  if not isFiring then
    isFiring = true

    local points = {}
    local theta = math.rad(a)

    local t = 0
    local tDelta = (terrain[3] - terrain[1]) / (v * math.cos(theta)) * 10

    while true do
      x = v * t * math.cos(theta)
      y = v * t * math.sin(theta) - 1 / 2 * GRAVITY * t ^ 2

      table.insert(points, xOffset + x)
      table.insert(points, yOffset - y)
      t = t + tDelta

      if yOffset - y > WINDOW_HEIGHT then
        break
      end
    end

    local index = 1

    Timer:every(
      0.1,
      function()
        cannonball.x = points[index]
        cannonball.y = points[index + 1]

        for i = 1, #terrain, 2 do
          if terrain[i] > cannonball.x + cannonball.r then
            break
          end

          if terrain[i] > cannonball.x - cannonball.r and terrain[i] < cannonball.x + cannonball.r then
            if cannonball.y > terrain[i + 1] then
              local j = i
              local angle = math.pi
              local dAngle = math.pi / (cannonball.r * 2) * WINDOW_WIDTH / POINTS
              while angle > 0 do
                j = j + 2
                terrain[j + 1] = terrain[j + 1] + math.sin(angle) * cannonball.r
                angle = math.max(0, angle - dAngle)
              end

              isFiring = false
              cannonball.x = point.x
              cannonball.y = point.y
              Timer:reset()
            end
          end
        end

        index = index + 2
        if not points[index] then
          isFiring = false
          cannonball.x = point.x
          cannonball.y = point.y
          Timer:reset()
        end
      end
    )
  end
end

function getRange(v, a)
  local theta = math.rad(a)
  return math.floor((v ^ 2 * math.sin(2 * theta)) / GRAVITY)
end
