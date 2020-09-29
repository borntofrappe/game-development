PlayState = BaseState:create()

function PlayState:enter()
  self.snake = Snake:create()
  self.fruit = Fruit:create()
end

function PlayState:update(dt)
  if love.keyboard.wasPressed("escape") then
    gStateMachine:change("start")
  end

  if love.keyboard.wasPressed("r") or love.keyboard.wasPressed("R") then
    self:reposition()
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

function PlayState:reposition()
  self.snake.column = math.random(COLUMNS)
  self.snake.row = math.random(ROWS)

  self.fruit.column = math.random(COLUMNS)
  self.fruit.row = math.random(ROWS)
end
