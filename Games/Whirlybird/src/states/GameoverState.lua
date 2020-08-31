GameoverState = Class({__includes = BaseState})

function GameoverState:init()
  self.text = "Game\nOver"
end

function GameoverState:enter(params)
  self.score = params.score
  if self.score > gRecord then
    gRecord = self.score
  end
end

function GameoverState:update()
  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("enter") or love.keyboard.waspressed("return") then
    gStateMachine:change("play", {})
  end
end

function GameoverState:render()
  love.graphics.setColor(gColors["grey"]["r"], gColors["grey"]["g"], gColors["grey"]["b"])
  love.graphics.setFont(gFonts["big"])
  love.graphics.printf(self.text:upper(), 0, WINDOW_HEIGHT / 2 - 48, WINDOW_WIDTH, "center")

  showScore(self.score)
end
