Coin = {}

local PADDING_PERCENTAGE = 0.3

function Coin:new(column, row)
  local padding = math.floor(CELL_SIZE * PADDING_PERCENTAGE)

  local x = (column - 1) * CELL_SIZE + padding
  local y = (row - 1) * CELL_SIZE + padding
  local size = CELL_SIZE - padding * 2

  local this = {
    ["column"] = column,
    ["row"] = row,
    ["paddingPercentage"] = PADDING_PERCENTAGE,
    ["x"] = x,
    ["y"] = y,
    ["size"] = size
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Coin:render()
  love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
end
