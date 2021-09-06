StartState = BaseState:new()

function StartState:update(dt)
  if love.keyboard.waspressed("escape") or love.mouse.waspressed(2) then
    love.event.quit()
  end

  if love.keyboard.waspressed("return") or love.mouse.waspressed(1) then
    gStateMachine:change("play")
  end
end

function StartState:render()
  love.graphics.setColor(0.07, 0.14, 0.07)
  love.graphics.setFont(gFonts.large)
  love.graphics.printf(TITLE, 0, WINDOW_SIZE / 2 - gFonts.large:getHeight() - 2, WINDOW_SIZE, "center")
end
