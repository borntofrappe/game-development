WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500

function love.load()
  love.window.setTitle("ParticleSystem")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.05, 0.05, 0.05)

  particleImage = love.graphics.newImage("particle.png")
  particleSystem = love.graphics.newParticleSystem(particleImage, 200)

  particleSystem:setParticleLifetime(0.2, 0.5)
  particleSystem:setEmissionRate(100)
  particleSystem:setEmissionArea("uniform", WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
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
  love.graphics.draw(particleSystem, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
end
