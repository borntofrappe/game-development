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
end

function TitleState:render()
  love.graphics.setFont(gFonts.large)
  love.graphics.printf(self.title:upper(), 0, WINDOW_HEIGHT / 2 - gFonts.large:getHeight(), WINDOW_WIDTH, "center")

  love.graphics.setFont(gFonts.normal)
  love.graphics.printf("Press enter to play", 0, WINDOW_HEIGHT / 2 + gFonts.large:getHeight(), WINDOW_WIDTH, "center")
end
