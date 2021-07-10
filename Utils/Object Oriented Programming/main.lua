require "Particle"
require "SquareParticle"
require "CircleParticle"

local WINDOW_WIDTH = 560
local WINDOW_HEIGHT = 400
local MARGIN = 20

local timer = 0
local INTERVAL = 0.2
local particles = {}

function love.load()
  love.window.setTitle("Object Oriented Programming")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0, 0, 0)
end

function love.update(dt)
  timer = timer + dt
  if timer > INTERVAL then
    timer = timer % INTERVAL

    local x = love.math.random(WINDOW_WIDTH)
    local y = -MARGIN
    local particle = love.math.random(2) == 1 and CircleParticle:new(x, y) or SquareParticle:new(x, y)
    table.insert(particles, particle)
  end

  if love.mouse.isDown(1) then
    local x, y = love.mouse:getPosition()
    table.insert(particles, CircleParticle:new(x, y))
  end

  if love.mouse.isDown(2) then
    local x, y = love.mouse:getPosition()
    table.insert(particles, SquareParticle:new(x, y))
  end

  for k, particle in pairs(particles) do
    particle:update(dt)

    if particle.y > WINDOW_HEIGHT + MARGIN then
      table.remove(particles, k)
    end
  end
end

function love.draw()
  love.graphics.setColor(1, 1, 1)
  for k, particle in pairs(particles) do
    particle:render()
  end
end
