PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.paddle = Paddle()
end

function PlayState:enter(params)
  if params then
    self.paddle.x = params.x
  end
end

function PlayState:update(dt)
  if love.keyboard.waspressed("escape") then
    gStateMachine:change("start")
    gSounds["confirm"]:play()
  end

  if love.keyboard.waspressed("enter") or love.keyboard.waspressed("return") then
    gStateMachine:change(
      "pause",
      {
        x = self.paddle.x
      }
    )
    gSounds["pause"]:play()
  end

  self.paddle:update(dt)
end

function PlayState:render()
  self.paddle:render()
end
