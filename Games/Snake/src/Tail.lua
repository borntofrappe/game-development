Tail = {}
Tail.__index = Tail

function Tail:create(column, row, direction)
  this = {
    column = column,
    row = row,
    width = CELL_SIZE,
    height = CELL_SIZE,
    direction = direction
  }

  setmetatable(this, self)
  return this
end

function Tail:render()
  love.graphics.setColor(gColors["foreground"].r, gColors["foreground"].g, gColors["foreground"].b)
  love.graphics.rectangle("fill", (self.column - 1) * CELL_SIZE, (self.row - 1) * CELL_SIZE, self.width, self.height)
  love.graphics.setColor(gColors["background"].r, gColors["background"].g, gColors["background"].b, 0.35)
  love.graphics.rectangle("fill", (self.column - 1) * CELL_SIZE, (self.row - 1) * CELL_SIZE, self.width, self.height)
end
