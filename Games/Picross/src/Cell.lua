Cell = Class {}

function Cell:init(column, row, value)
  self.column = column
  self.row = row
  self.value = value

  self.width = CELL_SIZE
  self.height = CELL_SIZE
end

function Cell:render()
  love.graphics.setColor(1, 1, 1)
  if self.value == "o" then
    love.graphics.rectangle(
      "fill",
      (self.column - 1) * self.width,
      (self.row - 1) * self.height,
      self.width,
      self.height
    )
  end
end
