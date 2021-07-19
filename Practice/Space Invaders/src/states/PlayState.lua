PlayState = BaseState:new()

local COLLISION_PLAYER_DELAY = 5

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
      local changeDirection, collideWithPlayer = self.invaders:update(self.player)

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
    Timer:remove(self.interval.label)
    gStateMachine:change("title")
  end

  if love.keyboard.waspressed("return") then
    if self.player.inPlay then
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
      if hasCollided then
        table.remove(self.player.projectiles, k)

        if #self.invaders.invaders == 0 then
          -- victory
          Timer:reset()

          Timer:after(
            self.delay.duration,
            function()
              self.data.round = self.data.round + 1
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
    end

    self.player:update(dt)
  end
end

function PlayState:gameover()
  self.player.inPlay = false

  local collision =
    CollisionPlayer:new(
    self.player.x + self.player.width / 2 - COLLISION_PLAYER_WIDTH / 2,
    self.player.y + self.player.height - COLLISION_PLAYER_HEIGHT
  )

  table.insert(self.collisions.collisions, collision)

  if self.data.lives == 1 then
    Timer:reset()

    -- here you'd check the high score
    Timer:after(
      self.delay.duration,
      function()
        gStateMachine:change("gameover")
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
