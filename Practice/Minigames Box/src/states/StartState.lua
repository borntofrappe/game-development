StartState = BaseState:new()

function StartState:update(dt)
  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("return") then
    gStateMachine:change(
      "countdown",
      {
        ["state"] = "strike"
      }
    )
  end
end

function StartState:render()
  love.graphics.setFont(gFonts.large)
  love.graphics.printf("Minigames Box", 0, PLAYING_HEIGHT / 2 - gFonts.large:getHeight(), PLAYING_WIDTH, "center")
  love.graphics.setFont(gFonts.normal)
  love.graphics.printf("Physics-based 2D experiments", 0, PLAYING_HEIGHT / 2 + 24, PLAYING_WIDTH, "center")
end
