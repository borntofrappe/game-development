PlayState = BaseState:create()

function PlayState:enter(params)
end

function PlayState:update(dt)
  if love.keyboard.wasPressed("return") then
    Timer:reset()
    gStateMachine:change("victory")
  end
end

function PlayState:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(gFonts["normal"])
  love.graphics.printf("PlayState", 0, WINDOW_HEIGHT / 2, WINDOW_WIDTH, "center")
end
