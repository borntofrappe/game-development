LockedBrick = Class({__includes = Brick})

colorBrick = {
  ["r"] = 0,
  ["g"] = 0,
  ["b"] = 0
}

function LockedBrick:init(x, y)
  self.x = x
  self.y = y
  self.width = 32
  self.height = 16
  self.inPlay = true
  self.isLocked = true

  self.showPowerup = true
  self.powerup = Powerup(self.x + self.width / 2, self.y + self.height / 2, 10)

  self.particleSystem = love.graphics.newParticleSystem(gTextures["particle"], 80)
  self.particleSystem:setParticleLifetime(0.2, 0.7)
  self.particleSystem:setLinearAcceleration(-10, 10, 10, 80)
  self.particleSystem:setEmissionArea("normal", 10, 10)
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
    self.particleSystem:emit(80)

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
      love.graphics.draw(gTextures["breakout"], gFrames["bricks"][22], self.x, self.y)
    else
      love.graphics.draw(gTextures["breakout"], gFrames["bricks"][21], self.x, self.y)
    end
  end
end
