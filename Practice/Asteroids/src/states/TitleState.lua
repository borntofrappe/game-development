TitleState = Class {__includes = BaseState}

function TitleState:init()
  self.title = "Asteroids"
end

function TitleState:update(dt)
  if love.keyboard.wasPressed("escape") then
    love.event.quit()
  end

  if love.keyboard.wasPressed("return") then
    gStateMachine:change("spawn")
  end

  if love.keyboard.wasPressed("right") then
    gStats.level = math.min(ASTEROIDS_INITIAL_LEVELS, gStats.level + 1)
  end

  if love.keyboard.wasPressed("left") then
    gStats.level = math.max(1, gStats.level - 1)
  end
end

function TitleState:render()
  love.graphics.setFont(gFonts.large)
  love.graphics.printf(self.title:upper(), 0, WINDOW_HEIGHT / 2 - gFonts.large:getHeight() - 48, WINDOW_WIDTH, "center")

  love.graphics.setFont(gFonts.normal)
  love.graphics.printf("Press enter to play", 0, WINDOW_HEIGHT / 2, WINDOW_WIDTH, "center")
  love.graphics.printf("Difficulty: ", 0, WINDOW_HEIGHT / 2 + gFonts.normal:getHeight() * 2, WINDOW_WIDTH / 2, "right")
  for i = 1, gStats.level do
    love.graphics.circle("fill", WINDOW_WIDTH / 2 + 24 * i, WINDOW_HEIGHT / 2 + gFonts.normal:getHeight() * 2.5, 10)
  end
end
