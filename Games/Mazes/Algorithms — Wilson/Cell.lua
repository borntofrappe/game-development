Cell = {}
Cell.__index = Cell

function Cell:new(column, row, cellWidth, cellHeight)
  this = {
    ["column"] = column,
    ["row"] = row,
    ["cellWidth"] = cellWidth,
    ["cellHeight"] = cellHeight,
    ["x0"] = (column - 1) * cellWidth,
    ["y0"] = (row - 1) * cellHeight,
    ["gates"] = {
      ["up"] = {
        ["x1"] = 0,
        ["y1"] = 0,
        ["x2"] = cellWidth,
        ["y2"] = 0
      },
      ["right"] = {
        ["x1"] = cellWidth,
        ["y1"] = 0,
        ["x2"] = cellWidth,
        ["y2"] = cellHeight
      },
      ["down"] = {
        ["x1"] = 0,
        ["y1"] = cellHeight,
        ["x2"] = cellWidth,
        ["y2"] = cellHeight
      },
      ["left"] = {
        ["x1"] = 0,
        ["y1"] = 0,
        ["x2"] = 0,
        ["y2"] = cellHeight
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
