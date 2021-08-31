Tiles = {}

local OFFSET_INCREMENT = 0.15
local OFFSET_START_MAX = 1000

function Tiles:new()
  local offsetStartColumn = love.math.random(OFFSET_START_MAX)
  local offsetStartRow = love.math.random(OFFSET_START_MAX)
  local offsetColumn = offsetStartColumn
  local offsetRow = offsetStartRow

  local grid = {}
  local cellSize = TILE_SIZE
  local columns = TILES_COLUMNS
  local rows = TILES_ROWS

  for column = 1, columns do
    offsetRow = 0
    grid[column] = {}
    for row = 1, rows do
      offsetRow = offsetRow + OFFSET_INCREMENT

      local x = (column - 1) * cellSize
      local y = (row - 1) * cellSize
      local noise = love.math.noise(offsetColumn, offsetRow)
      local id = math.ceil(noise * (TILE_TYPES - 1)) + 1 -- skip the base layer
      local tile = Tile:new(x, y, id)
      tile.inPlay = true

      grid[column][row] = tile
    end
    offsetColumn = offsetColumn + OFFSET_INCREMENT
  end

  local this = {
    ["grid"] = grid,
    ["cellSize"] = cellSize,
    ["columns"] = columns,
    ["rows"] = rows
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Tiles:render()
  love.graphics.setColor(1, 1, 1)

  for column = 1, self.columns do
    for row = 1, self.rows do
      if self.grid[column][row].inPlay then
        self.grid[column][row]:render()
      end
    end
  end
end
