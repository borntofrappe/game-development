PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.board = Board(true, VIRTUAL_WIDTH / 2 + 100)
end

function PlayState:update(dt)
  if love.keyboard.waspressed("escape") then
    gStateMachine:change("title")
  end
  self.board:update(dt)
end

function PlayState:render()
  self.board:render()
end
