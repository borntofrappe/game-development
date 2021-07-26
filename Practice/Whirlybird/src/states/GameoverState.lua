GameoverState = BaseState:new()

function GameoverState:enter(params)
  self.player = params.player
  self.player:change("falling")
end

function GameoverState:update(dt)
  if love.keyboard.waspressed("return") then
    gStateMachine:change("start")
  end

  self.player:update(dt)

  if self.player.y + self.player.height >= WINDOW_HEIGHT then
    self.player.y = WINDOW_HEIGHT - self.player.height
    self.player:bounce()
  end

  if love.keyboard.isDown("right") then
    self.player.dx = SLIDE
    self.player.direction = 1
  end

  if love.keyboard.isDown("left") then
    self.player.dx = SLIDE
    self.player.direction = -1
  end
end

function GameoverState:render()
  love.graphics.setFont(gFonts["normal"])
  love.graphics.setColor(0, 0, 0)
  love.graphics.printf("Gameover", 0, 8, WINDOW_WIDTH, "center")

  self.player:render()
end
