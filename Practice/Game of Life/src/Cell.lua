Cell = {}

function Cell:new(column, row, size, isAlive)
  local this = {
    ["column"] = column,
    ["row"] = row,
    ["x"] = (column - 1) * size,
    ["y"] = (row - 1) * size,
    ["size"] = size,
    ["isAlive"] = isAlive,
    ["aliveNeighbors"] = 0
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Cell:render()
  if self.isAlive then
    love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
  end
end
