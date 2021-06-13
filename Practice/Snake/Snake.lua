Snake = {}

function Snake:new()
  local snake = {
    points = 0,
    column = math.random(COLUMNS) - 1,
    row = math.random(ROWS) - 1,
    dcolumn = 0,
    drow = 0,
    body = {}
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

function Snake:eatsItself()
  for i = 1, #self.body do
    if i == 1 then
      if
        (self.column + self.dcolumn) % COLUMNS == self.body[1].column and
          (self.row + self.drow) % ROWS == self.body[1].row
       then
        return true
      end
    else
      if
        (self.column + self.dcolumn) % COLUMNS == self.body[i - 1].column and
          (self.row + self.drow) % ROWS == self.body[i - 1].row
       then
        return true
      end
    end
  end
end

function Snake:collides(food)
  return self.column == food.column and self.row == food.row
end

function Snake:update()
  for k, section in pairs(self.body) do
    if not section.isMoving then
      section.delay = section.delay - 1
      if section.delay == 0 then
        section.isMoving = true
      end
    end
  end

  for i = #self.body, 1, -1 do
    if self.body[i].isMoving then
      if i == 1 then
        self.body[i].column = self.column
        self.body[i].row = self.row
      else
        self.body[i].column = self.body[i - 1].column
        self.body[i].row = self.body[i - 1].row
      end
    end
  end

  self.column = (self.column + self.dcolumn) % COLUMNS
  self.row = (self.row + self.drow) % ROWS
end

function Snake:eat(food)
  self.points = self.points + food.points

  table.insert(
    self.body,
    {
      column = self.column,
      row = self.row,
      delay = #self.body + 1,
      isMoving = false,
      padding = CELL_SIZE * 0.1
    }
  )
end

function Snake:reset()
  self.column = math.random(COLUMNS) - 1
  self.row = math.random(ROWS) - 1
  self.points = 0
  self.body = {}
end

function Snake:render()
  love.graphics.setColor(0.26, 0.28, 0.28)
  for k, section in pairs(self.body) do
    if section.isMoving then
      love.graphics.rectangle(
        "fill",
        section.column * CELL_SIZE + section.padding,
        section.row * CELL_SIZE + section.padding,
        CELL_SIZE - section.padding * 2,
        CELL_SIZE - section.padding * 2
      )
    else
      love.graphics.rectangle("fill", section.column * CELL_SIZE, section.row * CELL_SIZE, CELL_SIZE, CELL_SIZE)
    end
  end

  love.graphics.setColor(0.15, 0.15, 0.16)
  love.graphics.rectangle("fill", self.column * CELL_SIZE, self.row * CELL_SIZE, CELL_SIZE, CELL_SIZE)
end
