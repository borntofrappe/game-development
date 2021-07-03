Grid = {}

local ALIVE_ODDS = 3 -- 1 in 3

function Grid:new(columns, rows, cellSize)
  local cells = {}
  for column = 1, columns do
    cells[column] = {}
    for row = 1, rows do
      local isAlive = math.random(ALIVE_ODDS) == 1
      cells[column][row] = Cell:new(column, row, cellSize, isAlive)
    end
  end

  local this = {
    ["cells"] = cells,
    ["columns"] = columns,
    ["rows"] = rows,
    ["cellSize"] = cellSize,
    ["width"] = columns * cellSize,
    ["height"] = rows * cellSize
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Grid:step()
  for column = 1, self.columns do
    for row = 1, self.rows do
      local c1 = math.max(1, column - 1)
      local c2 = math.min(self.columns, column + 1)
      local r1 = math.max(1, row - 1)
      local r2 = math.min(self.rows, row + 1)

      local aliveNeighbors = 0

      for c = c1, c2 do
        for r = r1, r2 do
          if (c ~= column or r ~= row) and self.cells[c][r].isAlive then
            aliveNeighbors = aliveNeighbors + 1
          end
        end
      end
      self.cells[column][row].aliveNeighbors = aliveNeighbors
    end
  end

  for column = 1, self.columns do
    for row = 1, self.rows do
      if self.cells[column][row].isAlive then
        if self.cells[column][row].aliveNeighbors < 2 or self.cells[column][row].aliveNeighbors > 3 then
          self.cells[column][row].isAlive = false
        end
      else
        if self.cells[column][row].aliveNeighbors == 3 then
          self.cells[column][row].isAlive = true
        end
      end
    end
  end
end

function Grid:reset()
  local cells = {}
  for column = 1, self.columns do
    cells[column] = {}
    for row = 1, self.rows do
      local isAlive = math.random(3) == 1
      cells[column][row] = Cell:new(column, row, self.cellSize, isAlive)
    end
  end

  self.cells = cells
end

function Grid:render()
  love.graphics.rectangle("line", 0, 0, self.width, self.height)
  for column = 1, self.columns do
    for row = 1, self.rows do
      self.cells[column][row]:render()
    end
  end
end
