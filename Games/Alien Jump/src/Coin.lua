Coin = Class {}

function Coin:init()
  self.variant = math.random(#gQuads["coins"])
  self.x = VIRTUAL_WIDTH
  self.y = math.random(math.floor(VIRTUAL_HEIGHT / 2 - BUSH_SIZE), VIRTUAL_HEIGHT - BUSH_SIZE)
  self.width = COIN_SIZE
  self.height = COIN_SIZE
  self.points = COIN_POINTS[self.variant]
  self.inPlay = true
end

function Coin:render()
  love.graphics.draw(gTextures["coins"], gQuads["coins"][self.variant], self.x, self.y)
end

function Coin:collides(target)
  return not (self.x + self.width < target.x or self.x > target.x + target.width or self.y + self.height < target.y or
    self.y > target.y + target.height)
end
