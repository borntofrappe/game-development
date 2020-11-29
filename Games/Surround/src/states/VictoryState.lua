VictoryState = BaseState:create()

function VictoryState:enter(params)
end

function VictoryState:update(dt)
  if love.keyboard.wasPressed("return") then
    Timer:reset()
    gStateMachine:change("play")
  end
end

function VictoryState:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(gFonts["normal"])
  love.graphics.printf("VictoryState", 0, WINDOW_HEIGHT / 2, WINDOW_WIDTH, "center")
end
