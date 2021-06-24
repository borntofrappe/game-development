Box = {}

function Box:new(column, row, columns, rows)
  local this = {
    ["x"] = column * CELL_SIZE,
    ["y"] = row * CELL_SIZE,
    ["width"] = columns * CELL_SIZE,
    ["height"] = rows * CELL_SIZE,
    ["rx"] = 4,
    ["lineWidth"] = 2
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Box:render()
  love.graphics.setColor(gColors[3].r, gColors[3].g, gColors[3].b)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, self.rx)
  love.graphics.setColor(gColors[4].r, gColors[4].g, gColors[4].b)
  love.graphics.rectangle(
    "fill",
    self.x + self.lineWidth,
    self.y + self.lineWidth,
    self.width - self.lineWidth * 2,
    self.height - self.lineWidth * 2,
    self.rx
  )
end
