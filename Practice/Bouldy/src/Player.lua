Player = {}

function Player:new(maze)
  local column = math.random(maze.columns)
  local row = math.random(maze.rows)

  local size = CELL_SIZE
  local padding = math.floor(size * 0.25)
  local innerSize = size - padding * 2

  local this = {
    ["column"] = column,
    ["row"] = row,
    ["size"] = size,
    ["padding"] = padding,
    ["innerSize"] = innerSize,
    ["fill"] = {
      ["r"] = 1,
      ["g"] = 1,
      ["b"] = 1
    }
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Player:setFill(fill)
  self.fill = fill
end

function Player:render()
  love.graphics.setColor(self.fill.r, self.fill.g, self.fill.b)

  love.graphics.rectangle(
    "fill",
    (self.column - 1) * self.size + self.padding,
    (self.row - 1) * self.size + self.padding,
    self.innerSize,
    self.innerSize
  )
end
