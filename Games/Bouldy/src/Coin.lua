Coin = {}
Coin.__index = Coin

function Coin:new(column, row, size, padding)
  local x = (column - 1) * size
  local y = (row - 1) * size

  this = {
    ["column"] = column,
    ["row"] = row,
    ["x"] = x,
    ["y"] = y,
    ["size"] = size,
    ["padding"] = padding or size / 4
  }

  setmetatable(this, self)
  return this
end

function Coin:render()
  love.graphics.setColor(gColors["coin"].r, gColors["coin"].g, gColors["coin"].b, 1)
  love.graphics.rectangle(
    "fill",
    (self.x + self.padding),
    (self.y + self.padding),
    (self.size - self.padding * 2),
    (self.size - self.padding * 2)
  )
end
