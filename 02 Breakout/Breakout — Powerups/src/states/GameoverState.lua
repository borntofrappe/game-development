GameoverState = Class({__includes = BaseState})

function GameoverState:init()
  self.highScores = loadHighScores()
end

function GameoverState:enter(params)
  self.score = params.score
  self.index = -1
  for k, highScore in pairs(self.highScores) do
    if self.score >= highScore.score then
      self.index = k
      break
    end
  end
end

function GameoverState:update(dt)
  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("enter") or love.keyboard.waspressed("return") then
    if self.index == -1 then
      gStateMachine:change("start")
      gSounds["confirm"]:play()
    else
      gStateMachine:change(
        "enterhighscore",
        {
          highScores = self.highScores,
          score = self.score,
          index = self.index
        }
      )
      gSounds["high_score"]:play()
    end
  end
end

function GameoverState:render()
  love.graphics.setColor(1, 1, 1, 1)

  love.graphics.setFont(gFonts["humongous"])
  love.graphics.printf("GAME OVER", 0, VIRTUAL_HEIGHT / 3 - 28, VIRTUAL_WIDTH, "center")

  love.graphics.setFont(gFonts["big"])
  love.graphics.printf("Score: " .. self.score, 0, VIRTUAL_HEIGHT / 2 - 8, VIRTUAL_WIDTH, "center")

  love.graphics.setFont(gFonts["normal"])
  love.graphics.printf("Press enter to continue", 0, VIRTUAL_HEIGHT * 3 / 4, VIRTUAL_WIDTH, "center")
end
