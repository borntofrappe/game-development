VictoryState = BaseState:create()

function VictoryState:enter(params)
  self.timeout = TIMEOUT_VICTORY

  self.score = params.score
  self.lives = params.lives
  self.player = params.player
  self.numberAsteroids = params.numberAsteroids

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
        lives = self.lives,
        player = self.player,
        numberAsteroids = self.numberAsteroids + 1
      }
    )
  end
end

function VictoryState:render()
  showRecord()
  showStats(self.score, self.lives)

  self.player:render()
end
