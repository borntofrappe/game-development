Player = {}

function Player:new(column, row, label)
  local cell = Cell:new(column, row, CELL_SIZE)

  local offset = {
    ["column"] = column,
    ["row"] = row
  }

  local direction = {
    ["column"] = (column - 1) * CELL_SIZE < WINDOW_WIDTH / 2 and 1 or -1,
    ["row"] = 0
  }

  local this = {
    ["cell"] = cell,
    ["label"] = label,
    ["offset"] = offset,
    ["direction"] = direction,
    ["color"] = COLORS[label],
    ["trail"] = {}
  }

  self.__index = self
  setmetatable(this, self)
  return this
end

function Player:turn(direction)
  if direction == "up" then
    self.direction.column = 0
    self.direction.row = -1
  elseif direction == "right" then
    self.direction.column = 1
    self.direction.row = 0
  elseif direction == "down" then
    self.direction.column = 0
    self.direction.row = 1
  elseif direction == "left" then
    self.direction.column = -1
    self.direction.row = 0
  end
end

function Player:outOfBounds()
  return self.cell.column < 1 or self.cell.column > COLUMNS or self.cell.row < 1 or self.cell.row > ROWS
end

function Player:collides(opponent)
  local isColliding = false
  for i, cell in ipairs(opponent.trail) do
    if self.cell.column == cell.column and self.cell.row == cell.row then
      isColliding = true
      break
    end
  end

  return isColliding or (self.cell.column == opponent.cell.column and self.cell.row == opponent.cell.row)
end

function Player:overlaps()
  local isOverlapping = false
  for i, cell in ipairs(self.trail) do
    if self.cell.column == cell.column and self.cell.row == cell.row then
      isOverlapping = true
      break
    end
  end

  return isOverlapping
end

function Player:update()
  table.insert(self.trail, Cell:new(self.cell.column, self.cell.row, CELL_SIZE))

  self.offset.column = self.offset.column + self.direction.column
  self.offset.row = self.offset.row + self.direction.row

  self.cell.column = self.offset.column
  self.cell.row = self.offset.row
end

function Player:render()
  love.graphics.setColor(self.color.r, self.color.g, self.color.b)
  self.cell:render()

  love.graphics.setColor(self.color.r, self.color.g, self.color.b, TRAIL_OPACITY)
  for i, cell in ipairs(self.trail) do
    cell:render()
  end
end
