--[[ Cell
  render a filled rectangle only if the cell is alive
]]
Cell = {}
Cell.__index = Cell

function Cell:new(column, row, size, offset)
  local isAlive = math.random(2) == 1 and true or false
  local aliveNeighbors = 0

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

function Cell:reset()
  self.isAlive = math.random(2) == 1 and true or false
  self.aliveNeighbors = 0
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