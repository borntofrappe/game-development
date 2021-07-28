PlayState = BaseState:new()

local FALLING_DELAY = 0.5

function PlayState:enter(params)
  self.player = params and params.player or Player:new(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)

  if not params then
    gSounds["bounce"]:play()

    self.player:bounce()
  end

  self.interactables = Interactables:new()

  self.scrollY = 0
  self.timer = 0

  self.score = 0
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
    self.player:change("default")
    for i, interactable in ipairs(self.interactables.interactables) do
      if self.player:isOnTop(interactable) then
        self.timer = 0
        local type = interactable.type

        if type == "cloud" then
          interactable.isInteracted = true
        elseif type == "trampoline" then
          gSounds["jump"]:play()

          interactable.isInteracted = true
          self.player.y = interactable.y - self.player.height
          self.player:bounce(2)
        elseif type == "spikes" then
          gSounds["hurt"]:play()

          gStateMachine:change(
            "hurt",
            {
              ["player"] = self.player,
              ["interactables"] = self.interactables,
              ["scrollY"] = self.scrollY,
              ["score"] = self.score
            }
          )
        elseif type == "enemy" then
          if interactable.frame == 2 or interactable.frame == 3 then
            gSounds["hurt"]:play()

            gStateMachine:change(
              "hurt",
              {
                ["player"] = self.player,
                ["interactables"] = self.interactables,
                ["scrollY"] = self.scrollY,
                ["score"] = self.score
              }
            )
          end
        else
          if type == "crumbling" then
            gSounds["destroy"]:play()

            interactable.isInteracted = true
          end
          self.player.y = interactable.y - self.player.height

          if interactable.hat then
            gSounds["fly"]:play()

            interactable.hat = nil
            self.player:change("flying")
            self.player:bounce(4)
          else
            gSounds["bounce"]:play()

            self.player:bounce()
          end
        end
        break
      end
    end
  end

  self.interactables:update(dt, self.scrollY)

  if self.player.dy < 0 and self.player.y < UPPER_THRESHOLD - self.scrollY then
    self.scrollY = UPPER_THRESHOLD - self.player.y
    self.score = self.score + 5
  end

  if self.player.y >= LOWER_THRESHOLD - self.player.height - self.scrollY then
    self.scrollY = LOWER_THRESHOLD - self.player.height - self.player.y

    self.timer = self.timer + dt

    if self.timer >= FALLING_DELAY then
      self.player:change("falling")
      gStateMachine:change(
        "falling",
        {
          ["player"] = self.player,
          ["scrollY"] = self.scrollY,
          ["score"] = self.score
        }
      )
    end
  end
end

function PlayState:render()
  renderScore(self.score)

  love.graphics.translate(0, math.floor(self.scrollY))

  self.interactables:render()

  self.player:render()
end
