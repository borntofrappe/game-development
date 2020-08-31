PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.platforms = {}
  self.x = WINDOW_WIDTH / 2 - PLATFORM_WIDTH / 2
  self.y = WINDOW_HEIGHT - 60

  for i = 1, 5 do
    self.platforms[i] =
      Platform(
      self.x + math.random(PLATFORM_GAP_X * -1, PLATFORM_GAP_X),
      self.y - PLATFORM_GAP_Y * (i - 1),
      math.random(4)
    )
  end
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

  if self.player.dy > 0 then
    for k, platform in pairs(self.platforms) do
      if testAABB(self.player, platform) and self.player.y + self.player.height <= platform.y + platform.height then
        self.player:bounce(platform.y)
      end
    end
  end

  if self.player.y >= WINDOW_HEIGHT - PLAYER_HEIGHT then
    gStateMachine:change("gameover")
  end

  self.player:update(dt)
end

function PlayState:render()
  for k, platform in pairs(self.platforms) do
    platform:render()
  end

  self.player:render()
end
