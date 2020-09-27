PlayState = BaseState:create()

function PlayState:enter()
  self.toggleGrid = false

  self.direction = nil
  self.snake = Snake:create()

  self.fruit = Fruit:create()
end

function PlayState:update(dt)
  if love.keyboard.wasPressed("escape") then
    gStateMachine:change("title")
  end

  if self.direction then
    self:changeDirection()
  end

  if love.keyboard.wasPressed("up") then
    self.direction = "top"
  elseif love.keyboard.wasPressed("right") then
    self.direction = "right"
  elseif love.keyboard.wasPressed("down") then
    self.direction = "bottom"
  elseif love.keyboard.wasPressed("left") then
    self.direction = "left"
  end

  self.snake:update(dt)

  if testAABB(self.snake, self.fruit) then
    self.fruit = Fruit:create()
  end
end

function PlayState:render()
  self.snake:render()
  self.fruit:render()
end

function PlayState:changeDirection()
  if (self.snake.x % CELL_SIZE == 0) and (self.snake.y % CELL_SIZE == 0) then
    self.snake.dx = CELL_DIRECTIONS_SPEED[self.direction].x
    self.snake.dy = CELL_DIRECTIONS_SPEED[self.direction].y

    self.direction = nil
  end
end
