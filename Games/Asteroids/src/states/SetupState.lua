SetupState = BaseState:create()

function SetupState:enter(params)
  self.timer = 0
  self.interval = 0.15
  self.iterations = 10
  self.alpha = 0

  self.score = params.score or 0
  self.lives = params.lives or 3

  self.player = params.player or Player:create()
  self.projectiles = params.projectiles or {}
  self.numberAsteroids = params.numberAsteroids or params.difficulty * 2
  self.asteroids = params.asteroids or self:createLevel()

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

    self.player:update(dt)
  else
    self.player.alpha = 1
    gStateMachine:change(
      "play",
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
end

function SetupState:render()
  showRecord()
  if self.alpha == 1 then
    showStats(self.score, self.lives)
  end

  for k, asteroid in pairs(self.asteroids) do
    asteroid:render()
  end

  self.player:render()
end

function SetupState:createLevel()
  local asteroids = {}
  for i = 1, self.numberAsteroids do
    table.insert(asteroids, Asteroid:create())
  end
  return asteroids
end
