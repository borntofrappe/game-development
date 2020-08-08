Powerup = Class {}

function Powerup:init(x, y)
  self.x = x - 8
  self.y = y - 8
  self.powerup = 9
  self.width = 16
  self.height = 16
  self.dy = math.random(40, 80)

  self.remove = false
end

function Powerup:update(dt)
  self.y = self.y + self.dy * dt

  if self.y > VIRTUAL_HEIGHT then
    self.remove = true
  end
end

function Powerup:render()
  love.graphics.draw(gTextures["breakout"], gFrames["powerups"][self.powerup], self.x, self.y)
end
