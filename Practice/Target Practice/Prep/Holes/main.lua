Timer = require("Timer")
require "Terrain"
require "Player"
require "Trajectory"

WINDOW_WIDTH = 540
WINDOW_HEIGHT = 400
GRAVITY = 9.81

local UPDATE_SPEED = 100
local INTERVAL = 0.02

function love.load()
  love.window.setTitle("Holes")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0, 0.08, 0.15)

  gPlayer = Player:new()
  gTerrain = Terrain:new(gPlayer)
  gTrajectory = Trajectory:new(gTerrain, gPlayer)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "return" then
    Timer:reset()

    local index = 1

    local indexStart
    for i = 1, #gTerrain.points, 2 do
      if gTerrain.points[i] >= gTrajectory.points[1] then
        indexStart = i
        break
      end
    end

    Timer:every(
      INTERVAL,
      function()
        index = index + 2
        gPlayer.projectile.x = gTrajectory.points[index]
        gPlayer.projectile.y = gTrajectory.points[index + 1]

        if gTrajectory.points[index + 1] > gTerrain.points[indexStart + index + 2] then
          Timer:reset()
          local r = gPlayer.projectile.r

          local pointsProjectile = math.floor(WINDOW_WIDTH / (r * 2) / 3)

          local p1 = indexStart + index - pointsProjectile
          local p2 = indexStart + index + pointsProjectile

          local angle = 0
          local dangle = math.pi / pointsProjectile

          for p = p1, p2, 2 do
            gTerrain.points[p + 1] = gTerrain.points[p + 1] + r * math.sin(angle)
            angle = angle + dangle
          end
        end

        if index + 2 >= #gTrajectory.points or indexStart + index + 2 >= #gTerrain.points then
          Timer:reset()
        end
      end
    )
  end

  if key == "tab" then
    gPlayer = Player:new()
    gTerrain = Terrain:new(gPlayer)
    gTrajectory = Trajectory:new(gTerrain, gPlayer)
  end
end

function love.update(dt)
  Timer:update(dt)

  if love.keyboard.isDown("up") then
    gPlayer.angle = math.min(90, math.floor(gPlayer.angle + UPDATE_SPEED * dt))

    Timer:reset()
    gPlayer.projectile.x = gPlayer.x
    gPlayer.projectile.y = gPlayer.y
    gTrajectory = Trajectory:new(gTerrain, gPlayer)
  elseif love.keyboard.isDown("down") then
    gPlayer.angle = math.max(0, math.floor(gPlayer.angle - UPDATE_SPEED * dt))

    Timer:reset()
    gPlayer.projectile.x = gPlayer.x
    gPlayer.projectile.y = gPlayer.y
    gTrajectory = Trajectory:new(gTerrain, gPlayer)
  end

  if love.keyboard.isDown("right") then
    gPlayer.velocity = math.min(100, math.floor(gPlayer.velocity + UPDATE_SPEED * dt))

    Timer:reset()
    gPlayer.projectile.x = gPlayer.x
    gPlayer.projectile.y = gPlayer.y
    gTrajectory = Trajectory:new(gTerrain, gPlayer)
  elseif love.keyboard.isDown("left") then
    gPlayer.velocity = math.max(0, math.floor(gPlayer.velocity - UPDATE_SPEED * dt))

    Timer:reset()
    gPlayer.projectile.x = gPlayer.x
    gPlayer.projectile.y = gPlayer.y
    gTrajectory = Trajectory:new(gTerrain, gPlayer)
  end
end

function love.draw()
  love.graphics.setColor(0.83, 0.87, 0.92)
  love.graphics.print("Velocity: " .. gPlayer.velocity, 8, 8)
  love.graphics.print("Angle: " .. gPlayer.angle, 8, 24)

  gTerrain:render()
  gTrajectory:render()
  gPlayer:render()
end
