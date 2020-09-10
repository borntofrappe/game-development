Player = {}
Player.__index = Player

function Player:create()
  this = {
    x = WINDOW_WIDTH / 2,
    y = WINDOW_HEIGHT / 2
  }

  setmetatable(this, self)

  return this
end

function Player:update(dt)
end

function Player:render()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setLineWidth(2)
  love.graphics.polygon("line", self.x, self.y - 10, self.x + 10, self.y + 10, self.x - 10, self.y + 10)
end
