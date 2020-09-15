VictoryState = BaseState:create()

function VictoryState:enter(params)
  self.timeout = TIMEOUT_VICTORY

  self.score = params.score
  self.scoreLives = params.scoreLives
  self.lives = params.lives
  self.player = params.player
  self.numberAsteroids = params.numberAsteroids

  self.hasRecord = params.hasRecord

  self.enemy = params.enemy or nil

  gSounds["victory"]:play()
end

function VictoryState:update(dt)
  if self.timeout > 0 then
    self.timeout = self.timeout - dt

    self.player:update(dt)
  else
    gStateMachine:change(
      "play",
      {
        score = self.score,
        scoreLives = self.scoreLives,
        lives = self.lives,
        player = self.player,
        numberAsteroids = self.numberAsteroids + 1,
        hasRecord = self.hasRecord,
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
