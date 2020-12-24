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
  self.inPlay = false
  gSounds['brick-hit-2']:play()
end

function Brick:render()
  if self.inPlay then
    love.graphics.draw(gTextures['breakout'], gFrames['bricks'][self.tier + 4 * (self.color - 1)], self.x, self.y)
  end
end