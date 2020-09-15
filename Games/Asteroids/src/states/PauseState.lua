PauseState = BaseState:create()

function PauseState:enter(params)
  self.score = params.score
  self.scoreLives = params.scoreLives
  self.lives = params.lives

  self.player = params.player
  self.projectiles = params.projectiles
  self.numberAsteroids = params.numberAsteroids
  self.asteroids = params.asteroids

  self.hasRecord = params.hasRecord
end

function PauseState:update(dt)
  if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
    gStateMachine:change(
      "play",
      {
        score = self.score,
        scoreLives = self.scoreLives,
        lives = self.lives,
        player = self.player,
        projectiles = self.projectiles,
        numberAsteroids = self.numberAsteroids,
        asteroids = self.asteroids,
        hasRecord = self.hasRecord
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

  self.player:render()
end
