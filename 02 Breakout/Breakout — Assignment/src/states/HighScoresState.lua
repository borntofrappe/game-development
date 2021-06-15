HighScoresState = Class({__includes = BaseState})

function HighScoresState:init()
  self.highScores = loadHighScores()
end

function HighScoresState:update(dt)
  if love.keyboard.waspressed("escape") or love.keyboard.waspressed("enter") or love.keyboard.waspressed("return") then
    gStateMachine:change("start")
    gSounds["confirm"]:play()
  end
end

function HighScoresState:render()
  local y = 8
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setFont(gFonts["big"])
  love.graphics.printf("HIGHT SCORES", 0, y, VIRTUAL_WIDTH, "center")

  y = y + 32 + 8
  local heightLeft = VIRTUAL_HEIGHT - y - 16 - 8
  love.graphics.setFont(gFonts["normal"])
  for k, highScore in pairs(self.highScores) do
    love.graphics.print(highScore.name, VIRTUAL_WIDTH / 2 - VIRTUAL_WIDTH / 6, y)

    love.graphics.printf(highScore.score, VIRTUAL_WIDTH / 2, y, VIRTUAL_WIDTH / 6, "right")
    y = y + heightLeft / (#self.highScores - 1)
  end
end
