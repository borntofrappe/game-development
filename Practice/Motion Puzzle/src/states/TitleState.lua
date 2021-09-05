TitleState = BaseState:new()

function TitleState:update(dt)
  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("return") then
    gStateMachine:change("play")
  end
end

function TitleState:render()
  love.graphics.setColor(0, 0, 0)
  love.graphics.setFont(gFonts.large)
  love.graphics.printf("Motion Puzzle", 0, WINDOW_SIZE / 2 - gFonts.large:getHeight(), WINDOW_SIZE, "center")
end
