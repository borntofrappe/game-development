PlayState = BaseState:create()

function PlayState:enter()
  self.toggleGrid = false
  self.snake = Snake:create()
  self.snake.direction = nil
end

function PlayState:update(dt)
  if love.keyboard.wasPressed("escape") then
    gStateMachine:change("title")
  end

  self.snake:update(dt, true)
end

function PlayState:render()
  self.snake:render()
end
