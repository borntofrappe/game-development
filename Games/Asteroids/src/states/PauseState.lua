PauseState = BaseState:create()

function PauseState:enter(params)
  self.score = params.score
  self.scoreLives = params.scoreLives
  self.lives = params.lives
  self.numberAsteroids = params.numberAsteroids
  self.hasRecord = params.hasRecord
  self.hasEnemy = params.hasEnemy

  self.player = params.player
  self.projectiles = params.projectiles
  self.asteroids = params.asteroids
  self.enemy = params.enemy
end

function PauseState:update(dt)
  if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
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

function PauseState:render()
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
