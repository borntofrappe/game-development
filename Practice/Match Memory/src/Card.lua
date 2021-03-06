Card = Class {}

function Card:init(column, row, x, y, symbol)
  self.column = column
  self.row = row
  self.x = math.floor(x - TILE_WIDTH / 2)
  self.y = math.floor(y - TILE_HEIGHT / 2)
  self.width = TILE_WIDTH
  self.height = TILE_HEIGHT
  self.symbol = symbol

  self.isFocused = false
  self.isRevealed = false
  self.isPaired = false
end

function Card:match()
  self.isPaired = true
end

function Card:focus()
  self.isFocused = true
end

function Card:blur()
  self.isFocused = false
end

function Card:reveal()
  self.isRevealed = true
end

function Card:hide()
  self.isRevealed = false
end

function Card:render()
  love.graphics.setColor(gColors.text.r, gColors.text.g, gColors.text.b)
  love.graphics.setLineWidth(2)
  if self.isFocused then
    love.graphics.setLineWidth(4)
  end
  love.graphics.rectangle("line", self.x, self.y, self.width, self.height)

  if self.isRevealed then
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(gTexture, gFrames[self.symbol], self.x, self.y)
  elseif self.isFocused then
    love.graphics.setColor(gColors.text.r, gColors.text.g, gColors.text.b)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
  end
end
