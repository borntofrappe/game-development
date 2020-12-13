Cell = {}
Cell.__index = Cell

function Cell:new(column, row, neighbors, size)
  this = {
    ["column"] = column,
    ["row"] = row,
    ["neighbors"] = neighbors,
    ["size"] = size,
    ["x0"] = (column - 1) * size,
    ["y0"] = (row - 1) * size,
    ["gates"] = {
      ["up"] = {
        ["x1"] = 0,
        ["y1"] = 0,
        ["x2"] = size,
        ["y2"] = 0
      },
      ["right"] = {
        ["x1"] = size,
        ["y1"] = 0,
        ["x2"] = size,
        ["y2"] = size
      },
      ["down"] = {
        ["x1"] = 0,
        ["y1"] = size,
        ["x2"] = size,
        ["y2"] = size
      },
      ["left"] = {
        ["x1"] = 0,
        ["y1"] = 0,
        ["x2"] = 0,
        ["y2"] = size
      }
    },
    ["visited"] = false
  }

  setmetatable(this, self)
  return this
end

function Cell:render()
  for k, gate in pairs(self.gates) do
    love.graphics.line(self.x0 + gate.x1, self.y0 + gate.y1, self.x0 + gate.x2, self.y0 + gate.y2)
  end
end
