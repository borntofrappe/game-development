GameoverState = Class({__includes = BaseState})

function GameoverState:enter(params)
  self.score = params.score
end

function GameoverState:update(dt)
  if love.keyboard.waspressed("enter") or love.keyboard.waspressed("return") or love.mouse.isReleased then
    gStateMachine:change("title")
  end

  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end
end

function GameoverState:render()
  love.graphics.setColor(0.1, 0.17, 0.35, 0.7)
  love.graphics.rectangle("fill", VIRTUAL_WIDTH / 2 - 100, VIRTUAL_HEIGHT / 2 - 80, 200, 160, 8)
  love.graphics.setColor(0, 0, 0, 0.4)
  love.graphics.rectangle("fill", VIRTUAL_WIDTH / 2 - 100, VIRTUAL_HEIGHT / 2 - 80, 200, 160, 8)

  love.graphics.setFont(gFonts["big"])
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.printf("GAME", VIRTUAL_WIDTH / 2 - 98, VIRTUAL_HEIGHT / 2 - 66, 200, "center")
  love.graphics.printf("OVER", VIRTUAL_WIDTH / 2 - 98, VIRTUAL_HEIGHT / 2 - 32, 200, "center")
  love.graphics.setFont(gFonts["normal"])
  love.graphics.printf("Your score:", VIRTUAL_WIDTH / 2 - 99, VIRTUAL_HEIGHT / 2 + 19, 200, "center")
  love.graphics.printf(self.score, VIRTUAL_WIDTH / 2 - 99, VIRTUAL_HEIGHT / 2 + 43, 200, "center")

  love.graphics.setFont(gFonts["big"])
  love.graphics.setColor(0.42, 0.59, 0.94, 1)
  love.graphics.printf("GAME", VIRTUAL_WIDTH / 2 - 100, VIRTUAL_HEIGHT / 2 - 68, 200, "center")
  love.graphics.printf("OVER", VIRTUAL_WIDTH / 2 - 100, VIRTUAL_HEIGHT / 2 - 34, 200, "center")
  love.graphics.setFont(gFonts["normal"])
  love.graphics.printf("Your score:", VIRTUAL_WIDTH / 2 - 100, VIRTUAL_HEIGHT / 2 + 18, 200, "center")
  love.graphics.printf(self.score, VIRTUAL_WIDTH / 2 - 100, VIRTUAL_HEIGHT / 2 + 42, 200, "center")
end
