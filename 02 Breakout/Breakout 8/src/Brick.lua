Brick = Class{}

function Brick:init(x, y, tier, color)
  self.x = x
  self.y = y
  self.width = 32
  self.height = 16

  self.tier = tier
  self.color = color

  self.inPlay = true
end

function Brick:hit()
  if self.color > 1 then
    self.color = self.color - 1
    gSounds['brick-hit-2']:stop()
    gSounds['brick-hit-2']:play()
  elseif self.tier > 1 then
    self.tier = self.tier - 1
    gSounds['brick-hit-2']:stop()
    gSounds['brick-hit-2']:play()
  else
    self.inPlay = false
    gSounds['brick-hit-1']:stop()
    gSounds['brick-hit-1']:play()
  end
end

function Brick:render()
  if self.inPlay then
    love.graphics.draw(gTextures['breakout'], gFrames['bricks'][self.tier + 4 * (self.color - 1)], self.x, self.y)
  end
end