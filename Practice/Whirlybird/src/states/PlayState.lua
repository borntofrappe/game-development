PlayState = BaseState:new()

local FALLING_DELAY = 1.5

function PlayState:enter(params)
  self.player = params and params.player or Player:new(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
  if not params then
    self.player:hop()
  end

  self.interactables = Interactables:new()

  self.scrollY = 0
  self.timer = 0
end

function PlayState:update(dt)
  if love.keyboard.waspressed("escape") then
    gStateMachine:change(
      "start",
      {
        ["player"] = self.player
      }
    )
  end

  self.player:update(dt)

  if self.player.dy > 0 then
    for i, interactable in ipairs(self.interactables.interactables) do
      if self.player:isOnTop(interactable) then
        self.player.y = interactable.y - self.player.height
        self.player:bounce()
        break
      end
    end
  end

  self.interactables:update(dt, self.scrollY)

  if self.player.dy < 0 and self.player.y < UPPER_THRESHOLD - self.scrollY then
    self.scrollY = UPPER_THRESHOLD - self.player.y
  end

  if self.player.y > LOWER_THRESHOLD - self.scrollY then
    self.scrollY = LOWER_THRESHOLD - self.player.y

    self.timer = self.timer + dt
    if self.timer > FALLING_DELAY then
      gStateMachine:change(
        "falling",
        {
          ["player"] = self.player,
          ["scrollY"] = self.scrollY
        }
      )
    end
  end
end

function PlayState:render()
  love.graphics.translate(0, math.floor(self.scrollY))

  self.interactables:render()

  self.player:render()
end
