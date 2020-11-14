WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500

function love.load()
  love.window.setTitle("ParticleSystem — Emit")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.05, 0.05, 0.05)

  particleImage = love.graphics.newImage("particle.png")
  particleSystem = love.graphics.newParticleSystem(particleImage, 200)

  particleSystem:setPosition(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
  particleSystem:setParticleLifetime(0.25, 0.75)
  particleSystem:setEmissionArea("uniform", 18, 18)
  particleSystem:setRadialAcceleration(0, 400)
  particleSystem:setLinearDamping(10, 20)
  particleSystem:setSizes(0, 1, 1, 0)
end

function love.mousepressed(x, y, button)
  if button == 1 then
    particleSystem:setPosition(x, y)
    particleSystem:emit(50)
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
  particleSystem:update(dt)
end

function love.draw()
  love.graphics.draw(particleSystem)
end
