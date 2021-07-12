Player = {}

function Player:new(column, row, label)
  local cell = Cell:new(column, row, CELL_SIZE)

  local offset = {
    ["column"] = column,
    ["row"] = row
  }

  local this = {
    ["cell"] = cell,
    ["label"] = label,
    ["offset"] = offset,
    ["color"] = COLORS[label]
  }

  self.__index = self
  setmetatable(this, self)
  return this
end

function Player:render()
  love.graphics.setColor(self.color.r, self.color.g, self.color.b)
  self.cell:render()
end
