PlayState = BaseState:new()

function PlayState:enter()
  self.interval = {
    ["min"] = 0.4,
    ["max"] = 0.9,
    ["change"] = 0.1,
    ["label"] = "update"
  }

  self.interval.duration = self.interval.max

  self.player = Player:new()
  self.invaders = Invaders:new(self.interval.duration / (INVADER_TYPES + 1))
  self.collisions = Collisions:new()

  self:setupInterval()
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
  if love.keyboard.waspressed("escape") then
    Timer:remove(self.interval.label)
    gStateMachine:change("start")
  end

  Timer:update(dt)

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
