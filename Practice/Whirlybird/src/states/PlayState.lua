PlayState = BaseState:new()

function PlayState:enter(params)
  self.player = params.player
  self.player:change("flying")
end

function PlayState:update(dt)
  if love.keyboard.waspressed("return") then
    gStateMachine:change(
      "gameover",
      {
        ["player"] = self.player
      }
    )
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

function PlayState:render()
  love.graphics.setFont(gFonts["normal"])
  love.graphics.setColor(0, 0, 0)
  love.graphics.printf("Play", 0, 8, WINDOW_WIDTH, "center")

  self.player:render()
end
