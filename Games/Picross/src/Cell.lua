Cell = Class {}

function Cell:init(column, row, size, value)
  self.column = column
  self.row = row
  self.size = size
  self.value = value
end

function Cell:render()
  love.graphics.setColor(1, 1, 1)
  if self.value == "o" then
    love.graphics.rectangle("fill", (self.column - 1) * self.size, (self.row - 1) * self.size, self.size, self.size)
  end
end
