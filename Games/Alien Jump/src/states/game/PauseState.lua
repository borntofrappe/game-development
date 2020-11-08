PauseState = Class {__includes = BaseState}

function PauseState:init(def)
  self.player = def.player
  self.player:changeState("squat")
end

function PauseState:update(dt)
  if love.keyboard.wasReleased("down") or love.keyboard.wasReleased("s") then
    self.player:changeState("walk")
    gStateStack:pop()
  end
end
