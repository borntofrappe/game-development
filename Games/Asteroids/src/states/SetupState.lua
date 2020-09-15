SetupState = BaseState:create()

function SetupState:enter(params)
  self.timer = 0
  self.interval = INTERVAL_SETUP
  self.iterations = INTERVAL_SETUP_ITERATIONS
  self.alpha = 0

  self.score = params.score or 0
  self.scoreLives = params.scoreLives or self.score
  self.lives = params.lives or LIVES
  self.numberAsteroids = params.numberAsteroids or params.difficulty * DIFFICULTY_MULTIPLIER
  self.hasRecord = params.hasRecord or false
  self.hasEnemy = params.hasEnemy or false

  self.player = params.player or Player:create()
  self.projectiles = params.projectiles or {}
  self.asteroids = params.asteroids or createLevel(self.numberAsteroids)
  self.enemy = params.enemy or nil

  gSounds["setup"]:stop()
  gSounds["setup"]:play()
end

function SetupState:update(dt)
  if self.iterations > 0 then
    self.timer = self.timer + dt
    if self.timer >= self.interval then
      self.timer = self.timer % self.interval
      self.iterations = self.iterations - 1

      self.alpha = self.alpha == 1 and 0 or 1
      self.player.alpha = self.alpha
    end

    for k, asteroid in pairs(self.asteroids) do
      asteroid:update(dt)
    end

    if self.enemy then
      self.enemy:update(dt)
    end

    self.player:update(dt)
  else
    self.player.alpha = 1
    gStateMachine:change(
      "play",
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
end

function SetupState:render()
  showRecord()

  if self.alpha == 1 then
    showStats(self.score, self.lives)
  end

  for k, asteroid in pairs(self.asteroids) do
    asteroid:render()
  end

  if self.enemy then
    self.enemy:render()
  end

  self.player:render()
end
