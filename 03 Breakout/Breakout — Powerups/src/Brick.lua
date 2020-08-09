Brick = Class {}

colorBricks = {
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

function Brick:init(x, y, tier, color, showPowerup)
  self.x = x
  self.y = y
  self.width = 32
  self.height = 16

  self.tier = tier
  self.color = color

  self.inPlay = true

  self.showPowerup = showPowerup
  self.powerup = Powerup(self.x + self.width / 2, self.y + self.height / 2)

  self.particleSystem = love.graphics.newParticleSystem(gTextures["particle"], 80)
  self.particleSystem:setParticleLifetime(0.2, 0.7)
  self.particleSystem:setLinearAcceleration(-10, 10, 10, 80)
  self.particleSystem:setEmissionArea("normal", 10, 10)
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
  self.particleSystem:emit(80)

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

    if self.showPowerup and not self.powerup.inPlay then
      self.powerup.inPlay = true
    end
  end
end

function Brick:update(dt)
  self.particleSystem:update(dt)

  if self.showPowerup and self.powerup.inPlay then
    self.powerup:update(dt)
  end
end

function Brick:render()
  if self.showPowerup and self.powerup.inPlay then
    self.powerup:render()
  end

  if self.inPlay then
    love.graphics.draw(gTextures["breakout"], gFrames["bricks"][self.tier + 4 * (self.color - 1)], self.x, self.y)
  end
end

function Brick:renderParticles()
  love.graphics.draw(self.particleSystem, self.x + 16, self.y + 8)
end
