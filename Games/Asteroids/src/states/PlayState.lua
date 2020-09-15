PlayState = BaseState:create()

function PlayState:enter(params)
  self.interval = INTERVAL_NOISE
  self.timer = 0

  self.score = params.score
  self.lives = params.lives

  self.player = params.player
  self.projectiles = params.projectiles or {}
  self.numberAsteroids = params.numberAsteroids
  self.asteroids = params.asteroids or createLevel(self.numberAsteroids)
end

function PlayState:update(dt)
  self.timer = self.timer + dt
  if self.timer >= self.interval then
    self.timer = self.timer % self.interval
    gSounds["background-noise"]:play()
  end

  if love.keyboard.wasPressed("escape") then
    gStateMachine:change("title")
  end

  if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
    gStateMachine:change(
      "pause",
      {
        score = self.score,
        lives = self.lives,
        player = self.player,
        projectiles = self.projectiles,
        numberAsteroids = self.numberAsteroids,
        asteroids = self.asteroids
      }
    )
  end

  if love.keyboard.wasPressed("space") then
    local projectile = Projectile:create(self.player.x, self.player.y, self.player.angle)
    table.insert(self.projectiles, projectile)

    gSounds["shoot"]:stop()
    gSounds["shoot"]:play()
  end

  if love.keyboard.wasPressed("down") or love.keyboard.wasPressed("s") then
    gStateMachine:change(
      "teleport",
      {
        score = self.score,
        lives = self.lives,
        player = self.player,
        projectiles = self.projectiles,
        numberAsteroids = self.numberAsteroids,
        asteroids = self.asteroids
      }
    )
  end

  for k, asteroid in pairs(self.asteroids) do
    asteroid:update(dt)
    if testAABB(self.player, asteroid) then
      gSounds["hurt"]:play()
      asteroid.inPlay = false
      self.lives = self.lives - 1

      if self.lives == 0 then
        gStateMachine:change(
          "gameover",
          {
            score = self.score,
            asteroids = self.asteroids
          }
        )
      else
        gStateMachine:change(
          "setup",
          {
            score = self.score,
            lives = self.lives,
            projectiles = self.projectiles,
            numberAsteroids = self.numberAsteroids,
            asteroids = self.asteroids
          }
        )
      end
    end
    if not asteroid.inPlay then
      gSounds["destroy-" .. asteroid.size]:play()
      if asteroid.size > 1 then
        table.insert(self.asteroids, Asteroid:create(asteroid.x, asteroid.y, asteroid.size - 1))
        table.insert(self.asteroids, Asteroid:create(asteroid.x, asteroid.y, asteroid.size - 1))
      end
      self.score = self.score + gPoints[asteroid.size]
      if self.score > gRecord then
        gRecord = self.score
      end
      table.remove(self.asteroids, k)

      if hasWon(self.asteroids) then
        gStateMachine:change(
          "victory",
          {
            score = self.score,
            lives = self.lives,
            player = self.player,
            numberAsteroids = self.numberAsteroids
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
      end
    end
    if not projectile.inPlay then
      table.remove(self.projectiles, k)
    end
  end

  self.player:update(dt)
end

function PlayState:render()
  showRecord()
  showStats(self.score, self.lives)

  for k, asteroid in pairs(self.asteroids) do
    asteroid:render()
  end

  for k, projectile in pairs(self.projectiles) do
    projectile:render()
  end
  self.player:render()
end
