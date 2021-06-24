Grid = {}

local FRAME_BORDER = 7
local FRAME_GAMEOVER = 6

function Grid:new()
  local columns = COLUMNS_GRID
  local rows = ROWS_GRID

  local border = {}
  for column = 1, COLUMNS_BORDER do
    for row = 1, rows do
      table.insert(border, Brick:new(column - 1, row, FRAME_BORDER))
      table.insert(border, Brick:new(columns + column, row, FRAME_BORDER))
    end
  end

  local bricks = {}
  for column = 1, columns do
    bricks[column] = {}
    for row = 1, rows do
      bricks[column][row] = nil
    end
  end

  local this = {
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
    self.bricks[column][row] = Brick:new(column, row, frame)
  end
end

function Grid:getClearedLines()
  local clearedLines = {}

  for row = self.rows, 1, -1 do
    local isLineCleared = true

    for column = 1, self.columns do
      if not self.bricks[column][row] then
        isLineCleared = false
        break
      end
    end

    if isLineCleared then
      table.insert(clearedLines, row)
    end
  end

  return clearedLines
end

function Grid:updateClearedLines(clearedLines)
  for i = #clearedLines, 1, -1 do
    local lineCleared = clearedLines[i]
    for column = 1, self.columns do
      self.bricks[column][lineCleared] = nil
    end

    for row = lineCleared - 1, 1, -1 do
      for column = 1, self.columns do
        if self.bricks[column][row] then
          self.bricks[column][row + 1] = Brick:new(column, row + 1, self.bricks[column][row].frame)
          self.bricks[column][row] = nil
        end
      end
    end
  end
end

function Grid:fillGameoverLines()
  for column = 1, self.columns do
    for row = 1, self.rows do
      self.bricks[column][row] = Brick:new(column, row, FRAME_GAMEOVER)
    end
  end
end

function Grid:reset()
  for column = 1, self.columns do
    for row = 1, self.rows do
      self.bricks[column][row] = nil
    end
  end
end

function Grid:render()
  love.graphics.setColor(gColors[4].r, gColors[4].g, gColors[4].b)
  love.graphics.rectangle("fill", 0, 0, self.columns * CELL_SIZE, self.rows * CELL_SIZE)

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
