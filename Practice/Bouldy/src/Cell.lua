Cell = {}

function Cell:new(column, row, neighbors)
  local size = CELL_SIZE

  local x1 = (column - 1) * size
  local y1 = (row - 1) * size

  local gates = {
    ["up"] = {
      ["x1"] = x1,
      ["y1"] = y1,
      ["x2"] = x1 + size,
      ["y2"] = y1
    },
    ["right"] = {
      ["x1"] = x1 + size,
      ["y1"] = y1,
      ["x2"] = x1 + size,
      ["y2"] = y1 + size
    },
    ["down"] = {
      ["x1"] = x1,
      ["y1"] = y1 + size,
      ["x2"] = x1 + size,
      ["y2"] = y1 + size
    },
    ["left"] = {
      ["x1"] = x1,
      ["y1"] = y1,
      ["x2"] = x1,
      ["y2"] = y1 + size
    }
  }

  local this = {
    ["column"] = column,
    ["row"] = row,
    ["gates"] = gates,
    ["neighbors"] = neighbors,
    ["visited"] = false
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Cell:render()
  for k, gate in pairs(self.gates) do
    love.graphics.line(gate.x1, gate.y1, gate.x2, gate.y2)
  end
end
