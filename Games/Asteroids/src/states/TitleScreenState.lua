TitleScreenState = BaseState:create()

function TitleScreenState:enter()
  self.difficulty = 2
end

function TitleScreenState:update(dt)
  if love.keyboard.wasPressed("escape") then
    love.event.quit()
  end

  if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
    gSounds["setup"]:play()
    gStateMachine:change(
      "play",
      {
        difficulty = self.difficulty
      }
    )
  end

  if love.keyboard.wasPressed("right") or love.keyboard.wasPressed("d") then
    self.difficulty = math.min(self.difficulty + 1, 3)
  end

  if love.keyboard.wasPressed("left") or love.keyboard.wasPressed("a") then
    self.difficulty = math.max(self.difficulty - 1, 1)
  end
end

function TitleScreenState:render()
  love.graphics.setColor(gColors["foreground"]["r"], gColors["foreground"]["g"], gColors["foreground"]["b"])
  love.graphics.setFont(gFonts["large"])
  love.graphics.printf(string.upper("Asteroids"), 0, WINDOW_HEIGHT / 4, WINDOW_WIDTH, "center")

  love.graphics.setFont(gFonts["normal"])
  love.graphics.printf(string.upper("Press enter to play"), 0, WINDOW_HEIGHT * 3 / 4 - 48, WINDOW_WIDTH, "center")

  love.graphics.printf(string.upper("Difficulty:"), 0, WINDOW_HEIGHT * 3 / 4 - 16, WINDOW_WIDTH / 2, "right")
  for i = 1, self.difficulty do
    love.graphics.circle("fill", WINDOW_WIDTH / 2 + 22 * i, WINDOW_HEIGHT * 3 / 4 - 6, 10)
  end
end
