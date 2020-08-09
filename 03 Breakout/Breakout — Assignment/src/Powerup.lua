Powerup = Class {}

function Powerup:init(x, y)
  self.x = x - 8
  self.y = y - 8
  self.powerup = 9
  self.width = 16
  self.height = 16
  self.dy = math.random(40, 80)

  self.inPlay = false
end

function Powerup:update(dt)
  if self.inPlay then
    self.y = self.y + self.dy * dt
  end

  if self.y > VIRTUAL_HEIGHT then
    self.inPlay = false
  end
end

function Powerup:render()
  if self.inPlay then
    love.graphics.draw(gTextures["breakout"], gFrames["powerups"][self.powerup], self.x, self.y)
  end
end
