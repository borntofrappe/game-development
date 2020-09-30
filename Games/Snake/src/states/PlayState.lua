PlayState = BaseState:create()

function PlayState:enter(params)
  self.snake = params.snake or Snake:create()
  self.fruit = params.fruit or Fruit:spawn(self.snake)
end

function PlayState:update(dt)
  if love.keyboard.wasPressed("escape") then
    gStateMachine:change("start")
  end

  if love.keyboard.wasPressed("r") or love.keyboard.wasPressed("R") then
    self:reposition()
  end

  self.snake:update(dt)
  if self.snake:outOfBounds() then
    gStateMachine:change(
      "gameover",
      {
        score = #self.snake.tail * 5
      }
    )
  end
  if testAABB(self.snake, self.fruit) then
    self.snake:growTail()
    self.fruit = Fruit:spawn(self.snake)
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
