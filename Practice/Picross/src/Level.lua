Level = {}

function Level:new(index, isComplete)
  local level = LEVELS[index]
  local name = level.name
  local sequence, dimension = level.grid:gsub("[^xo]", "")
  local grid = {}

  local size = GRID_SIZE
  local cellSize = size / dimension

  local hints = {
    ["columns"] = {},
    ["rows"] = {}
  }

  for row = 1, dimension do
    for column = 1, dimension do
      local index = column + (row - 1) * dimension
      local state = sequence:sub(index, index)
      local value
      if isComplete and state == "o" then
        value = state
      end

      local cell = Cell:new(column, row, cellSize, state, value)
      table.insert(grid, cell)

      if not hints.columns[column] then
        hints.columns[column] = {0}
      end

      if not hints.rows[row] then
        hints.rows[row] = {0}
      end

      if state == "o" then
        hints.columns[column][#hints.columns[column]] = hints.columns[column][#hints.columns[column]] + 1
        hints.rows[row][#hints.rows[row]] = hints.rows[row][#hints.rows[row]] + 1
      else
        if hints.columns[column][#hints.columns[column]] ~= 0 then
          hints.columns[column][#hints.columns[column] + 1] = 0
        end
        if hints.rows[row][#hints.rows[row]] ~= 0 then
          hints.rows[row][#hints.rows[row] + 1] = 0
        end
      end
    end
  end

  for i, hintColumn in ipairs(hints.columns) do
    if #hintColumn > 1 and hintColumn[#hintColumn] == 0 then
      table.remove(hintColumn)
    end
  end

  for i, hintRow in ipairs(hints.rows) do
    if #hintRow > 1 and hintRow[#hintRow] == 0 then
      table.remove(hintRow)
    end
  end

  local this = {
    ["name"] = name,
    ["size"] = size,
    ["cellSize"] = cellSize,
    ["dimension"] = dimension,
    ["grid"] = grid,
    ["hints"] = hints,
    ["extraOpacity"] = isComplete and 0 or 1
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Level:render()
  love.graphics.setColor(0.98, 0.85, 0.05, self.extraOpacity)
  love.graphics.rectangle("fill", 0, 0, self.size, self.size)

  love.graphics.setLineWidth(1)
  love.graphics.setColor(0.05, 0.05, 0.15, self.extraOpacity * 0.15)
  for k = 1, self.dimension + 1 do
    love.graphics.line((k - 1) * self.cellSize, 0, (k - 1) * self.cellSize, self.size)
    love.graphics.line(0, (k - 1) * self.cellSize, self.size, (k - 1) * self.cellSize)
  end

  love.graphics.setColor(0.07, 0.07, 0.2)
  for k, cell in pairs(self.grid) do
    cell:render()
  end

  love.graphics.setColor(0.07, 0.07, 0.2, self.extraOpacity)
  love.graphics.setFont(gFonts.normal)
  for i, hintsColumn in ipairs(self.hints.columns) do
    for j, hintColumn in ipairs(hintsColumn) do
      love.graphics.printf(
        hintColumn,
        self.cellSize * (i - 1),
        self.cellSize * (#hintsColumn - j + 1) * -1 + self.cellSize / 2 - gFonts.normal:getHeight() / 2,
        self.cellSize,
        "center"
      )
    end
  end

  for i, hintsRow in ipairs(self.hints.rows) do
    for j, hintRow in ipairs(hintsRow) do
      love.graphics.printf(
        hintRow,
        self.cellSize * (#hintsRow - j + 1) * -1,
        self.cellSize * (i - 1) + self.cellSize / 2 - gFonts.normal:getHeight() / 2,
        self.cellSize,
        "center"
      )
    end
  end
end
