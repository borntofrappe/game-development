Neighbor = {}

function Neighbor:new(column, row, gates)
  local this = {
    ["column"] = column,
    ["row"] = row,
    ["gates"] = gates
  }

  self.__index = self
  setmetatable(this, self)

  return this
end
