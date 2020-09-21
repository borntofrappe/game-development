PlayState = BaseState:create()

function PlayState:enter()
  self.toggleGrid = false
  self.snake = Snake:create(1, 1)
end

function PlayState:update(dt)
  if love.keyboard.wasPressed("escape") then
    gStateMachine:change("title")
  end

  if love.keyboard.wasPressed("g") or love.keyboard.wasPressed("G") then
    self.toggleGrid = not self.toggleGrid
  end
end

function PlayState:render()
  self.snake:render()

  if self.toggleGrid then
    love.graphics.clear(0.035, 0.137, 0.298, 1)
    self:renderGrid()
  end
end

function PlayState:renderGrid()
  local columns = WINDOW_WIDTH / CELL_SIZE
  local rows = WINDOW_HEIGHT / CELL_SIZE

  love.graphics.setColor(0.224, 0.824, 0.604)
  for x = 1, columns do
    for y = 1, rows do
      love.graphics.rectangle("line", (x - 1) * CELL_SIZE, (y - 1) * CELL_SIZE, CELL_SIZE, CELL_SIZE)
    end
  end
end
