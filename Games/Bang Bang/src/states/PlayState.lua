PlayState = BaseState:create()

function PlayState:enter()
end

function PlayState:update(dt)
  if love.keyboard.wasPressed("escape") then
    gStateMachine:change("title")
  end
end

function PlayState:render()
  love.graphics.draw(gTextures["background"], 0, 0)
end
