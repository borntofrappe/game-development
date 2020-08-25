PauseState = Class({__includes = BaseState})

function PauseState:init()
  self.text = "Pause"
end

function PauseState:enter(params)
  self.player = params.player
  self.bullet = params.bullet
  self.rows = params.rows
  self.round = params.round
  self.score = params.score
  self.health = params.health
end

function PauseState:update(dt)
  if love.keyboard.waspressed("enter") or love.keyboard.waspressed("return") then
    gStateMachine:change(
      "play",
      {
        player = self.player,
        bullet = self.bullet,
        rows = self.rows,
        round = self.round,
        score = self.score,
        health = self.health
      }
    )
  end

  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end
end

function PauseState:render()
  showInfo(
    {
      score = self.score,
      health = self.health
    }
  )

  love.graphics.setColor(1, 1, 1, 1)
  if self.bullet then
    self.bullet:render()
  end
  self.player:render()

  for k, row in pairs(self.rows) do
    for j, alien in pairs(row) do
      alien:render()
    end
  end

  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.rectangle("fill", WINDOW_WIDTH / 2 - 39, WINDOW_HEIGHT / 2 - 13, 76, 25)
  love.graphics.setFont(gFonts["normal"])
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.printf(self.text:upper(), 0, WINDOW_HEIGHT / 2 - 12, WINDOW_WIDTH, "center")
end
