TitleState = Class {__includes = BaseState}

function TitleState:init()
  self.title = "Asteroids"
  self.level = 1
end

function TitleState:update(dt)
  if love.keyboard.wasPressed("escape") then
    love.event.quit()
  end

  if love.keyboard.wasPressed("return") then
    gStateMachine:change(
      "spawn",
      {
        level = self.level
      }
    )
  end

  if love.keyboard.wasPressed("right") then
    if self.level < ASTEROIDS_INITIAL_LEVELS then
      self.level = self.level + 1

      gSounds["select"]:play()
    end
  end

  if love.keyboard.wasPressed("left") then
    if self.level > 1 then
      self.level = self.level - 1

      gSounds["select"]:play()
    end
  end
end

function TitleState:render()
  love.graphics.setFont(gFonts.large)
  love.graphics.printf(self.title:upper(), 0, WINDOW_HEIGHT / 2 - gFonts.large:getHeight() - 48, WINDOW_WIDTH, "center")

  love.graphics.setFont(gFonts.normal)
  love.graphics.printf("Press enter to play", 0, WINDOW_HEIGHT / 2, WINDOW_WIDTH, "center")
  love.graphics.printf("Difficulty: ", 0, WINDOW_HEIGHT / 2 + gFonts.normal:getHeight() * 2, WINDOW_WIDTH / 2, "right")
  for i = 1, self.level do
    love.graphics.circle("fill", WINDOW_WIDTH / 2 + 24 * i, WINDOW_HEIGHT / 2 + gFonts.normal:getHeight() * 2.5, 10)
  end
end
