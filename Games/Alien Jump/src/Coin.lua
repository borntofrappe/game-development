Coin = Class {}

function Coin:init()
  self.variant = math.random(#gQuads["coins"])
  self.width = COIN_SIZE
  self.height = COIN_SIZE

  self.x = VIRTUAL_WIDTH
  self.y = math.random(math.floor(VIRTUAL_HEIGHT / 2 - self.height), VIRTUAL_HEIGHT - self.height)
  self.points = COIN_POINTS[self.variant]
  self.inPlay = true
end

function Coin:render()
  love.graphics.draw(gTextures["coins"], gQuads["coins"][self.variant], math.floor(self.x), math.floor(self.y))
end

function Coin:collides(target)
  return not (self.x + self.width < target.x or self.x > target.x + target.width or self.y + self.height < target.y or
    self.y > target.y + target.height)
end
