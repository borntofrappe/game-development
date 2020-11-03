Cell = {}
Cell.__index = Cell

function Cell:new(def)
  local def =
    def or
    {
      ["column"] = 1,
      ["row"] = 1,
      ["isEven"] = false
    }

  local version = def.isEven and "light" or "dark"
  local size = CELL_SIZE

  this = {
    ["column"] = def.column,
    ["row"] = def.row,
    ["version"] = version,
    ["size"] = size,
    ["isRevealed"] = false
  }

  setmetatable(this, self)
  return this
end

function Cell:render()
  if self.isRevealed then
    love.graphics.setColor(
      gColors["cell-revealed-" .. self.version].r,
      gColors["cell-revealed-" .. self.version].g,
      gColors["cell-revealed-" .. self.version].b
    )
    love.graphics.rectangle("fill", (self.column - 1) * self.size, (self.row - 1) * self.size, self.size, self.size)
  else
    love.graphics.setColor(
      gColors["cell-" .. self.version].r,
      gColors["cell-" .. self.version].g,
      gColors["cell-" .. self.version].b
    )
    love.graphics.rectangle("fill", (self.column - 1) * self.size, (self.row - 1) * self.size, self.size, self.size)
  end
end
