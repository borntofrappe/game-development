Level = Class {}

function Level:init(n)
  local n = n or math.random(#LEVELS)

  self.name = LEVELS[n].name
  self.level = LEVELS[n].level
  self.levelString = string.gsub(self.level, "[^xo]", "")

  self.grid = {}
  self:buildGrid()
end

function Level:render()
  love.graphics.translate(
    WINDOW_WIDTH / 2 - (#self.grid / 2 * CELL_SIZE),
    WINDOW_HEIGHT / 2 - (#self.grid / 2 * CELL_SIZE)
  )

  for i, row in ipairs(self.grid) do
    for i, cell in ipairs(row) do
      cell:render()
    end
  end
end

function Level:buildGrid()
  local len = #self.levelString
  local side = math.floor(math.sqrt(len))

  for i = 0, len - 1 do
    local column = (i % side) + 1
    local row = math.floor(i / side) + 1
    local value = string.sub(self.levelString, i + 1, i + 1)

    local cell = Cell(column, row, value)
    if self.grid[row] then
      table.insert(self.grid[row], cell)
    else
      table.insert(self.grid, {cell})
    end
  end
end
