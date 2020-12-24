DialogueState = Class({__includes = BaseState})

function DialogueState:update(dt)
  if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") or love.keyboard.wasPressed("escape") then
    gStateStack:pop()
  end
end

function DialogueState:render()
  love.graphics.setColor(1, 1, 1, 0.5)
  love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)

  love.graphics.setColor(0, 0, 0, 0.7)
  love.graphics.rectangle("fill", WINDOW_WIDTH / 2 - 45, WINDOW_HEIGHT / 4 + 12, 90, 40, 5)
  love.graphics.setColor(1, 1, 1)
  love.graphics.printf("DialogueState", 0, WINDOW_HEIGHT / 4 + 24, WINDOW_WIDTH, "center")
end
