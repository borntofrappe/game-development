PlayState = Class {__includes = BaseState}

function PlayState:enter(params)
  self.level = params.level
  self.player = params.player
  self.asteroids = params.asteroids

  -- in case the newly spawn level is already cleared
  if #self.asteroids == 0 then
    gStateMachine:change(
      "victory",
      {
        level = self.level,
        player = self.player
      }
    )
  end
end

function PlayState:update(dt)
  if love.keyboard.wasPressed("escape") then
    gStateMachine:change("title")
  end

  if love.keyboard.wasPressed("space") then
    self.player:shoot()

    gSounds["shoot"]:play()
  end

  if love.keyboard.wasPressed("down") then
    gStateMachine:change(
      "teleport",
      {
        level = self.level,
        player = self.player,
        asteroids = self.asteroids
      }
    )
  end

  for k, asteroid in pairs(self.asteroids) do
    asteroid:update(dt)

    if self.player:collides(asteroid) then
      self:destroy(asteroid)
      table.remove(self.asteroids, k)

      gSounds["hurt"]:play()

      if self.player:destroy() then
        gStateMachine:change(
          "gameover",
          {
            player = self.player,
            asteroids = self.asteroids
          }
        )
      else
        self.player:reset()
        gStateMachine:change(
          "spawn",
          {
            level = self.level,
            player = self.player,
            asteroids = self.asteroids
          }
        )
      end
    end

    for j, projectile in pairs(self.player.projectiles) do
      if projectile:collides(asteroid) then
        projectile.removed = true
        self:destroy(asteroid)
        table.remove(self.asteroids, k)
        if #self.asteroids == 0 then
          gStateMachine:change(
            "victory",
            {
              level = self.level,
              player = self.player
            }
          )
        end
      end
    end
  end

  self.player:update(dt)
end

function PlayState:destroy(asteroid)
  local type = asteroid.type

  gSounds["destroy-" .. type]:stop()
  gSounds["destroy-" .. type]:play()

  self.player:score(asteroid.points)
  if self.player.points > gRecord.points then
    if not gRecord.current then
      gRecord.current = true

      gSounds["record"]:play()
    end
    gRecord.points = self.player.points
  end

  if not asteroid:isDestroyed() then
    local x = asteroid.x
    local y = asteroid.y
    local speed = asteroid.speed
    table.insert(self.asteroids, Asteroid(x, y, type - 1, speed))
    table.insert(self.asteroids, Asteroid(x, y, type - 1, speed))
  end
end

function PlayState:render()
  displayRecord(gRecord.points)
  displayStats(self.player.points, self.player.lives)

  self.player:render()

  for k, asteroid in pairs(self.asteroids) do
    asteroid:render()
  end
end
