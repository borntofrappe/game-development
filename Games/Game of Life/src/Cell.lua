Cell = {}
Cell.__index = Cell

function Cell:new(column, row, size, isAlive, aliveNeighors, offset)
  local cells = {}

  this = {
    ["column"] = column,
    ["row"] = row,
    ["size"] = size,
    ["isAlive"] = isAlive,
    ["aliveNeighbors"] = aliveNeighbors,
    ["offset"] = offset
  }

  setmetatable(this, self)
  return this
end

function Cell:render()
  if self.isAlive then
    love.graphics.rectangle(
      "fill",
      self.offset.x + (self.column - 1) * self.size,
      self.offset.y + (self.row - 1) * self.size,
      self.size,
      self.size
    )
  end
end
