Snake = {}
Snake.__index = Snake

function Snake:create(x, y)
  this = {
    x = x,
    y = y,
    width = CELL_SIZE,
    height = CELL_SIZE
  }

  setmetatable(this, self)

  return this
end

function Snake:render()
  love.graphics.clear(0.035, 0.137, 0.298, 1)
  love.graphics.rectangle("fill", self.x * TILE_SIZE, self.y * TILE_SIZE, self.width, self.height)
end
