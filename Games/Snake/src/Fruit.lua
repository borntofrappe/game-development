Fruit = {}
Fruit.__index = Fruit

function Fruit:create(x, y)
  local column = math.random(math.floor(WINDOW_WIDTH / CELL_SIZE))
  local row = math.random(math.floor(WINDOW_HEIGHT / CELL_SIZE))

  this = {
    x = (column - 1) * CELL_SIZE,
    y = (row - 1) * CELL_SIZE,
    width = CELL_SIZE,
    height = CELL_SIZE
  }

  setmetatable(this, self)
  return this
end

function Fruit:render()
  love.graphics.setColor(gColors["fruit"].r, gColors["fruit"].g, gColors["fruit"].b)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end
