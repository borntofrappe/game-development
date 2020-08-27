Bullet = Class {}

function Bullet:init(x, y, dy)
  self.width = 3
  self.height = 15
  self.x = x - self.width / 2
  self.y = y

  self.dy = BULLET_SPEED * dy
end

function Bullet:update(dt)
  self.y = self.y + self.dy * dt
end

function Bullet:render()
  love.graphics.draw(gTextures["space-invaders"], gFrames["bullet"], self.x, self.y)
end
