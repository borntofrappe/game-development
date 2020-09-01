PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.interactables = {}
  self.x = WINDOW_WIDTH / 2 - INTERACTABLE_WIDTH / 2
  self.y = WINDOW_HEIGHT - 60
  self.y0 = 0
  self.cameraScroll = 0

  for i = 1, 10 do
    self.interactables[i] = Interactable(self.x + math.random(INTERACTABLE_GAP_X * -1, INTERACTABLE_GAP_X), self.y)
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

        table.insert(
          self.interactables,
          Interactable(self.x + math.random(INTERACTABLE_GAP_X * -1, INTERACTABLE_GAP_X), self.y)
        )
        self.y = self.y - INTERACTABLE_GAP_Y
      end
    end
  end

  if self.player.dy > 0 then
    for k, interactable in pairs(self.interactables) do
      if testAABB(self.player, interactable) then
        self.player.y = interactable.y - self.player.height
        if interactable.type == 3 then
          self.player:bounce()
          table.remove(self.interactables, k)
        elseif interactable.type == 5 then
          table.remove(self.interactables, k)
        elseif interactable.type == 6 then
          self.player:bounce(1.5)
        elseif interactable.type == 7 or (interactable.type == 8 and interactable.variety == 3) then
          gStateMachine:change(
            "gameover",
            {
              score = self.score
            }
          )
        else
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
