PauseState = BaseState:create()

function PauseState:enter(params)
  self.score = params.score
  self.hiScore = params.hiScore
  self.lives = params.lives

  self.player = params.player
  self.projectiles = params.projectiles
  self.numberAsteroids = params.numberAsteroids
  self.asteroids = params.asteroids
end

function PauseState:update(dt)
  if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
    gStateMachine:change(
      "play",
      {
        score = self.score,
        hiScore = self.hiScore,
        lives = self.lives,
        player = self.player,
        projectiles = self.projectiles,
        numberAsteroids = self.numberAsteroids,
        asteroids = self.asteroids
      }
    )
  end
end

function PauseState:render()
  showStats(self.score, self.hiScore, self.lives)

  for k, asteroid in pairs(self.asteroids) do
    asteroid:render()
  end

  for k, projectile in pairs(self.projectiles) do
    projectile:render()
  end

  love.graphics.setColor(gColors["foreground"]["r"], gColors["foreground"]["g"], gColors["foreground"]["b"])
  love.graphics.printf(string.upper("Pause"), 0, WINDOW_HEIGHT / 2 - 8, WINDOW_WIDTH, "center")
end
