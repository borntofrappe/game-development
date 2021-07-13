Coin = {}

function Coin:new(column, row)
  local size = CELL_SIZE
  local paddingPercentage = 0.3
  local padding = math.floor(size * paddingPercentage)
  local innerSize = size - padding * 2

  local this = {
    ["column"] = column,
    ["row"] = row,
    ["size"] = size,
    ["padding"] = padding,
    ["paddingPercentage"] = paddingPercentage,
    ["innerSize"] = innerSize
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Coin:render()
  love.graphics.rectangle(
    "fill",
    (self.column - 1) * self.size + self.padding,
    (self.row - 1) * self.size + self.padding,
    self.innerSize,
    self.innerSize
  )
end
