TeleportState = BaseState:create()

function TeleportState:enter(params)
  self.timeout = TIMEOUT_TELEPORT

  self.score = params.score
  self.scoreLives = params.scoreLives
  self.lives = params.lives

  self.player = params.player
  self.projectiles = params.projectiles
  self.numberAsteroids = params.numberAsteroids
  self.asteroids = params.asteroids

  self.hasRecord = params.hasRecord

  self.enemy = params.enemy or nil

  gSounds["teleport"]:stop()
  gSounds["teleport"]:play()
end

function TeleportState:update(dt)
  if self.timeout >= 0 then
    self.timeout = self.timeout - dt

    for k, asteroid in pairs(self.asteroids) do
      asteroid:update(dt)
      if not asteroid.inPlay then
        gSounds["destroy-" .. asteroid.size]:play()
        if asteroid.size > 1 then
          table.insert(self.asteroids, Asteroid:create(asteroid.x, asteroid.y, asteroid.size - 1))
          table.insert(self.asteroids, Asteroid:create(asteroid.x, asteroid.y, asteroid.size - 1))
        end
        table.remove(self.asteroids, k)

        if hasWon(self.asteroids) then
          self:reposition()
          gStateMachine:change(
            "victory",
            {
              score = self.score,
              scoreLives = self.scoreLives,
              lives = self.lives,
              player = self.player,
              numberAsteroids = self.numberAsteroids,
              hasRecord = self.hasRecord,
              enemy = self.enemy
            }
          )
        end
      end
    end

    for k, projectile in pairs(self.projectiles) do
      projectile:update(dt)
      for j, asteroid in pairs(self.asteroids) do
        if testAABB(projectile, asteroid) then
          projectile.inPlay = false
          asteroid.inPlay = false
          self.score = self.score + gPoints[asteroid.size]
          self.scoreLives = self.scoreLives + gPoints[asteroid.size]

          if self.scoreLives > LIVES_THRESHOLD then
            self.lives = self.lives + 1
            gSounds["life"]:play()

            self.scoreLives = self.scoreLives % LIVES_THRESHOLD
          end

          if self.score > gRecord then
            if not self.hasRecord then
              self.hasRecord = true
              gSounds["record"]:play()
            end
            gRecord = self.score
          end
        end
      end
      if not projectile.inPlay then
        table.remove(self.projectiles, k)
      end
    end
  else
    self:reposition()

    gStateMachine:change(
      "play",
      {
        score = self.score,
        lives = self.lives,
        player = self.player,
        projectiles = self.projectiles,
        numberAsteroids = self.numberAsteroids,
        asteroids = self.asteroids,
        hasRecord = self.hasRecord,
        enemy = self.enemy
      }
    )
  end
end

function TeleportState:render()
  showRecord()
  showStats(self.score, self.lives)

  for k, asteroid in pairs(self.asteroids) do
    asteroid:render()
  end

  for k, projectile in pairs(self.projectiles) do
    projectile:render()
  end

  if self.enemy then
    self.enemy:render()
  end
end

function TeleportState:reposition()
  local isSearching = true
  local x
  local y
  while (isSearching) do
    x = math.random(0, WINDOW_WIDTH)
    y = math.random(0, WINDOW_HEIGHT)
    local player = Player:create(x, y)

    local isValid = true
    for k, asteroid in pairs(self.asteroids) do
      if testAABB(player, asteroid) then
        isValid = false
        break
      end
    end
    if isValid then
      isSearching = false
    end
  end

  self.player.x = x
  self.player.y = y
  self.player.dx = 0
  self.player.dy = 0
end
