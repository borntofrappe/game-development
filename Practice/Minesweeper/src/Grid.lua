Grid = {}

function Grid:new()
  local mines = MINES
  local minesCoords = {}

  repeat
    local column = math.random(COLUMNS)
    local row = math.random(ROWS)

    if not minesCoords["c" .. column .. "r" .. row] then
      minesCoords["c" .. column .. "r" .. row] = true
      mines = mines - 1
    end
  until mines == 0

  local cells = {}
  for column = 1, COLUMNS do
    cells[column] = {}
    for row = 1, ROWS do
      cells[column][row] =
        Cell:new(
        {
          ["column"] = column,
          ["row"] = row,
          ["isDark"] = (column + row) % 2 == 0,
          ["hasMine"] = minesCoords["c" .. column .. "r" .. row]
        }
      )
    end
  end

  for column = 1, COLUMNS do
    for row = 1, ROWS do
      if not cells[column][row].hasMine then
        local c1 = math.max(1, column - 1)
        local c2 = math.min(COLUMNS, column + 1)
        local r1 = math.max(1, row - 1)
        local r2 = math.min(ROWS, row + 1)
        local neighboringMines = 0
        for c = c1, c2 do
          for r = r1, r2 do
            if (c ~= column or r ~= row) and cells[c][r].hasMine then
              neighboringMines = neighboringMines + 1
            end
          end
        end
        cells[column][row].neighboringMines = neighboringMines
      end
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
  if not self.cells[column][row].isRevealed and not self.cells[column][row].isFlagged then
    self.cells[column][row].isRevealed = true
    if self.cells[column][row].hasMine then
      self:revealAll()

      return true
    elseif self.cells[column][row].neighboringMines == 0 then
      local c1 = math.max(1, column - 1)
      local c2 = math.min(COLUMNS, column + 1)
      local r1 = math.max(1, row - 1)
      local r2 = math.min(ROWS, row + 1)
      for c = c1, c2 do
        for r = r1, r2 do
          if (c ~= column or r ~= row) then
            self:reveal(c, r)
          end
        end
      end
    end
  end
end

function Grid:revealAll()
  for column = 1, COLUMNS do
    for row = 1, ROWS do
      self.cells[column][row].isRevealed = true
    end
  end
end

function Grid:toggleFlag(column, row)
  if not self.cells[column][row].isRevealed then
    self.cells[column][row].isFlagged = not self.cells[column][row].isFlagged
  end
end

function Grid:render()
  for column = 1, COLUMNS do
    for row = 1, ROWS do
      self.cells[column][row]:render()
    end
  end
end
