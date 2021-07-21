Level = {}

function Level:new()
  local level = LEVELS[math.random(#LEVELS)]
  local sequence, dimension = level.grid:gsub("[^xo]", "")
  local grid = {}

  for row = 1, dimension do
    for column = 1, dimension do
      local index = column + (row - 1) * dimension
      local value = sequence:sub(index, index)
      local cell = Cell:new(column, row, CELL_SIZE, value)

      table.insert(grid, cell)
    end
  end

  local this = {
    ["grid"] = grid
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Level:render()
  for k, cell in pairs(self.grid) do
    cell:render()
  end
end
