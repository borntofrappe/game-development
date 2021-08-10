Timer = require("Timer")

local WINDOW_WIDTH = 540
local WINDOW_HEIGHT = 400
local UPDATE_SPEED = 100
local GRAVITY = 9.81
local INTERVAL = 0.05
local POINTS = 100
local Y_TERRAIN = WINDOW_HEIGHT * 3 / 4

local terrain = {}
for point = 1, POINTS + 1 do
  local x = (point - 1) * WINDOW_WIDTH / POINTS
  table.insert(terrain, x)
  table.insert(terrain, Y_TERRAIN)
end

local player = {
  ["x"] = 50,
  ["y"] = WINDOW_HEIGHT * 3 / 4,
  ["r"] = 15,
  ["velocity"] = 50,
  ["angle"] = 30
}

local projectile = {
  ["x"] = player.x,
  ["y"] = player.y,
  ["r"] = player.r
}

function love.load()
  love.window.setTitle("Physics - Collision")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  player.range = getRange(player.velocity, player.angle)
  player.trajectory = getTrajectory(player.x, player.y, player.velocity, player.angle)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "return" then
    Timer:reset()

    local index = 1

    local indexStart
    for i = 1, #terrain, 2 do
      if terrain[i] >= player.trajectory[1] then
        indexStart = i
        break
      end
    end

    Timer:every(
      INTERVAL,
      function()
        index = index + 2
        projectile.x = player.trajectory[index]
        projectile.y = player.trajectory[index + 1]

        if player.trajectory[index + 1] > terrain[indexStart + index + 2] then
          Timer:reset()
        end

        if index + 2 >= #player.trajectory then
          Timer:reset()
        end
      end
    )
  end
end

function love.update(dt)
  Timer:update(dt)

  if love.keyboard.isDown("up") then
    player.angle = math.min(90, math.floor(player.angle + UPDATE_SPEED * dt))

    player.range = getRange(player.velocity, player.angle)
    player.trajectory = getTrajectory(player.x, player.y, player.velocity, player.angle)

    Timer:reset()
    projectile.x = player.x
    projectile.y = player.y
  elseif love.keyboard.isDown("down") then
    player.angle = math.max(0, math.floor(player.angle - UPDATE_SPEED * dt))

    player.range = getRange(player.velocity, player.angle)
    player.trajectory = getTrajectory(player.x, player.y, player.velocity, player.angle)

    Timer:reset()
    projectile.x = player.x
    projectile.y = player.y
  end

  if love.keyboard.isDown("right") then
    player.velocity = math.min(100, math.floor(player.velocity + UPDATE_SPEED * dt))

    player.range = getRange(player.velocity, player.angle)
    player.trajectory = getTrajectory(player.x, player.y, player.velocity, player.angle)

    Timer:reset()
    projectile.x = player.x
    projectile.y = player.y
  elseif love.keyboard.isDown("left") then
    player.velocity = math.max(0, math.floor(player.velocity - UPDATE_SPEED * dt))

    player.range = getRange(player.velocity, player.angle)
    player.trajectory = getTrajectory(player.x, player.y, player.velocity, player.angle)

    Timer:reset()
    projectile.x = player.x
    projectile.y = player.y
  end
end

function love.draw()
  love.graphics.setColor(0.15, 0.16, 0.22)

  love.graphics.print("Velocity: " .. player.velocity, 8, 8)
  love.graphics.print("Angle: " .. player.angle, 8, 24)
  love.graphics.print("Range: " .. player.range, 8, 40)
  love.graphics.setLineWidth(2)
  love.graphics.line(0, player.y, WINDOW_WIDTH, player.y)

  love.graphics.setLineWidth(1)
  love.graphics.line(player.trajectory)

  love.graphics.circle("fill", projectile.x, projectile.y, projectile.r)

  love.graphics.circle("fill", player.x, player.y, player.r)
  love.graphics.circle("line", player.x + player.range, player.y, player.r)
end

function getRange(v, a)
  local theta = math.rad(a)
  return math.floor((v ^ 2 * math.sin(2 * theta)) / GRAVITY)
end

function getTrajectory(x, y, v, a)
  local points = {}
  local theta = math.rad(a)

  local t = 0
  local dt = (terrain[3] - terrain[1]) / (v * math.cos(theta))

  while true do
    dx = v * t * math.cos(theta)
    dy = v * t * math.sin(theta) - 1 / 2 * GRAVITY * t ^ 2

    table.insert(points, x + dx)
    table.insert(points, y - dy)

    t = t + dt

    if y - dy > WINDOW_HEIGHT then
      break
    end
  end

  return points
end
