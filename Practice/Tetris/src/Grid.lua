Grid = {}

local FRAME_BORDER = 7

function Grid:new()
  local columns = GRID_COLUMNS
  local rows = GRID_ROWS

  local width = columns * CELL_SIZE
  local height = rows * CELL_SIZE

  local border = {}
  for column = 1, BORDER_COLUMNS do
    for row = 1, rows do
      table.insert(border, Brick:new(column - 1, row, FRAME_BORDER))
      table.insert(border, Brick:new(columns + column, row, FRAME_BORDER))
    end
  end

  local bricks = {}
  for column = 1, GRID_COLUMNS do
    bricks[column] = {}
    for row = 1, rows do
      bricks[column][row] = nil
    end
  end

  local this = {
    ["width"] = width,
    ["height"] = height,
    ["columns"] = columns,
    ["rows"] = rows,
    ["border"] = border,
    ["bricks"] = bricks
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Grid:fill(tetromino)
  for k, brick in pairs(tetromino.bricks) do
    local column = brick.column
    local row = brick.row
    local frame = brick.frame
    local columnOffset = brick.columnOffset
    self.bricks[column][row] = Brick:new(column, row, frame, columnOffset)
  end
end

function Grid:render()
  love.graphics.setColor(gColors[4].r, gColors[4].g, gColors[4].b)
  love.graphics.rectangle("fill", 0, 0, self.width, self.height)

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
