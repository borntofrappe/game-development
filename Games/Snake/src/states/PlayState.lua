PlayState = BaseState:create()

function PlayState:enter()
  self.toggleGrid = false
  self.snake = Snake:create()

  self.fruit = Fruit:create()
end

function PlayState:update(dt)
  if love.keyboard.wasPressed("escape") then
    gStateMachine:change("title")
  end

  self.snake:update(dt, true)

  if testAABB(self.snake, self.fruit) then
    self.fruit = Fruit:create()
  end
end

function PlayState:render()
  self.snake:render()
  self.fruit:render()
end
