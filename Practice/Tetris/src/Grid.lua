Grid = {}

function Grid:new()
  local columnStart = PADDING_COLUMNS
  local rowStart = 0

  local columns = GRID_COLUMNS + BORDER_COLUMNS * 2
  local rows = GRID_ROWS

  local x = columnStart * CELL_SIZE
  local y = rowStart * CELL_SIZE
  local width = columns * CELL_SIZE
  local height = rows * CELL_SIZE

  local border = {}
  for column = 1, BORDER_COLUMNS do
    for row = 1, rows do
      table.insert(border, Brick:new(columnStart + (column - 1), rowStart + (row - 1), 7))
      table.insert(border, Brick:new(columnStart + columns - 1 + (column - 1), rowStart + (row - 1), 7))
    end
  end

  local bricks = {}
  for row = 1, GRID_ROWS do
    bricks[row] = {}
    for column = 1, GRID_COLUMNS do
      bricks[row][column] = nil
    end
  end

  local this = {
    ["x"] = x,
    ["y"] = y,
    ["width"] = width,
    ["height"] = height,
    ["border"] = border,
    ["bricks"] = bricks
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Grid:render()
  love.graphics.setColor(gColors[4].r, gColors[4].g, gColors[4].b)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

  love.graphics.setColor(1, 1, 1)

  for k, brick in pairs(self.border) do
    brick:render()
  end

  for k, row in pairs(self.bricks) do
    for l, brick in pairs(row) do
      brick:render()
    end
  end
end
