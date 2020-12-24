PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.paddle = Paddle()
end

function PlayState:update(dt)
  if love.keyboard.waspressed('escape') then
    gStateMachine:change('start')
    gSounds['confirm']:play()
  end

  self.paddle:update(dt)
end

function PlayState:render()
  self.paddle:render()
end