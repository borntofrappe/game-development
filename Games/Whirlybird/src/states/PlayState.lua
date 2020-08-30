PlayState = Class({__includes = BaseState})

function PlayState:init()
end

function PlayState:enter(params)
  self.player = params.player
end

function PlayState:update(dt)
  if love.keyboard.waspressed("escape") then
    gStateMachine:change(
      "start",
      {
        player = self.player
      }
    )
  end

  if love.keyboard.isDown("right") then
    self.player:slide("right")
  end

  if love.keyboard.isDown("left") then
    self.player:slide("left")
  end

  if love.mouse.isDown(1) then
    x = love.mouse.getPosition()
    if x > WINDOW_WIDTH / 2 then
      self.player:slide("right")
    else
      self.player:slide("left")
    end
  end

  if self.player.y >= WINDOW_HEIGHT - PLAYER_HEIGHT then
    self.player:bounce(WINDOW_HEIGHT - PLAYER_HEIGHT)
  end

  self.player:update(dt)
end

function PlayState:render()
  self.player:render()
end
