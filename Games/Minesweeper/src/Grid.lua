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

function Grid:pointToCell(x, y)
  if x < PADDING_X or x > WINDOW_WIDTH - PADDING_X or y < MENU_HEIGHT + PADDING_Y or y > WINDOW_HEIGHT - PADDING_Y then
    return false
  else
    local column = math.floor((x - PADDING_X) / CELL_SIZE) + 1
    local row = math.floor((y - PADDING_Y - MENU_HEIGHT) / CELL_SIZE) + 1
    return column, row
  end
end

function Grid:update(dt)
  if love.mouse.wasPressed() then
    local column, row = self:pointToCell(love.mouse:getPosition())
    if column then
      self.cells[column][row].isRevealed = true
    end
  end
end

function Grid:render()
  for i, column in ipairs(self.cells) do
    for j, cell in ipairs(column) do
      cell:render()
    end
  end
end
