PlayState = BaseState:new()

local COLLISION_PLAYER_DELAY = 3

function PlayState:enter(params)
  self.data = params.data
  self.interval = params.interval
  self.invaders = params.invaders

  self.collisions = params.collisions or Collisions:new()
  self.player = params.player or Player:new()

  self.delay = {
    ["duration"] = COLLISION_PLAYER_DELAY
  }

  if params.setupInterval then
    self:setupInterval()
  end
end

function PlayState:setupInterval()
  Timer:every(
    self.interval.duration,
    function()
      local changeDirection, collideWithPlayer = self.invaders:updateInterval(self.player)

      gSounds["update-interval"]:stop()
      gSounds["update-interval"]:play()

      if collideWithPlayer then
        self:gameover()
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
    Timer:reset()
    gStateMachine:change("title")
  end

  if love.keyboard.waspressed("return") then
    if self.player.inPlay then
      gSounds["pause-state"]:play()

      gStateMachine:change(
        "pause",
        {
          ["data"] = self.data,
          ["interval"] = self.interval,
          ["invaders"] = self.invaders,
          ["collisions"] = self.collisions,
          ["player"] = self.player
        }
      )
    end
  end

  self.collisions:update(dt)

  if self.player.inPlay then
    self.invaders:update(dt)

    for k, projectile in pairs(self.player.projectiles) do
      local hasCollided = false
      for j, invader in pairs(self.invaders.invaders) do
        if
          projectile.x > invader.x and projectile.x < invader.x + invader.width and projectile.y > invader.y and
            projectile.y < invader.y + invader.height
         then
          hasCollided = true

          local collision =
            CollisionInvader:new(
            invader.x + invader.width / 2 - COLLISION_INVADER_WIDTH / 2,
            invader.y + invader.height / 2 - COLLISION_INVADER_HEIGHT / 2
          )
          table.insert(self.collisions.collisions, collision)

          self.data.score = self.data.score + invader.points
          table.remove(self.invaders.invaders, j)
          break
        end
      end

      local bonusInvader = self.invaders.bonusInvader

      if
        bonusInvader and projectile.x > bonusInvader.x and projectile.x < bonusInvader.x + bonusInvader.width and
          projectile.y > bonusInvader.y and
          projectile.y < bonusInvader.y + bonusInvader.height
       then
        hasCollided = true

        local collision =
          CollisionInvader:new(
          bonusInvader.x + bonusInvader.width / 2 - COLLISION_INVADER_WIDTH / 2,
          bonusInvader.y + bonusInvader.height / 2 - COLLISION_INVADER_HEIGHT / 2
        )
        table.insert(self.collisions.collisions, collision)

        self.data.score = self.data.score + bonusInvader.points

        self.invaders.bonusInvader = nil
      end

      if hasCollided then
        gSounds["collision-invader"]:play()

        table.remove(self.player.projectiles, k)

        if #self.invaders.invaders == 0 and not self.invaders.bonusInvader then
          Timer:reset()
          gSounds["round-cleared"]:play()
          Timer:after(
            self.delay.duration,
            function()
              self.data.round = self.data.round + 1

              gSounds["serve-state"]:play()
              gStateMachine:change(
                "serve",
                {
                  ["data"] = self.data
                }
              )
            end
          )
        end
      end

      if not projectile.inPlay then
        local x = projectile.x + projectile.width / 2 - COLLISION_PROJECTILE_WIDTH / 2
        local y = 0

        local collision = CollisionProjectile:new(x, y)
        table.insert(self.collisions.collisions, collision)

        table.remove(self.player.projectiles, k)
      end
    end

    for k, projectile in pairs(self.invaders.projectiles) do
      projectile:update(dt)
      if
        projectile.x > self.player.x and projectile.x < self.player.x + self.player.width and
          projectile.y > self.player.y and
          projectile.y < self.player.y + self.player.height
       then
        table.remove(self.invaders.projectiles, k)
        self:gameover()
        break
      end

      if not projectile.inPlay then
        local x = projectile.x + projectile.width / 2 - COLLISION_PROJECTILE_WIDTH / 2
        local y = WINDOW_HEIGHT - COLLISION_PROJECTILE_HEIGHT

        local collision = CollisionProjectile:new(x, y, 2)
        table.insert(self.collisions.collisions, collision)

        table.remove(self.invaders.projectiles, k)
      end
    end

    self.player:update(dt)
  end
end

function PlayState:gameover()
  gSounds["update-interval"]:stop()
  gSounds["collision-player"]:play()

  self.player.inPlay = false

  local collision =
    CollisionPlayer:new(
    self.player.x + self.player.width / 2 - COLLISION_PLAYER_WIDTH / 2,
    self.player.y + self.player.height - COLLISION_PLAYER_HEIGHT
  )

  table.insert(self.collisions.collisions, collision)

  if self.data.lives == 1 then
    Timer:reset()

    Timer:after(
      self.delay.duration,
      function()
        if self.data.score >= gHighScore then
          gSounds["high-score-state"]:play()
          gStateMachine:change(
            "high-score",
            {
              ["highScore"] = self.data.score
            }
          )
        else
          gStateMachine:change("gameover")
        end
      end
    )
  else
    Timer:remove(self.interval.label)

    Timer:after(
      self.delay.duration,
      function()
        self.data.lives = self.data.lives - 1
        gStateMachine:change(
          "serve",
          {
            ["interval"] = self.interval,
            ["data"] = self.data,
            ["invaders"] = self.invaders
          }
        )
      end
    )
  end
end

function PlayState:render()
  self.data:render()

  self.collisions:render()
  self.invaders:render()
  self.player:render()
end
