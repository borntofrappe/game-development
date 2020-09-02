PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.x = WINDOW_WIDTH / 2 - INTERACTABLE_WIDTH / 2
  self.y = WINDOW_HEIGHT - 60
  self.cameraScroll = 0

  self.previous = 1
  self.interactables = {}
  for i = 1, 10 do
    self.interactables[i] = Interactable(self.x + math.random(INTERACTABLE_GAP_X * -1, INTERACTABLE_GAP_X), self.y, 1)
    self.y = self.y - INTERACTABLE_GAP_Y
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

    for k, interactable in pairs(self.interactables) do
      if self.cameraScroll + interactable.y > WINDOW_HEIGHT then
        table.remove(self.interactables, k)

        local isSafe = false
        for j, type in pairs(INTERACTABLE_SAFE) do
          if self.previous == type then
            isSafe = true
            break
          end
        end

        local type =
          isSafe and INTERACTABLE_TYPES[math.random(#INTERACTABLE_TYPES)] or
          INTERACTABLE_SAFE[math.random(#INTERACTABLE_SAFE)]
        self.previous = type

        table.insert(
          self.interactables,
          Interactable(self.x + math.random(INTERACTABLE_GAP_X * -1, INTERACTABLE_GAP_X), self.y, type)
        )
        self.y = self.y - INTERACTABLE_GAP_Y
      end
    end
  end

  if self.player.dy > 0 then
    for k, interactable in pairs(self.interactables) do
      if testAABB(self.player, interactable) then
        if interactable.type == 3 then
          gSounds["destroy"]:play()
          interactable.isAnimated = true
          self.player.y = interactable.y - self.player.height
          self.player:bounce()
        elseif interactable.type == 5 then
          interactable.isAnimated = true
        elseif interactable.type == 6 then
          gSounds["jump"]:play()
          interactable.isAnimated = true
          self.player.y = interactable.y - self.player.height
          self.player:bounce(2)
        elseif interactable.type == 7 then
          gSounds["hurt"]:play()
          self:hurt()
        elseif interactable.type == 8 then
          if interactable.variety == 3 then
            gSounds["hurt"]:play()
            self:hurt()
          end
        else
          gSounds["bounce"]:play()
          self.player.y = interactable.y - self.player.height
          self.player:bounce()
        end
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

  for k, interactable in pairs(self.interactables) do
    interactable:update(dt)
    if not interactable.inPlay then
      table.remove(self.interactables, k)
    end
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
  for k, interactable in pairs(self.interactables) do
    interactable:render()
  end

  self.player:render()

  love.graphics.translate(0, -self.cameraScroll)

  showScore(self.score)
end

function PlayState:hurt()
  gStateMachine:change(
    "hurt",
    {
      cameraScroll = self.cameraScroll,
      score = self.score,
      interactables = self.interactables,
      player = self.player
    }
  )
end
