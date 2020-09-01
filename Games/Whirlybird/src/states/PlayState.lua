PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.platforms = {}
  self.x = WINDOW_WIDTH / 2 - PLATFORM_WIDTH / 2
  self.y = WINDOW_HEIGHT - 60
  self.y0 = 0
  self.cameraScroll = 0

  for i = 1, 10 do
    self.platforms[i] = Platform(self.x + math.random(PLATFORM_GAP_X * -1, PLATFORM_GAP_X), self.y, math.random(4))
    self.y = self.y - PLATFORM_GAP_Y
  end
end

function PlayState:enter(params)
  self.player = params.player or Player(WINDOW_WIDTH / 2 - PLAYER_WIDTH / 2, WINDOW_HEIGHT / 2 - PLAYER_HEIGHT / 2)
  self.score = params.score or 0
  self.player.dy = -5
end

function PlayState:update(dt)
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

  if self.player.dy < 5 and self.player.y < WINDOW_HEIGHT / 3 - self.cameraScroll then
    self.cameraScroll = self.cameraScroll + 5
    self.score = self.cameraScroll

    for k, platform in pairs(self.platforms) do
      if self.cameraScroll + platform.y > WINDOW_HEIGHT then
        table.remove(self.platforms, k)

        table.insert(
          self.platforms,
          Platform(self.x + math.random(PLATFORM_GAP_X * -1, PLATFORM_GAP_X), self.y, math.random(4))
        )
        self.y = self.y - PLATFORM_GAP_Y
      end
    end
  end

  if self.player.dy > 0 then
    for k, platform in pairs(self.platforms) do
      if testAABB(self.player, platform) and self.player.y + self.player.height <= platform.y + platform.height then
        self.player.y = platform.y - self.player.height
        self.player:bounce()
      end
    end
  end

  if self.player.y >= WINDOW_HEIGHT - self.player.height - self.cameraScroll then
    gStateMachine:change(
      "gameover",
      {
        score = self.score
      }
    )
  end

  self.player:update(dt)

  if love.keyboard.waspressed("escape") then
    gStateMachine:change(
      "start",
      {
        player = self.player,
        cameraScroll = self.cameraScroll,
        score = self.score
      }
    )
  end
end

function PlayState:render()
  love.graphics.translate(0, self.cameraScroll)

  love.graphics.setColor(1, 1, 1, 1)
  for k, platform in pairs(self.platforms) do
    platform:render()
  end

  self.player:render()

  love.graphics.translate(0, -self.cameraScroll)

  showScore(self.score)
end
