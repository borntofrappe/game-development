Grid = {}

local OFFSET_INCREMENT = 0.15 -- the lower the less varied the noise field
local OFFSET_START_MAX = 1000

function Grid:new(x, y, id)
  local offsetStartColumn = love.math.random(OFFSET_START_MAX)
  local offsetStartRow = love.math.random(OFFSET_START_MAX)
  local offsetColumn = offsetStartColumn
  local offsetRow = offsetStartRow

  local columns = GRID_COLUMNS
  local rows = GRID_ROWS
  local tiles = {}
  local tileSize = TILE_SIZE

  for column = 1, columns do
    offsetRow = 0
    tiles[column] = {}
    for row = 1, rows do
      offsetRow = offsetRow + OFFSET_INCREMENT

      local x = (column - 1) * tileSize
      local y = (row - 1) * tileSize
      local noise = love.math.noise(offsetColumn, offsetRow)
      local id = math.ceil(noise * (TEXTURE_TYPES - 1)) + 1 -- skip the base layer
      local tile = Tile:new(x, y, id)

      tiles[column][row] = tile
    end
    offsetColumn = offsetColumn + OFFSET_INCREMENT
  end

  local this = {
    ["tiles"] = tiles,
    ["tileSize"] = tileSize,
    ["columns"] = columns,
    ["rows"] = rows
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Grid:render()
  love.graphics.setColor(1, 1, 1)

  for column = 1, self.columns do
    for row = 1, self.rows do
      self.tiles[column][row]:render()
    end
  end
end
