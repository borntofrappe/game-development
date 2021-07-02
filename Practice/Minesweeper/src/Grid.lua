Grid = {}

function Grid:new()
  local cells = {}
  for column = 1, COLUMNS do
    cells[column] = {}
    for row = 1, ROWS do
      cells[column][row] =
        Cell:new(
        {
          ["column"] = column,
          ["row"] = row,
          ["isDark"] = (column + row) % 2 == 0
        }
      )
    end
  end

  local this = {
    ["cells"] = cells
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Grid:reveal(column, row)
  if not self.cells[column][row].isRevealed then
    self.cells[column][row].isRevealed = true
  end
end

function Grid:render()
  for k, column in pairs(self.cells) do
    for l, cell in pairs(column) do
      cell:render()
    end
  end
end
