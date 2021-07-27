FallingState = BaseState:new()

local GAMEOVER_DELAY = 2

function FallingState:enter(params)
  self.player = params.player
  self.player.y = LOWER_THRESHOLD
  self.player:change("falling")

  self.timer = 0
end

function FallingState:update(dt)
  self.player:update(dt)

  self.timer = self.timer + dt

  if self.timer > GAMEOVER_DELAY then
    gStateMachine:change("gameover")
  end
end

function FallingState:render()
  self.player:render()
end
