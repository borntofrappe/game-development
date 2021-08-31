local WINDOW_WIDTH = 520
local WINDOW_HEIGHT = 380
local WINDOW_PADDING = 20

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
    gParticleSystem:setPosition(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 4)
    gParticleSystem:emit(PARTICLES)
  end
end

function love.update(dt)
  gParticleSystem:update(dt)
end

function love.draw()
  love.graphics.setColor(0.392, 0.322, 0.255)
  love.graphics.rectangle(
    "line",
    WINDOW_PADDING,
    WINDOW_PADDING,
    WINDOW_WIDTH - WINDOW_PADDING * 2,
    WINDOW_HEIGHT - WINDOW_PADDING * 2
  )

  love.graphics.circle("fill", WINDOW_PADDING, WINDOW_PADDING, 10)
  love.graphics.circle("fill", WINDOW_WIDTH - WINDOW_PADDING, WINDOW_HEIGHT - WINDOW_PADDING, 10)
  love.graphics.circle("fill", WINDOW_PADDING, WINDOW_HEIGHT - WINDOW_PADDING, 10)
  love.graphics.circle("fill", WINDOW_WIDTH - WINDOW_PADDING, WINDOW_PADDING, 10)
  love.graphics.printf("Particle System\nOn click\nOn key press", 0, WINDOW_HEIGHT / 2 - 24, WINDOW_WIDTH, "center")

  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(gParticleSystem)
end
