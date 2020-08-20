Alien = Class {}

function Alien:init(x, y, type, variant)
  self.x = x
  self.y = y
  self.width = 24
  self.height = 21

  self.type = type or 1
  self.variant = variant or 1
end

function Alien:render()
  love.graphics.draw(gTextures["space-invaders"], gFrames["aliens"][self.type][self.variant], self.x, self.y)
end
