PlayState = Class {__includes = BaseState}

function PlayState:init()
  self.title = "Play"
end

function PlayState:enter(params)
  self.player = params.player
end

function PlayState:update(dt)
  if love.keyboard.wasPressed("escape") then
    gStateMachine:change("title")
  end

  self.player:update(dt)
end

function PlayState:render()
  self.player:render()
end
