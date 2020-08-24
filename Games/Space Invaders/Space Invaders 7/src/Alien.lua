Alien = Class {}

function Alien:init(x, y, type, variant)
  self.x = x
  self.y = y
  self.width = ALIEN_WIDTH
  self.height = ALIEN_HEIGHT

  self.type = type or 1
  self.variant = variant or 1

  self.inPlay = true

  self.direction = 1
  self.dx = ALIEN_JUMP
end

function Alien:render()
  if self.inPlay then
    love.graphics.draw(gTextures["space-invaders"], gFrames["aliens"][self.type][self.variant], self.x, self.y)
  end
end
