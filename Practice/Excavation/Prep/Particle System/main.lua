local WINDOW_WIDTH = 520
local WINDOW_HEIGHT = 380

local PARTICLES = 50
local particles = {}

function love.load()
  love.window.setTitle("Particle System")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.694, 0.659, 0.624)

  local image = love.graphics.newImage("particle.png")
  gParticleSystem = love.graphics.newParticleSystem(image, PARTICLES)
  gParticleSystem:setParticleLifetime(0.3, 0.5)
  gParticleSystem:setEmissionArea("uniform", 8, 8)
  gParticleSystem:setSizes(1, 1, 0)
  gParticleSystem:setColors(1, 1, 1, 1, 1, 1, 1, 0)
  gParticleSystem:setRadialAcceleration(25, 150)

  gParticleSystem:setPosition(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
end

function love.mousepressed(x, y, button)
  if button == 1 then
    gParticleSystem:setPosition(x, y)
    gParticleSystem:emit(PARTICLES)
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "return" then
    gParticleSystem:setPosition(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
    gParticleSystem:emit(PARTICLES)
  end
end

function love.update(dt)
  gParticleSystem:update(dt)
end

function love.draw()
  love.graphics.draw(gParticleSystem)
end
