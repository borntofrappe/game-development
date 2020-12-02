Cell = {}
Cell.__index = Cell

function Cell:new(column, row, width, height)
  this = {
    ["column"] = column,
    ["row"] = row,
    ["width"] = width,
    ["height"] = height,
    ["x0"] = (column - 1) * width,
    ["y0"] = (row - 1) * height,
    ["gates"] = {
      ["up"] = {
        ["x1"] = 0,
        ["y1"] = 0,
        ["x2"] = width,
        ["y2"] = 0
      },
      ["right"] = {
        ["x1"] = width,
        ["y1"] = 0,
        ["x2"] = width,
        ["y2"] = height
      },
      ["down"] = {
        ["x1"] = 0,
        ["y1"] = height,
        ["x2"] = width,
        ["y2"] = height
      },
      ["left"] = {
        ["x1"] = 0,
        ["y1"] = 0,
        ["x2"] = 0,
        ["y2"] = height
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
