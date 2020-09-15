VictoryState = BaseState:create()

function VictoryState:enter(params)
  self.timeout = TIMEOUT_VICTORY

  self.score = params.score
  self.scoreLives = params.scoreLives
  self.lives = params.lives
  self.numberAsteroids = params.numberAsteroids
  self.hasRecord = params.hasRecord

  self.player = params.player
  self.projectiles = params.projectiles
  self.enemy = params.enemy or nil

  gSounds["victory"]:play()
end

function VictoryState:update(dt)
  if self.timeout > 0 then
    self.timeout = self.timeout - dt

    for k, projectile in pairs(self.projectiles) do
      projectile:update(dt)
      if not projectile.inPlay then
        table.remove(self.projectiles, k)
      end
    end

    if self.enemy then
      self.enemy:update(dt)
    end

    if self.enemy and not self.enemy.inPlay then
      self.enemy = nil
    end

    self.player:update(dt)
  else
    gStateMachine:change(
      "play",
      {
        score = self.score,
        scoreLives = self.scoreLives,
        lives = self.lives,
        numberAsteroids = self.numberAsteroids + 1,
        hasRecord = self.hasRecord,
        player = self.player,
        projectiles = self.projectiles,
        enemy = self.enemy
      }
    )
  end
end

function VictoryState:render()
  showRecord()
  showStats(self.score, self.lives)

  if self.enemy then
    self.enemy:render()
  end

  self.player:render()
end
