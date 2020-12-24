PlayState = Class({__includes = BaseState})

function PlayState:update(dt)
  if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
    gStateStack:push(DialogueState())
  end

  if love.keyboard.wasPressed("escape") then
    love.event.quit()
  end
end

function PlayState:render()
  love.graphics.setColor(0, 0, 0, 0.7)
  love.graphics.rectangle("fill", WINDOW_WIDTH / 2 - 45, WINDOW_HEIGHT / 2 + 48 - 12, 90, 40, 5)
  love.graphics.setColor(1, 1, 1)
  love.graphics.printf("PlayState", 0, WINDOW_HEIGHT / 2 + 48, WINDOW_WIDTH, "center")
end
