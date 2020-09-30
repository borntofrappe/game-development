StartState = BaseState:create()

function StartState:enter()
  self.snake = Snake:create()
  self.snake.interval = 0.2
  self.snake.direction = DIRECTIONS[math.random(#DIRECTIONS)]
  self.fruit = Fruit:create()
end

function StartState:update(dt)
  if love.keyboard.wasPressed("escape") then
    love.event.quit()
  end

  if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
    if love.keyboard.isDown("c") then
      gStateMachine:change(
        "play",
        {
          snake = self.snake,
          fruit = self.fruit
        }
      )
    else
      gStateMachine:change("play", {})
    end
  end

  self.snake:update(dt)
  if testAABB(self.snake, self.fruit) then
    self.fruit = Fruit:create()
    self.snake:growTail()
  end

  if math.random(100) == 1 then
    local direction = DIRECTIONS[math.random(#DIRECTIONS)]
    if isDirectionValid(self.snake, direction) then
      self.snake.direction = direction
    end
  end
end

function StartState:render()
  self.snake:render()
  self.fruit:render()

  love.graphics.setColor(gColors["background"].r, gColors["background"].g, gColors["background"].b, 0.35)
  love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)

  love.graphics.setColor(gColors["foreground"].r, gColors["foreground"].g, gColors["foreground"].b)
  love.graphics.setFont(gFonts["large"])
  love.graphics.printf(string.upper("Snake"), 0, WINDOW_HEIGHT / 2 - 64, WINDOW_WIDTH, "center")

  love.graphics.setFont(gFonts["normal"])
  love.graphics.printf(string.upper("Press enter"), 0, WINDOW_HEIGHT / 2 + 20, WINDOW_WIDTH, "center")
end
