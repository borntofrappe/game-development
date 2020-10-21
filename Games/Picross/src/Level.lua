Level = Class {}

function Level:init(def)
  local def =
    def or
    {
      number = math.random(#LEVELS)
    }

  self.number = def.number
  self.hideHints = def.hideHints
  self.size = def.size or GRID_SIZE

  self.name = string.sub(LEVELS[self.number].name, 1, 1):upper() .. string.sub(LEVELS[self.number].name, 2, -1)
  self.level = LEVELS[self.number].level
  self.levelString = string.gsub(self.level, "[^xo]", "")

  self.levelStringLength = #self.levelString
  self.gridDimension = math.floor(math.sqrt(self.levelStringLength))
  self.cellSize = math.floor(self.size / self.gridDimension)

  self.grid = {}
  self.hints = {
    ["columns"] = {},
    ["rows"] = {}
  }

  self:buildGrid()
end

function Level:render()
  love.graphics.translate(-self.size / 2, -self.size / 2)

  love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)

  if not self.hideHints then
    love.graphics.setFont(gFonts["normal"])
    for y, hintRow in ipairs(self.hints.rows) do
      for x, hint in ipairs(hintRow) do
        love.graphics.print(
          hint,
          -8 - gSizes["height-font-normal"] * 1.5 * #hintRow + gSizes["height-font-normal"] * 1.5 * (x - 1),
          self.cellSize / 2 - gSizes["height-font-normal"] / 2 + self.cellSize * (y - 1)
        )
      end
    end

    for x, hintColumn in ipairs(self.hints.columns) do
      for y, hint in ipairs(hintColumn) do
        love.graphics.printf(
          hint,
          self.cellSize * (x - 1),
          -8 - gSizes["height-font-normal"] * 1.5 * #hintColumn + gSizes["height-font-normal"] * 1.5 * (y - 1),
          self.cellSize,
          "center"
        )
      end
    end
  end

  for i, cell in ipairs(self.grid) do
    -- for i, cell in ipairs(row) do
    cell:render()
    -- end
  end

  love.graphics.translate(self.size / 2, self.size / 2)
end

function Level:buildGrid()
  for i = 0, self.levelStringLength - 1 do
    local column = (i % self.gridDimension) + 1
    local row = math.floor(i / self.gridDimension) + 1
    local value = string.sub(self.levelString, i + 1, i + 1)
    local size = self.cellSize

    local cell = Cell(column, row, size, value)
    table.insert(self.grid, cell)
    -- if self.grid[row] then
    --   table.insert(self.grid[row], cell)
    -- else
    --   table.insert(self.grid, {cell})
    -- end

    if not self.hints.columns[column] then
      self.hints.columns[column] = {0}
    end

    if not self.hints.rows[row] then
      self.hints.rows[row] = {0}
    end

    if value == "o" then
      self.hints.columns[column][#self.hints.columns[column]] =
        self.hints.columns[column][#self.hints.columns[column]] + 1
      self.hints.rows[row][#self.hints.rows[row]] = self.hints.rows[row][#self.hints.rows[row]] + 1
    else
      if self.hints.columns[column][#self.hints.columns[column]] ~= 0 then
        self.hints.columns[column][#self.hints.columns[column] + 1] = 0
      end
      if self.hints.rows[row][#self.hints.rows[row]] ~= 0 then
        self.hints.rows[row][#self.hints.rows[row] + 1] = 0
      end
    end
  end

  for i, hintColumn in ipairs(self.hints.columns) do
    if #hintColumn > 1 and hintColumn[#hintColumn] == 0 then
      table.remove(hintColumn)
    end
  end

  for i, hintRow in ipairs(self.hints.rows) do
    if #hintRow > 1 and hintRow[#hintRow] == 0 then
      table.remove(hintRow)
    end
  end
end
