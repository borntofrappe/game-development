GameoverState = BaseState:create()

function GameoverState:enter(params)
  self.timeout = 5

  self.score = params.score
  self.asteroids = params.asteroids

  gSounds["gameover"]:play()
end

function GameoverState:update(dt)
  if self.timeout > 0 then
    self.timeout = self.timeout - dt

    if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
      gSounds["gameover"]:stop()
      gStateMachine:change("title")
    end

    for k, asteroid in pairs(self.asteroids) do
      asteroid:update(dt)
    end
  else
    gStateMachine:change("title")
  end
end

function GameoverState:render()
  showRecord()
  showStats(self.score)

  for k, asteroid in pairs(self.asteroids) do
    asteroid:render()
  end

  love.graphics.setColor(gColors["foreground"]["r"], gColors["foreground"]["g"], gColors["foreground"]["b"])
  love.graphics.setFont(gFonts["large"])
  love.graphics.printf(string.upper("Gameover"), 0, WINDOW_HEIGHT / 2 - 30, WINDOW_WIDTH, "center")
end
