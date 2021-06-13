Snake = {}

function Snake:new()
  local snake = {
    points = 0,
    column = math.random(COLUMNS) - 1,
    row = math.random(ROWS) - 1,
    dcolumn = 0,
    drow = 0
  }

  self.__index = self
  setmetatable(snake, self)

  return snake
end

function Snake:turn(direction)
  if direction == "up" then
    self.dcolumn = 0
    self.drow = -1
  elseif direction == "right" then
    self.dcolumn = 1
    self.drow = 0
  elseif direction == "down" then
    self.dcolumn = 0
    self.drow = 1
  elseif direction == "left" then
    self.dcolumn = -1
    self.drow = 0
  end
end

function Snake:update()
  self.column = (self.column + self.dcolumn) % COLUMNS
  self.row = (self.row + self.drow) % ROWS
end

function Snake:eat(food)
  self.points = self.points + food.points
end

function Snake:reset()
  self.column = math.random(COLUMNS) - 1
  self.row = math.random(ROWS) - 1
  self.points = 0
end

function Snake:render()
  love.graphics.rectangle("fill", self.column * CELL_SIZE, self.row * CELL_SIZE, CELL_SIZE, CELL_SIZE)
end
