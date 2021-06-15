LockedBrick = Class({__includes = Brick})

local POWERUP_KEY = 10

local BRICK_LOCKED = 22
local BRICK_UNLOCKED = 21

local PARTICLES = 80
local PARTICLES_LIFETIME_MIN = 0.2
local PARTICLES_LIFETIME_MAX = 0.7
local PARTICLES_ACCELERATION_X_MIN = -10
local PARTICLES_ACCELERATION_X_MAX = 10
local PARTICLES_ACCELERATION_Y_MIN = 10
local PARTICLES_ACCELERATION_Y_MAX = 80
local PARTICLES_EMISSION_X = 10
local PARTICLES_EMISSION_Y = 10

local colorBrick = {
  ["r"] = 0,
  ["g"] = 0,
  ["b"] = 0
}

function LockedBrick:init(x, y)
  self.x = x
  self.y = y
  self.width = BRICK_WIDTH
  self.height = BRICK_HEIGHT
  self.inPlay = true
  self.isLocked = true

  self.showPowerup = true
  self.powerup = Powerup(self.x + self.width / 2, self.y + self.height / 2, POWERUP_KEY)

  self.particleSystem = love.graphics.newParticleSystem(gTextures["particle"], PARTICLES)
  self.particleSystem:setParticleLifetime(PARTICLES_LIFETIME_MIN, PARTICLES_LIFETIME_MAX)
  self.particleSystem:setLinearAcceleration(
    PARTICLES_ACCELERATION_X_MIN,
    PARTICLES_ACCELERATION_Y_MIN,
    PARTICLES_ACCELERATION_X_MAX,
    PARTICLES_ACCELERATION_Y_MAX
  )
  self.particleSystem:setEmissionArea("normal", PARTICLES_EMISSION_X, PARTICLES_EMISSION_Y)
end

function LockedBrick:hit()
  if self.isLocked then
    gSounds["brick-hit-3"]:stop()
    gSounds["brick-hit-3"]:play()

    if not self.powerup.inPlay then
      self.powerup.inPlay = true
    end
  else
    self.particleSystem:setColors(
      colorBrick["r"],
      colorBrick["g"],
      colorBrick["b"],
      0.5,
      colorBrick["r"],
      colorBrick["g"],
      colorBrick["b"],
      0
    )
    self.particleSystem:emit(PARTICLES)

    self.inPlay = false
    gSounds["score"]:stop()
    gSounds["score"]:play()
  end
end

function LockedBrick:render()
  if self.inPlay then
    if self.showPowerup and self.powerup.inPlay then
      self.powerup:render()
    end

    if self.isLocked then
      love.graphics.draw(gTextures["breakout"], gFrames["bricks"][BRICK_LOCKED], self.x, self.y)
    else
      love.graphics.draw(gTextures["breakout"], gFrames["bricks"][BRICK_UNLOCKED], self.x, self.y)
    end
  end
end
