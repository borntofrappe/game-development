Cell = {}

function Cell:new(column, row, size, color)
  local this = {
    ["column"] = column,
    ["row"] = row,
    ["size"] = size,
    ["color"] = color
  }

  self.__index = self
  setmetatable(this, self)
  return this
end

function Cell:render()
  love.graphics.rectangle("fill", (self.column - 1) * self.size, (self.row - 1) * self.size, self.size, self.size)
end
