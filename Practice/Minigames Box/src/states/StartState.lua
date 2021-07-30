StartState = BaseState:new()

function StartState:update(dt)
  if love.mouse.waspressed(1) then
    local x, y = love.mouse:getPosition()
    if
      x > WINDOW_PADDING and x < WINDOW_WIDTH - WINDOW_PADDING and y > WINDOW_PADDING and
        y < WINDOW_HEIGHT - WINDOW_PADDING
     then
      gStateMachine:change("countdown")
    end
  end
end

function StartState:render()
  love.graphics.setFont(gFonts.large)
  love.graphics.printf("Minigames Box", 0, PLAYING_HEIGHT / 2 - gFonts.large:getHeight(), PLAYING_WIDTH, "center")
  love.graphics.setFont(gFonts.normal)
  love.graphics.printf("Physics-based 2D experiments", 0, PLAYING_HEIGHT / 2 + 24, PLAYING_WIDTH, "center")
end
