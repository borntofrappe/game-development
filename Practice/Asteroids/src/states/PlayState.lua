PlayState = Class {__includes = BaseState}

function PlayState:enter(params)
  self.player = params.player
  self.asteroids = params.asteroids
end

function PlayState:update(dt)
  if love.keyboard.wasPressed("escape") then
    gStateMachine:change("title")
  end

  if love.keyboard.wasPressed("space") then
    self.player:shoot()
  end

  for k, asteroid in pairs(self.asteroids) do
    asteroid:update(dt)

    if self.player:collides(asteroid) then
      self:destroy(asteroid)
      table.remove(self.asteroids, k)

      self.player:reset()
      gStateMachine:change(
        "spawn",
        {
          player = self.player,
          asteroids = self.asteroids
        }
      )
    end

    for j, projectile in pairs(self.player.projectiles) do
      if projectile:collides(asteroid) then
        projectile.removed = true
        self:destroy(asteroid)
        table.remove(self.asteroids, k)
      end
    end
  end

  self.player:update(dt)
end

function PlayState:destroy(asteroid)
  local type = asteroid.type
  if type > 1 then
    local x = asteroid.x
    local y = asteroid.y
    local speed = asteroid.speed
    table.insert(self.asteroids, Asteroid(x, y, type - 1, speed))
    table.insert(self.asteroids, Asteroid(x, y, type - 1, speed))
  end
end

function PlayState:render()
  for k, asteroid in pairs(self.asteroids) do
    asteroid:render()
  end

  self.player:render()
end
