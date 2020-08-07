VictoryState = Class({__includes = BaseState})

function VictoryState:enter(params)
  self.level = params.level
  self.health = params.health
  self.maxHealth = params.maxHealth
  self.score = params.score
  self.paddle = params.paddle
end

function VictoryState:update(dt)
  if love.keyboard.waspressed("escape") then
    gStateMachine:change("start")
    gSounds["confirm"]:play()
  end

  if love.keyboard.waspressed("enter") or love.keyboard.waspressed("return") then
    gStateMachine:change(
      "serve",
      {
        level = self.level + 1,
        health = self.health,
        maxHealth = self.maxHealth,
        score = self.score,
        paddle = self.paddle
      }
    )
    gSounds["confirm"]:play()
  end
end

function VictoryState:render()
  love.graphics.setColor(1, 1, 1, 1)

  love.graphics.setFont(gFonts["humongous"])
  love.graphics.printf("LEVEL CLEARED", 0, VIRTUAL_HEIGHT / 3 - 28, VIRTUAL_WIDTH, "center")

  love.graphics.setFont(gFonts["big"])
  love.graphics.printf("Score: " .. self.score, 0, VIRTUAL_HEIGHT / 2 - 8, VIRTUAL_WIDTH, "center")

  love.graphics.setFont(gFonts["normal"])
  love.graphics.printf(
    "Press enter to play level " .. self.level + 1,
    0,
    VIRTUAL_HEIGHT * 3 / 4,
    VIRTUAL_WIDTH,
    "center"
  )
end
