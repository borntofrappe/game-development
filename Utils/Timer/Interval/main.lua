Timer = require "Timer"

local WINDOW_WIDTH = 460
local WINDOW_HEIGHT = 380

local RADIUS_MIN = 5
local RADIUS_MAX = 10
local GRAVITY = 5

local INTERVAL = 0.1
local particles = {}
local LABEL = "interval"
local label

function addInterval()
  label = LABEL
  Timer:every(
    INTERVAL,
    function()
      table.insert(
        particles,
        {
          ["x"] = love.math.random(WINDOW_WIDTH),
          ["y"] = -RADIUS_MAX,
          ["r"] = love.math.random(RADIUS_MIN, RADIUS_MAX),
          ["dy"] = 0
        }
      )
    end,
    label
  )
end

function toggleInterval()
  if label then
    Timer:remove(label)
    label = nil
  else
    addInterval()
  end
end

function love.load()
  love.window.setTitle("Timer Interval")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.94, 0.94, 0.94)

  addInterval()
end

function love.mousepressed(x, y, button)
  if button == 1 then
    toggleInterval()
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "t" then
    toggleInterval()
  end
end

function love.update(dt)
  for k, particle in pairs(particles) do
    particle.y = particle.y + particle.dy
    particle.dy = particle.dy + GRAVITY * dt

    if particle.y > WINDOW_HEIGHT + RADIUS_MAX then
      table.remove(particles, k)
    end
  end

  Timer:update(dt)
end

function love.draw()
  love.graphics.setColor(0.3, 0.3, 0.3)
  for k, particle in pairs(particles) do
    love.graphics.circle("fill", particle.x, particle.y, particle.r)
  end

  --[[ debugging
    love.graphics.setColor(0, 1, 0)
    love.graphics.print(#Timer.intervals, 8, 8)
  --]]
end
