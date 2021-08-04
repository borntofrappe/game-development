CrashState = BaseState:new()

function CrashState:update(dt)
  if love.keyboard.waspressed("return") or love.keyboard.waspressed("escape") then
    gStateMachine:change("start")
  end
end

function CrashState:render()
  love.graphics.setColor(0.95, 0.95, 0.95)

  love.graphics.setFont(gFonts.normal)
  love.graphics.printf("Crashed!", 0, WINDOW_HEIGHT / 2 - gFonts.normal:getHeight() / 2, WINDOW_WIDTH, "center")
end
