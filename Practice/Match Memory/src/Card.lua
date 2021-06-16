Card = Class {}

function Card:init(angle, symbol)
  local x = math.cos(angle) * 50
  local y = math.sin(angle) * 50
  self.x = x - TILE_WIDTH / 2
  self.y = y - TILE_HEIGHT / 2
  self.width = TILE_WIDTH
  self.height = TILE_HEIGHT
  self.symbol = symbol

  self.isRevealed = true
end

function Card:render()
  love.graphics.setColor(0.1, 0.1, 0.1)
  love.graphics.draw(gTexture, gFrames[self.symbol], self.x, self.y)

  if not self.isRevealed then
    love.graphics.setColor(0.98, 0.98, 0.98)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
  end

  love.graphics.setColor(0.1, 0.1, 0.1)
  love.graphics.setLineWidth(2)
  love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end
