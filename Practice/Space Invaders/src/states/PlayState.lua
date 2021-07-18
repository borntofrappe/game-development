PlayState = BaseState:new()

local COUNTDOWN_DURATION = 5

function PlayState:enter(params)
  self.interval =
    params and params.interval or
    {
      ["min"] = 0.4,
      ["max"] = 0.9,
      ["change"] = 0.1,
      ["duration"] = 0.9,
      ["label"] = "update"
    }

  self.gameoverCountdown = {
    ["duration"] = COUNTDOWN_DURATION
  }

  self.collisions = params and params.collisions or Collisions:new()
  self.invaders = params and params.invaders or Invaders:new(self.interval.duration / (INVADER_TYPES + 1))
  self.player = params and params.player or Player:new()

  if not params then
    self:setupInterval()
  end
end

function PlayState:setupInterval()
  Timer:every(
    self.interval.duration,
    function()
      local changeDirection, collideWithPlayer = self.invaders:update(self.player)

      if collideWithPlayer then
        Timer:remove(self.interval.label)
        Timer:after(
          self.gameoverCountdown.duration,
          function()
            gStateMachine:change("gameover")
          end
        )

        local collision =
          CollisionPlayer:new(
          self.player.x + self.player.width / 2 - COLLISION_PLAYER_WIDTH / 2,
          self.player.y + self.player.height - COLLISION_PLAYER_HEIGHT
        )
        table.insert(self.collisions.collisions, collision)
        self.player.inPlay = false
      elseif changeDirection then
        Timer:remove(self.interval.label)
        self.interval.duration = math.max(self.interval.min, self.interval.duration - self.interval.change)
        self.invaders.delayMultiplier = self.interval.duration / (INVADER_TYPES + 1)
        self:setupInterval()
      end
    end,
    false,
    self.interval.label
  )
end

function PlayState:update(dt)
  Timer:update(dt)

  if love.keyboard.waspressed("escape") then
    Timer:remove(self.interval.label)
    gStateMachine:change("start")
  end

  if love.keyboard.waspressed("return") then
    -- Timer:remove(self.interval.label)
    gStateMachine:change(
      "pause",
      {
        ["collisions"] = self.collisions,
        ["invaders"] = self.invaders,
        ["player"] = self.player,
        ["interval"] = self.interval
      }
    )
  end

  self.collisions:update(dt)

  if self.player.inPlay then
    for k, projectile in pairs(self.player.projectiles) do
      local hasCollided = false
      for j, invader in pairs(self.invaders.invaders) do
        if
          projectile.x > invader.x and projectile.x < invader.x + invader.width and projectile.y > invader.y and
            projectile.y < invader.y + invader.height
         then
          hasCollided = true

          local collision = CollisionInvader:new(invader.x + invader.width / 2, invader.y + invader.height / 2)
          table.insert(self.collisions.collisions, collision)

          table.remove(self.invaders.invaders, j)
          break
        end
      end
      if hasCollided then
        table.remove(self.player.projectiles, k)
      end
    end
    self.player:update(dt)
  end
end

function PlayState:render()
  self.collisions:render()
  self.invaders:render()
  self.player:render()
end
