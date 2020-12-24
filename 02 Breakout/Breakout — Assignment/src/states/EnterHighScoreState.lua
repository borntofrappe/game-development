EnterHighScoreState = Class({__includes = BaseState})

function EnterHighScoreState:init()
  self.choice = 1
  self.chars = {
    [1] = 65,
    [2] = 65,
    [3] = 65
  }
end

function EnterHighScoreState:enter(params)
  self.highScores = params.highScores
  self.score = params.score
  self.index = params.index
end

function EnterHighScoreState:update(dt)
  if love.keyboard.waspressed("escape") then
    gStateMachine:change("start")
    gSounds["confirm"]:play()
  end

  if love.keyboard.waspressed("enter") or love.keyboard.waspressed("return") then
    name = ""
    for k, char in pairs(self.chars) do
      name = name .. string.char(char)
    end

    newHighScores = {}
    for k, highScore in pairs(self.highScores) do
      if k < self.index then
        newHighScores[k] = highScore
      elseif k == self.index then
        newHighScores[k] = {
          name = name,
          score = self.score
        }
      else
        newHighScores[k] = highScores[k - 1]
      end
    end

    highScores = ""
    for k, highScore in pairs(newHighScores) do
      highScores = highScores .. highScore.name .. "\n"
      highScores = highScores .. highScore.score .. "\n"
    end

    love.filesystem.write("highscores.lst", string.sub(highScores, 1, #highScores - 1))

    gStateMachine:change("highscores")
    gSounds["confirm"]:play()
  end

  if love.keyboard.waspressed("right") then
    self.choice = self.choice == #self.chars and 1 or self.choice + 1
    gSounds["select"]:play()
  end

  if love.keyboard.waspressed("left") then
    self.choice = self.choice == 1 and #self.chars or self.choice - 1
    gSounds["select"]:play()
  end

  if love.keyboard.waspressed("up") then
    self.chars[self.choice] = self.chars[self.choice] == 65 and 65 + 25 or self.chars[self.choice] - 1
    gSounds["select"]:play()
  end

  if love.keyboard.waspressed("down") then
    self.chars[self.choice] = self.chars[self.choice] == 65 + 25 and 65 or self.chars[self.choice] + 1
    gSounds["select"]:play()
  end
end

function EnterHighScoreState:render()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setFont(gFonts["big"])

  love.graphics.printf("HIGH SCORE", 0, VIRTUAL_HEIGHT / 4 - 32, VIRTUAL_WIDTH, "center")

  love.graphics.setFont(gFonts["humongous"])
  for k, char in pairs(self.chars) do
    offsetX = (k - (#self.chars + 1) / 2) * 48

    if k == self.choice then
      love.graphics.setColor(0.4, 1, 1, 1)
      love.graphics.rectangle("fill", VIRTUAL_WIDTH / 2 + offsetX - 12.5, VIRTUAL_HEIGHT / 2 - 35, 20, 5)
      love.graphics.rectangle("fill", VIRTUAL_WIDTH / 2 + offsetX - 7.5, VIRTUAL_HEIGHT / 2 - 40, 10, 5)

      love.graphics.rectangle("fill", VIRTUAL_WIDTH / 2 + offsetX - 12.5, VIRTUAL_HEIGHT / 2 + 23, 20, 5)
      love.graphics.rectangle("fill", VIRTUAL_WIDTH / 2 + offsetX - 7.5, VIRTUAL_HEIGHT / 2 + 28, 10, 5)
    end

    love.graphics.printf(string.char(char), offsetX, VIRTUAL_HEIGHT / 2 - 28, VIRTUAL_WIDTH, "center")

    love.graphics.setColor(1, 1, 1, 1)
  end

  love.graphics.setFont(gFonts["big"])
  love.graphics.printf("Score: " .. self.score, 0, VIRTUAL_HEIGHT * 3 / 4, VIRTUAL_WIDTH, "center")
end
