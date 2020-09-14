VictoryState = BaseState:create()

function VictoryState:enter(params)
  self.timeout = 3

  self.score = params.score
  self.lives = params.lives
  self.numberAsteroids = params.numberAsteroids
end

function VictoryState:update(dt)
  if self.timeout > 0 then
    self.timeout = self.timeout - dt
  else
    gStateMachine:change(
      "play",
      {
        score = self.score,
        lives = self.lives,
        numberAsteroids = self.numberAsteroids + 1
      }
    )
  end
end

function VictoryState:render()
  showStats(self.score, self.lives)

  love.graphics.setColor(gColors["foreground"]["r"], gColors["foreground"]["g"], gColors["foreground"]["b"])
  love.graphics.printf(string.upper("Level Complete"), 0, WINDOW_HEIGHT / 2 - 8, WINDOW_WIDTH, "center")
end
