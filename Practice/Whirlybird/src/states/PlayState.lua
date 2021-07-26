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
end

function PlayState:render()
  love.graphics.setFont(gFonts["normal"])
  love.graphics.setColor(0, 0, 0)
  love.graphics.printf("Play", 0, 8, WINDOW_WIDTH, "center")

  self.player:render()
end
