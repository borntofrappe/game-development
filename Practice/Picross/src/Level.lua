Level = {}

function Level:new(index, x, y, size, isComplete)
  local level = LEVELS[index]
  local name = level.name
  local sequence, dimension = level.grid:gsub("[^xo]", "")
  local grid = {}

  local size = size or GRID_SIZE
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

      local cell = Cell:new(x + (column - 1) * cellSize, y + (row - 1) * cellSize, cellSize, state, value)
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
    ["index"] = index,
    ["name"] = name,
    ["x"] = x,
    ["y"] = y,
    ["size"] = size,
    ["cellSize"] = cellSize,
    ["grid"] = grid,
    ["dimension"] = dimension,
    ["hints"] = hints,
    ["extraOpacity"] = isComplete and 0 or 1
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Level:render()
  love.graphics.setColor(gColors.highlight.r, gColors.highlight.g, gColors.highlight.b, self.extraOpacity)
  love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)

  love.graphics.setLineWidth(1)
  love.graphics.setColor(gColors.shadow.r, gColors.shadow.g, gColors.shadow.b, gColors.shadow.a * self.extraOpacity)
  for k = 1, self.dimension + 1 do
    love.graphics.line(self.x + (k - 1) * self.cellSize, self.y, self.x + (k - 1) * self.cellSize, self.y + self.size)
    love.graphics.line(self.x, self.y + (k - 1) * self.cellSize, self.x + self.size, self.y + (k - 1) * self.cellSize)
  end

  love.graphics.setColor(gColors.text.r, gColors.text.g, gColors.text.b)
  for k, cell in pairs(self.grid) do
    cell:render()
  end

  love.graphics.setColor(gColors.text.r, gColors.text.g, gColors.text.b, self.extraOpacity)
  love.graphics.setFont(gFonts.normal)
  for i, hintsColumn in ipairs(self.hints.columns) do
    for j, hintColumn in ipairs(hintsColumn) do
      love.graphics.printf(
        hintColumn,
        self.x + self.cellSize * (i - 1),
        self.y + self.cellSize * (#hintsColumn - j + 1) * -1 + self.cellSize / 2 - gFonts.normal:getHeight() / 2,
        self.cellSize,
        "center"
      )
    end
  end

  for i, hintsRow in ipairs(self.hints.rows) do
    for j, hintRow in ipairs(hintsRow) do
      love.graphics.printf(
        hintRow,
        self.x + self.cellSize * (#hintsRow - j + 1) * -1,
        self.y + self.cellSize * (i - 1) + self.cellSize / 2 - gFonts.normal:getHeight() / 2,
        self.cellSize,
        "center"
      )
    end
  end
end
