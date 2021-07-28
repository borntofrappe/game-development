FallingState = BaseState:new()

local GAMEOVER_DELAY = 1
local FALLING_DELAY = 0.9

function FallingState:enter(params)
  self.player = params.player
  self.scrollY = params.scrollY

  self.timer = 0
end

function FallingState:update(dt)
  self.player:update(dt)

  self.timer = self.timer + dt

  if self.timer > GAMEOVER_DELAY then
    gStateMachine:change("gameover")
  end

  if self.timer < FALLING_DELAY then
    self.scrollY = LOWER_THRESHOLD - self.player.height - self.player.y
  end
end

function FallingState:render()
  love.graphics.translate(0, math.floor(self.scrollY))

  self.player:render()
end
