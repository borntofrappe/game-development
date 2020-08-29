AlienBonus = Class {}

function AlienBonus:init()
  self.width = 39
  self.height = 18
  self.y = 76 - 8 - self.height

  self.direction = math.random(2) == 1 and 1 or -1
  self.x = self.direction == 1 and -self.width or WINDOW_WIDTH
  self.dx = ALIEN_BONUS_SPEED

  self.inPlay = true
end

function AlienBonus:update(dt)
  if self.inPlay then
    self.x = self.x + self.dx * self.direction * dt

    if self.direction == 1 and self.x > WINDOW_WIDTH then
      self.inPlay = false
    end
    if self.direction == -1 and self.x < self.width then
      self.inPlay = false
    end
  end
end

function AlienBonus:render()
  if self.inPlay then
    love.graphics.draw(gTextures["spritesheet"], gFrames["aliens"][4], self.x, self.y)
  end
end
