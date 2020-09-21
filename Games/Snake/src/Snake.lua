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
  love.graphics.rectangle(
    "fill",
    math.floor((self.x - 1) * CELL_SIZE),
    math.floor((self.y - 1) * CELL_SIZE),
    self.width,
    self.height
  )
end
