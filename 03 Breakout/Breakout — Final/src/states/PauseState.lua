PauseState = Class({__includes = BaseState})

function PauseState:init()
  gSounds["music"]:pause()
end

function PauseState:enter(params)
  self.level = params.level
  self.health = params.health
  self.maxHealth = params.maxHealth
  self.score = params.score
  self.paddle = params.paddle
  self.ball = params.ball
  self.bricks = params.bricks
end

function PauseState:exit()
  gSounds["music"]:play()
end

function PauseState:update(dt)
  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("enter") or love.keyboard.waspressed("return") then
    gStateMachine:change(
      "play",
      {
        level = self.level,
        health = self.health,
        maxHealth = self.maxHealth,
        score = self.score,
        paddle = self.paddle,
        ball = self.ball,
        bricks = self.bricks
      }
    )
    gSounds["confirm"]:play()
  end
end

function PauseState:render()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setFont(gFonts["big"])

  love.graphics.printf("Pause", 0, VIRTUAL_HEIGHT / 2 - 20, VIRTUAL_WIDTH, "center")

  love.graphics.setFont(gFonts["normal"])

  love.graphics.printf("Press enter to resume playing", 0, VIRTUAL_HEIGHT / 2 + 16, VIRTUAL_WIDTH, "center")
end
