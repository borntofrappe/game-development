WINDOW_WIDTH = 540
WINDOW_HEIGHT = 400
Timer = require("Timer")

require "Terrain"
require "Player"
require "Trajectory"

GRAVITY = 9.81

local UPDATE_SPEED = 100
local INTERVAL = 0.02

function love.load()
  love.window.setTitle("Holes")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  gTerrain = Terrain:new()
  gPlayer = Player:new(gTerrain)
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
          local x1 = gPlayer.projectile.x - r
          local x2 = gPlayer.projectile.x - r

          local angle = 0
          local pointsProjectile = math.floor(#gTerrain.points / WINDOW_WIDTH * r * 2)
          local dangle = math.pi / (pointsProjectile / 2)

          for p = 1, #gTerrain.points, 2 do
            if gTerrain.points[p] >= x1 then
              gTerrain.points[p + 1] = gTerrain.points[p + 1] + math.sin(angle) * r
              angle = angle + dangle

              if angle > math.pi then
                break
              end
            end
          end
        end

        if index + 2 >= #gTrajectory.points or indexStart + index + 2 >= #gTerrain.points then
          Timer:reset()
        end
      end
    )
  end

  if key == "tab" then
    Timer:reset()

    gTerrain = Terrain:new()
    gPlayer = Player:new(gTerrain)
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
  love.graphics.setColor(0.15, 0.16, 0.22)
  love.graphics.print("Velocity: " .. gPlayer.velocity, 8, 8)
  love.graphics.print("Angle: " .. gPlayer.angle, 8, 24)

  gTerrain:render()
  gTrajectory:render()
  gPlayer:render()
end
