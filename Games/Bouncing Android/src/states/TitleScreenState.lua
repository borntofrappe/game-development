TitleScreenState = Class({__includes = BaseState})

function TitleScreenState:init()
  self.image = love.graphics.newImage("res/graphics/title.png")
end

function TitleScreenState:update(dt)
  if love.mouse.waspressed then
    gStateMachine:change("play")
  end
end

function TitleScreenState:render()
  love.graphics.draw(self.image, 0, 0)
end
