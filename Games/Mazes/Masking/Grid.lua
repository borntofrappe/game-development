Grid = {}
Grid.__index = Grid

function Grid:new()
  local mask =
    [[xoooooooox
    ooooxxoooo
    oooxxxxooo
    ooooxxoooo
    xoooooooox
    xoooooooox
    ooooxxoooo
    oooxxxxooo
    ooooxxoooo
    xoooooooox
  ]]
  mask = mask:gsub("[^xo]", "")

  local columns = math.floor((#mask) ^ 0.5)
  local rows = math.floor((#mask) ^ 0.5)
  local width = WINDOW_WIDTH - PADDING * 2
  local height = WINDOW_HEIGHT - PADDING * 2

  local cellWidth = width / columns
  local cellHeight = height / rows

  local cells = {}

  for column = 1, columns do
    cells[column] = {}
    for row = 1, rows do
      local index = column + (row - 1) * columns
      if mask:sub(index, index) == "o" then
        cells[column][row] = Cell:new(column, row, cellWidth, cellHeight)
      else
        cells[column][row] = nil
      end
    end
  end

  this = {
    ["columns"] = columns,
    ["rows"] = rows,
    ["width"] = width,
    ["height"] = height,
    ["cellWidth"] = cellWidth,
    ["cellHeight"] = cellHeight,
    ["cells"] = cells
  }

  setmetatable(this, self)
  return this
end

function Grid:render()
  love.graphics.setColor(0.99, 0.99, 0.99)
  love.graphics.setLineWidth(5)

  for column = 1, self.columns do
    for row = 1, self.rows do
      if self.cells[column][row] then
        self.cells[column][row]:render()
      end
    end
  end
end
