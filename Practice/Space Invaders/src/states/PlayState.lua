PlayState = BaseState:new()

function PlayState:enter()
  self.player = Player:new()
end

function PlayState:update(dt)
  if love.keyboard.waspressed("escape") then
    gStateMachine:change("start")
  end

  self.player:update(dt)
end

function PlayState:render()
  self.player:render()
end
