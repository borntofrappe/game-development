WINDOW_WIDTH = 400
WINDOW_HEIGHT = 400

PARTICLES = 40
INTENSITY_MAX = 5

PARTICLE_IMAGE = "particle-dust.png"
PARTICLE_BUFFER = PARTICLES * INTENSITY_MAX
PARTICLE_LIFETIME_MIN = 0.3
PARTICLE_LIFETIME_MAX = 0.6
PARTICLES_LINEAR_ACCELERATION = {
  ["x"] = {-160, -300},
  ["y"] = {-100, 100}
}
PARTICLES_LINEAR_DAMPING = {0, 4}

PLAYER_SIZE = 15

function love.load()
  love.window.setTitle("Particle System — Dust")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.17, 0.17, 0.17)

  player = {
    ["x"] = WINDOW_WIDTH / 2,
    ["y"] = WINDOW_WIDTH / 2,
    ["size"] = PLAYER_SIZE
  }

  particleImage = love.graphics.newImage(PARTICLE_IMAGE)
  particleSystem = love.graphics.newParticleSystem(particleImage, PARTICLE_BUFFER)
  particleSystem:setPosition(player.x, player.y)
  particleSystem:setParticleLifetime(PARTICLE_LIFETIME_MIN, PARTICLE_LIFETIME_MAX)
  particleSystem:setLinearDamping(PARTICLES_LINEAR_DAMPING[1], PARTICLES_LINEAR_DAMPING[2])
  particleSystem:setSizes(0, 1, 1, 1, 0)
  particleSystem:setColors(1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0)

  intensity = 1
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "return" then
    if player.x > WINDOW_WIDTH then
      player.x = WINDOW_WIDTH / 2 - player.size / 2
    end
    player.x = player.x + player.size
    particleSystem:setPosition(player.x, player.y)
    particleSystem:setLinearAcceleration(
      PARTICLES_LINEAR_ACCELERATION.x[1] * intensity ^ 0.25,
      PARTICLES_LINEAR_ACCELERATION.y[1] * intensity ^ 0.2,
      PARTICLES_LINEAR_ACCELERATION.x[2] * intensity ^ 0.25,
      PARTICLES_LINEAR_ACCELERATION.y[2] * intensity ^ 0.2
    )

    particleSystem:emit(PARTICLES * intensity)
    intensity = intensity == INTENSITY_MAX and 1 or intensity + 1
  end
end

function love.update(dt)
  particleSystem:update(dt)
end

function love.draw()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print("Intensity: " .. intensity, 8, 8)
  love.graphics.draw(particleSystem)
  love.graphics.rectangle("fill", player.x - player.size / 2, player.y - player.size / 2, player.size, player.size)
end
