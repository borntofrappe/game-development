FallingState = BaseState:new()

local GAMEOVER_DELAY = 1.5

function FallingState:enter(params)
  self.player = params.player
  self.scrollY = params.scrollY
  self.player:change("falling")

  self.timer = 0
end

function FallingState:update(dt)
  self.player:update(dt)

  if self.player.y > LOWER_THRESHOLD - self.scrollY then
    self.scrollY = LOWER_THRESHOLD - self.player.y
  end

  self.timer = self.timer + dt

  if self.timer > GAMEOVER_DELAY then
    gStateMachine:change("gameover")
  end
end

function FallingState:render()
  love.graphics.translate(0, math.floor(self.scrollY))
  self.player:render()
end
