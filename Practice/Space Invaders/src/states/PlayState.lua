PlayState = BaseState:new()

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
      local changesDirection = self.invaders:update()
      if changesDirection then
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

  self.collisions:update(dt)
  self.player:update(dt)
end

function PlayState:render()
  self.collisions:render()
  self.invaders:render()
  self.player:render()
end
