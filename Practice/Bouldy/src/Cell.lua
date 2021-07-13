Cell = {}

function Cell:new(column, row, neighbors)
  local size = CELL_SIZE

  local x0 = (column - 1) * size
  local y0 = (row - 1) * size

  local gates = {
    ["up"] = {
      ["x0"] = 0,
      ["y0"] = 0,
      ["x1"] = size,
      ["y1"] = 0
    },
    ["right"] = {
      ["x0"] = size,
      ["y0"] = 0,
      ["x1"] = size,
      ["y1"] = size
    },
    ["down"] = {
      ["x0"] = 0,
      ["y0"] = size,
      ["x1"] = size,
      ["y1"] = size
    },
    ["left"] = {
      ["x0"] = 0,
      ["y0"] = 0,
      ["x1"] = 0,
      ["y1"] = size
    }
  }

  local this = {
    ["column"] = column,
    ["row"] = row,
    ["x0"] = x0,
    ["y0"] = y0,
    ["gates"] = gates,
    ["neighbors"] = neighbors,
    ["visited"] = false -- unnecessary
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Cell:render()
  for k, gate in pairs(self.gates) do
    love.graphics.line(self.x0 + gate.x0, self.y0 + gate.y0, self.x0 + gate.x1, self.y0 + gate.y1)
  end
end
