Fruit = {}
Fruit.__index = Fruit

function Fruit:create()
  this = {
    column = math.random(COLUMNS),
    row = math.random(ROWS),
    width = CELL_SIZE,
    height = CELL_SIZE
  }

  this.x = r
  this.y = r

  setmetatable(this, self)
  return this
end

function Fruit:render()
  love.graphics.setColor(gColors["fruit"].r, gColors["fruit"].g, gColors["fruit"].b)
  love.graphics.rectangle("fill", (self.column - 1) * CELL_SIZE, (self.row - 1) * CELL_SIZE, self.width, self.height)
end
