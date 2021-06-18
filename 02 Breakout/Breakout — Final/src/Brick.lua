Brick = Class {}

local PARTICLES = 80
local PARTICLES_LIFETIME_MIN = 0.2
local PARTICLES_LIFETIME_MAX = 0.7
local PARTICLES_ACCELERATION_X_MIN = -10
local PARTICLES_ACCELERATION_X_MAX = 10
local PARTICLES_ACCELERATION_Y_MIN = 10
local PARTICLES_ACCELERATION_Y_MAX = 80
local PARTICLES_EMISSION_X = 10
local PARTICLES_EMISSION_Y = 10

local colorBricks = {
  [1] = {
    ["r"] = 99 / 255,
    ["g"] = 155 / 255,
    ["b"] = 255 / 255
  },
  [2] = {
    ["r"] = 106 / 255,
    ["g"] = 190 / 255,
    ["b"] = 47 / 255
  },
  [3] = {
    ["r"] = 217 / 255,
    ["g"] = 87 / 255,
    ["b"] = 99 / 255
  },
  [4] = {
    ["r"] = 215 / 255,
    ["g"] = 123 / 255,
    ["b"] = 186 / 255
  },
  [5] = {
    ["r"] = 251 / 255,
    ["g"] = 242 / 255,
    ["b"] = 54 / 255
  }
}

function Brick:init(x, y, tier, color)
  self.x = x
  self.y = y
  self.width = BRICK_WIDTH
  self.height = BRICK_HEIGHT

  self.tier = tier
  self.color = color

  self.inPlay = true

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

function Brick:hit()
  self.particleSystem:setColors(
    colorBricks[self.color]["r"],
    colorBricks[self.color]["g"],
    colorBricks[self.color]["b"],
    0.5,
    colorBricks[self.color]["r"],
    colorBricks[self.color]["g"],
    colorBricks[self.color]["b"],
    0
  )
  self.particleSystem:emit(PARTICLES)

  if self.color > 1 then
    self.color = self.color - 1
    gSounds["brick-hit-1"]:stop()
    gSounds["brick-hit-1"]:play()
  elseif self.tier > 1 then
    self.tier = self.tier - 1
    gSounds["brick-hit-1"]:stop()
    gSounds["brick-hit-1"]:play()
  else
    self.inPlay = false
    gSounds["score"]:stop()
    gSounds["score"]:play()
  end
end

function Brick:update(dt)
  self.particleSystem:update(dt)
end

function Brick:render()
  if self.inPlay then
    love.graphics.draw(
      gTextures["breakout"],
      gFrames["bricks"][self.tier + BRICK_TIERS * (self.color - 1)],
      self.x,
      self.y
    )
  end
end

function Brick:renderParticles()
  love.graphics.draw(self.particleSystem, self.x + self.width / 2, self.y + self.height / 2)
end
