Level = {}

function Level:new(index, x, y, size, isComplete)
  local level = LEVELS[index]
  local name = level.name
  local sequence, dimension = level.grid:gsub("[^xo]", "")
  local grid = {}

  local cellSize = size / dimension

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
    end
  end

  local this = {
    ["index"] = index,
    ["name"] = name,
    ["x"] = x,
    ["y"] = y,
    ["cellSize"] = cellSize,
    ["grid"] = grid,
    ["dimension"] = dimension
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Level:render()
  love.graphics.setColor(gColors.text.r, gColors.text.g, gColors.text.b)
  for k, cell in pairs(self.grid) do
    cell:render()
  end
end
