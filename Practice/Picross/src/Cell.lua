Cell = {}

function Cell:new(column, row, size, value)
  local this = {
    ["column"] = column,
    ["row"] = row,
    ["x"] = (column - 1) * size,
    ["y"] = (row - 1) * size,
    ["size"] = size,
    ["value"] = value
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Cell:render()
  if self.value == "o" then
    love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
  end
end
