Grid = {}
Grid.__index = Grid

function Grid:new(columns, rows, width, height, offset)
  local cells = {}
  local cellSize = width / columns

  for column = 1, columns do
    cells[column] = {}
    for row = 1, rows do
      cells[column][row] = Cell:new(column, row, cellSize, offset)
    end
  end

  this = {
    ["columns"] = columns,
    ["rows"] = rows,
    ["width"] = width,
    ["height"] = height,
    ["cells"] = cells,
    ["offset"] = offset
  }

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
          if self.cells[c][r].isAlive and (c ~= column or r ~= row) then
            aliveNeighbors = aliveNeighbors + 1
          end
        end
      end

      self.cells[column][row].aliveNeighbors = aliveNeighbors
    end
  end

  for column = 1, self.columns do
    for row = 1, self.rows do
      local aliveNeighbors = self.cells[column][row].aliveNeighbors
      local isAlive = self.cells[column][row].isAlive
      if isAlive then
        if aliveNeighbors < 2 or aliveNeighbors > 3 then
          self.cells[column][row].isAlive = false
        end
      else
        if aliveNeighbors == 3 then
          self.cells[column][row].isAlive = true
        end
      end
    end
  end
end

function Grid:reset()
  for column = 1, self.columns do
    for row = 1, self.rows do
      self.cells[column][row]:reset()
    end
  end
end

function Grid:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setLineWidth(2)
  love.graphics.rectangle("line", self.offset.x, self.offset.y, self.width, self.height)

  for column = 1, self.columns do
    for row = 1, self.rows do
      self.cells[column][row]:render()
    end
  end
end
