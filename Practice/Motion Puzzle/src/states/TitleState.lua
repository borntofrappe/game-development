TitleState = BaseState:new()

function TitleState:update(dt)
  if love.keyboard.waspressed("escape") or love.mouse.waspressed(2) then
    love.event.quit()
  end

  if love.keyboard.waspressed("return") or love.mouse.waspressed(1) then
    gStateMachine:change("play")
  end
end

function TitleState:render()
  love.graphics.setColor(0.07, 0.14, 0.07)
  love.graphics.setFont(gFonts.large)
  love.graphics.printf("Motion Puzzle", 0, WINDOW_SIZE / 2 - gFonts.large:getHeight() - 2, WINDOW_SIZE, "center")
end
