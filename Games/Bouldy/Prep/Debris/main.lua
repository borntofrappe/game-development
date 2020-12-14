WINDOW_WIDTH = 400
WINDOW_HEIGHT = 400

GATE_WIDTH = 4
GATE_HEIGHT = 20

PARTICLE_IMAGE = "particle-debris.png"
PARTICLES = 8
PARTICLE_BUFFER = PARTICLES
PARTICLE_LIFETIME_MIN = 0.2
PARTICLE_LIFETIME_MAX = 0.5

PARTICLES_EMISSION_AREA = {
  0,
  GATE_HEIGHT / 2.5
}

PARTICLES_LINEAR_ACCELERATION = {
  ["x"] = {80, 180},
  ["y"] = {-150, 150}
}

PARTICLES_RADIAL_ACCELERATION = {
  60,
  120
}

function love.load()
  love.window.setTitle("Particle System — Debris")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.17, 0.17, 0.17)

  gate = {
    ["x"] = WINDOW_WIDTH / 2,
    ["y"] = WINDOW_WIDTH / 2,
    ["width"] = GATE_WIDTH,
    ["height"] = GATE_HEIGHT,
    ["alpha"] = 1
  }

  particleImage = love.graphics.newImage(PARTICLE_IMAGE)
  particleSystem = love.graphics.newParticleSystem(particleImage, PARTICLE_BUFFER)
  particleSystem:setPosition(gate.x + gate.width / 2, gate.y)
  particleSystem:setParticleLifetime(PARTICLE_LIFETIME_MIN, PARTICLE_LIFETIME_MAX)
  particleSystem:setLinearAcceleration(
    PARTICLES_LINEAR_ACCELERATION.x[1],
    PARTICLES_LINEAR_ACCELERATION.y[1],
    PARTICLES_LINEAR_ACCELERATION.x[2],
    PARTICLES_LINEAR_ACCELERATION.y[2]
  )
  particleSystem:setEmissionArea("uniform", PARTICLES_EMISSION_AREA[1], PARTICLES_EMISSION_AREA[2])
  particleSystem:setRadialAcceleration(PARTICLES_RADIAL_ACCELERATION[1], PARTICLES_RADIAL_ACCELERATION[2])

  particleSystem:setSpin(0, math.pi * 2)
  particleSystem:setRotation(0, math.pi * 2)

  particleSystem:setSizes(0, 1, 1, 1, 0)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "return" then
    if gate.alpha == 0 then
      gate.alpha = 1
    else
      particleSystem:emit(PARTICLES)
      gate.alpha = 0
    end
  end
end

function love.update(dt)
  particleSystem:update(dt)
end

function love.draw()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(particleSystem)
  love.graphics.setColor(1, 1, 1, gate.alpha)
  love.graphics.rectangle("fill", gate.x - gate.width / 2, gate.y - gate.height / 2, gate.width, gate.height)
end
