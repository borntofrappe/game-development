Grid = {}
Grid.__index = Grid

function Grid:new(def)
  local def =
    def or
    {
      ["columns"] = COLUMNS,
      ["rows"] = ROWS
    }

  local cells = {}
  for column = 1, def.columns do
    cells[column] = {}
    for row = 1, def.rows do
      local def = {
        ["column"] = column,
        ["row"] = row,
        ["isEven"] = (column + row) % 2 == 0
      }
      cells[column][row] = Cell:new(def)
    end
  end

  this = {
    ["columns"] = def.columns,
    ["rows"] = def.rows,
    ["cells"] = cells
  }

  setmetatable(this, self)
  return this
end

function Grid:render()
  for i, column in ipairs(self.cells) do
    for j, cell in ipairs(column) do
      cell:render()
    end
  end
end

function Grid:addMines()
  local mines = MINES or 10
  while mines > 0 do
    local column = math.random(self.columns)
    local row = math.random(self.rows)
    local cell = self.cells[column][row]
    if not cell.hasMine then
      cell.hasMine = true
      mines = mines - 1
    end
  end
end

function Grid:addHints()
  for i, column in ipairs(self.cells) do
    for j, cell in ipairs(column) do
      if not cell.hasMine then
        local column = cell.column
        local row = cell.row
        local neighborsWithMine = 0
        local c1 = math.max(1, column - 1)
        local c2 = math.min(self.columns, column + 1)
        local r1 = math.max(1, row - 1)
        local r2 = math.min(self.rows, row + 1)
        for c = c1, c2 do
          for r = r1, r2 do
            if self.cells[c][r].hasMine then
              neighborsWithMine = neighborsWithMine + 1
            end
          end
        end

        cell.neighborsWithMine = neighborsWithMine
      end
    end
  end
end

function Grid:reveal(column, row)
  local cell = self.cells[column][row]
  if not cell.isRevealed and not cell.hasMine then
    cell.isRevealed = true
    if cell.neighborsWithMine == 0 then
      local c1 = math.max(1, column - 1)
      local c2 = math.min(self.columns, column + 1)
      local r1 = math.max(1, row - 1)
      local r2 = math.min(self.rows, row + 1)
      for c = c1, c2 do
        for r = r1, r2 do
          self:reveal(c, r)
        end
      end
    end
  end
end

function Grid:revealAll()
  for i, column in ipairs(self.cells) do
    for j, cell in ipairs(column) do
      cell.isRevealed = true
    end
  end
end
