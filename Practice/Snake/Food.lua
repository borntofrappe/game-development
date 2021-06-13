Food = {}

local POINTS = 8

function Food:new()
  local food = {
    points = POINTS,
    column = math.random(COLUMNS) - 1,
    row = math.random(ROWS) - 1,
    padding = CELL_SIZE * 0.2
  }

  food.size = CELL_SIZE - food.padding * 2

  self.__index = self
  setmetatable(food, self)

  return food
end

function Food:render()
  love.graphics.rectangle(
    "fill",
    self.column * CELL_SIZE + self.padding,
    self.row * CELL_SIZE + self.padding,
    self.size,
    self.size
  )
end
