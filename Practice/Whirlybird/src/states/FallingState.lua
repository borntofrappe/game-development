FallingState = BaseState:new()

local GAMEOVER_DELAY = 1.5
local FALLING_DELAY = 1.3

function FallingState:enter(params)
  self.player = params.player
  self.player:change("falling")

  self.score = params.score
  self.scrollY = params.scrollY

  self.timer = 0
end

function FallingState:update(dt)
  self.player:update(dt)

  self.timer = self.timer + dt

  if self.timer > GAMEOVER_DELAY then
    gStateMachine:change(
      "gameover",
      {
        ["score"] = self.score
      }
    )
  end

  if self.timer < FALLING_DELAY then
    self.scrollY = LOWER_THRESHOLD - self.player.y - self.player.height
  end
end

function FallingState:render()
  renderScore(self.score)

  love.graphics.translate(0, math.floor(self.scrollY))

  self.player:render()
end
