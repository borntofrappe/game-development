Bouldy = {}
Bouldy.__index = Bouldy

function Bouldy:new(column, row, size, padding, colorFill)
  local x = (column - 1) * size
  local y = (row - 1) * size

  this = {
    ["column"] = column,
    ["row"] = row,
    ["x"] = x,
    ["y"] = y,
    ["size"] = size,
    ["padding"] = padding or 0,
    ["direction"] = {
      ["column"] = 0,
      ["row"] = 0
    },
    ["colorFill"] = colorFill or "light"
  }

  setmetatable(this, self)
  return this
end

function Bouldy:render()
  love.graphics.setColor(gColors[self.colorFill].r, gColors[self.colorFill].g, gColors[self.colorFill].b, 1)
  love.graphics.rectangle(
    "fill",
    (self.x + self.padding),
    (self.y + self.padding),
    (self.size - self.padding * 2),
    (self.size - self.padding * 2)
  )
end
