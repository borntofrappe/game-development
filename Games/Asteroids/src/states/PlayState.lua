PlayState = BaseState:create()

function PlayState:enter(params)
  self.interval = INTERVAL_NOISE
  self.timer = 0

  self.score = params.score
  self.scoreLives = params.scoreLives
  self.lives = params.lives
  self.numberAsteroids = params.numberAsteroids
  self.hasRecord = params.hasRecord
  self.hasEnemy = params.hasEnemy or false

  self.player = params.player
  self.projectiles = params.projectiles or {}
  self.asteroids = params.asteroids or createLevel(self.numberAsteroids)
  self.enemy = params.enemy or nil
end

function PlayState:update(dt)
  if
    self.numberAsteroids >= ENEMY_ASTEROID_THRESHOLD and not self.hasEnemy and not self.enemy and
      math.random(ENEMY_ODDS) == 1
   then
    self.hasEnemy = true
    self.enemy = Enemy:create()
    gSounds["enemy"]:play()
  end

  if self.enemy and not self.enemy.inPlay then
    self.enemy = nil
  end

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
        scoreLives = self.scoreLives,
        lives = self.lives,
        numberAsteroids = self.numberAsteroids,
        hasRecord = self.hasRecord,
        hasEnemy = self.hasEnemy,
        player = self.player,
        projectiles = self.projectiles,
        asteroids = self.asteroids,
        enemy = self.enemy
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
        scoreLives = self.scoreLives,
        lives = self.lives,
        numberAsteroids = self.numberAsteroids,
        hasRecord = self.hasRecord,
        hasEnemy = self.hasEnemy,
        player = self.player,
        projectiles = self.projectiles,
        asteroids = self.asteroids,
        enemy = self.enem
      }
    )
  end

  for k, asteroid in pairs(self.asteroids) do
    asteroid:update(dt)
    if testAABB(self.player, asteroid) then
      gSounds["hurt"]:play()
      asteroid.inPlay = false

      self:scorePoints(gPoints[asteroid.size])
      self:hit()
    end

    if not asteroid.inPlay then
      gSounds["destroy-" .. asteroid.size]:play()
      if asteroid.size > 1 then
        table.insert(self.asteroids, Asteroid:create(asteroid.x, asteroid.y, asteroid.size - 1))
        table.insert(self.asteroids, Asteroid:create(asteroid.x, asteroid.y, asteroid.size - 1))
      end
      table.remove(self.asteroids, k)

      if hasWon(self.asteroids) then
        gStateMachine:change(
          "victory",
          {
            score = self.score,
            scoreLives = self.scoreLives,
            lives = self.lives,
            numberAsteroids = self.numberAsteroids,
            hasRecord = self.hasRecord,
            player = self.player,
            projectiles = self.projectiles,
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

        self:scorePoints(gPoints[asteroid.size])
      end

      if self.enemy and self.enemy.inPlay and testAABB(projectile, self.enemy) then
        gSounds["destroy-3"]:play()
        projectile.inPlay = false
        self.enemy.inPlay = false

        self:scorePoints(ENEMY_POINTS)
      end
    end
    if not projectile.inPlay then
      table.remove(self.projectiles, k)
    end
  end

  if self.enemy then
    self.enemy:update(dt)

    if self.enemy.inPlay and testAABB(self.player, self.enemy) then
      gSounds["destroy-3"]:play()
      self.enemy.inPlay = false

      gSounds["hurt"]:play()

      self:scorePoints(ENEMY_POINTS)
      self:hit()
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

  if self.enemy then
    self.enemy:render()
  end

  self.player:render()
end

function PlayState:scorePoints(points)
  self.score = self.score + points
  self.scoreLives = self.scoreLives + points

  if self.scoreLives > LIVES_THRESHOLD_EXTRA then
    self.lives = self.lives + 1
    gSounds["life"]:play()

    self.scoreLives = self.scoreLives % LIVES_THRESHOLD_EXTRA
  end

  if self.score > gRecord then
    if not self.hasRecord then
      self.hasRecord = true
      gSounds["record"]:play()
    end
    gRecord = self.score
  end
end

function PlayState:hit()
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
        scoreLives = self.scoreLives,
        lives = self.lives,
        numberAsteroids = self.numberAsteroids,
        hasRecord = self.hasRecord,
        hasEnemy = self.hasEnemy,
        asteroids = self.asteroids,
        enemy = self.enemy
      }
    )
  end
end
