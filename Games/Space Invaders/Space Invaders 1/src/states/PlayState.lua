PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.player = Player()
end

function PlayState:update(dt)
  if love.keyboard.waspressed("escape") then
    gStateMachine:change("title")
  end

  self.player:update(dt)
end

function PlayState:render()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
  self.player:render()
end
