local WINDOW_WIDTH = 540
local WINDOW_HEIGHT = 400
local UPDATE_SPEED = 100
local GRAVITY = 9.81

local player = {
  ["x"] = 50,
  ["y"] = WINDOW_HEIGHT * 3 / 4,
  ["r"] = 15,
  ["velocity"] = 50,
  ["angle"] = 30,
  ["range"] = 0,
  ["key"] = "velocity",
  ["trajectory"] = {}
}

function love.load()
  love.window.setTitle("Physics - Trajectory")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.94, 0.97, 1)

  player.range = getRange(player.velocity, player.angle)
  player.trajectory = getTrajectory(player.x, player.y, player.velocity, player.angle)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "v" then
    player.key = "velocity"
  end
  if key == "a" then
    player.key = "angle"
  end

  if key == "tab" then
    player.key = player.key == "velocity" and "angle" or "velocity"
  end
end

function love.update(dt)
  if love.keyboard.isDown("up") or love.keyboard.isDown("right") then
    if player.key == "velocity" then
      player.velocity = math.min(100, math.floor(player.velocity + UPDATE_SPEED * dt))
    else
      player.angle = math.min(90, math.floor(player.angle + UPDATE_SPEED * dt))
    end
    player.range = getRange(player.velocity, player.angle)
    player.trajectory = getTrajectory(player.x, player.y, player.velocity, player.angle)
  elseif love.keyboard.isDown("down") or love.keyboard.isDown("left") then
    if player.key == "velocity" then
      player.velocity = math.max(0, math.floor(player.velocity - UPDATE_SPEED * dt))
    else
      player.angle = math.max(0, math.floor(player.angle - UPDATE_SPEED * dt))
    end
    player.range = getRange(player.velocity, player.angle)
    player.trajectory = getTrajectory(player.x, player.y, player.velocity, player.angle)
  end
end

function love.draw()
  love.graphics.setColor(0, 0.05, 0.1)

  if player.key == "velocity" then
    love.graphics.circle("fill", 8, 16, 4)
  else
    love.graphics.circle("fill", 8, 32, 4)
  end

  love.graphics.print("Velocity: " .. player.velocity, 14, 8)
  love.graphics.print("Angle: " .. player.angle, 14, 24)
  love.graphics.print("Range: " .. player.range, 14, 40)

  love.graphics.setLineWidth(2)
  love.graphics.line(0, player.y, WINDOW_WIDTH, player.y)

  love.graphics.circle("fill", player.x, player.y, player.r)
  love.graphics.circle("line", player.x + player.range, player.y, player.r)

  love.graphics.setLineWidth(1)
  love.graphics.line(player.trajectory)
end

function getRange(v, a)
  local theta = math.rad(a)
  return math.floor((v ^ 2 * math.sin(2 * theta)) / GRAVITY)
end

function getTrajectory(x, y, v, a)
  local points = {}
  local theta = math.rad(a)

  local t = 0

  while true do
    dx = v * t * math.cos(theta)
    dy = v * t * math.sin(theta) - 1 / 2 * GRAVITY * t ^ 2

    table.insert(points, x + dx)
    table.insert(points, y - dy)

    t = t + 0.1

    if y - dy > WINDOW_HEIGHT then
      break
    end
  end

  return points
end
