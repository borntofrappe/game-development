PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.x = WINDOW_WIDTH / 2 - INTERACTABLE_WIDTH / 2
  self.y = WINDOW_HEIGHT - 60
  self.cameraScroll = 0

  self.previous = 1
  self.interactables = {}
  for i = 1, math.ceil(WINDOW_HEIGHT / INTERACTABLE_GAP_Y) * 2 do
    self.interactables[i] = Interactable(self.x + math.random(INTERACTABLE_GAP_X * -1, INTERACTABLE_GAP_X), self.y, 1)
    self.y = self.y - INTERACTABLE_GAP_Y
  end

  self.timer = 0
  self.delay = 0.5
end

function PlayState:enter(params)
  self.player = params.player or Player(WINDOW_WIDTH / 2 - PLAYER_WIDTH / 2, WINDOW_HEIGHT / 2 - PLAYER_HEIGHT / 2)
  self.score = params.score or 0
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

  for k, interactable in pairs(self.interactables) do
    interactable:update(dt)
    if not interactable.inPlay then
      table.remove(self.interactables, k)
    end
  end

  self.player:update(dt)

  if self.player.dy < 5 and self.player.y < WINDOW_HEIGHT / 3 - self.cameraScroll then
    self.score = self.score + 5
    self.cameraScroll = WINDOW_HEIGHT / 3 - self.player.y

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
    self.player:change()
    for k, interactable in pairs(self.interactables) do
      if testAABB(self.player, interactable) then
        if interactable.hat then
          interactable.hat = nil
          self.player:change("flying")
          gSounds["fly"]:play()
          self.player.y = interactable.y - self.player.height
          self.player:bounce(3)
        elseif interactable.type == 3 then
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

  if self.player.y >= WINDOW_HEIGHT - self.player.height - self.cameraScroll - self.interactables[1].height then
    self.cameraScroll = (WINDOW_HEIGHT - self.player.y - self.player.height - self.interactables[1].height)
    self.timer = self.timer + dt
    if self.timer >= self.delay then
      self.player:change("falling")
      gStateMachine:change(
        "falling",
        {
          cameraScroll = self.cameraScroll,
          score = self.score,
          interactables = self.interactables,
          player = self.player
        }
      )
    end
  end

  if love.keyboard.waspressed("escape") then
    self.player:change()
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
  love.graphics.translate(0, math.floor(self.cameraScroll))

  love.graphics.setColor(1, 1, 1, 1)
  for k, interactable in pairs(self.interactables) do
    interactable:render()
  end

  self.player:render()

  love.graphics.translate(0, math.floor(self.cameraScroll) * -1)

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
