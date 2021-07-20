HighScoreState = BaseState:new()

local TITLE_STATE_DELAY = 3.5

function HighScoreState:enter(params)
  self.title = string.upper("You\nget\nHi-score!")
  gHighScore = params.highScore

  self.delay = {
    ["duration"] = TITLE_STATE_DELAY
  }

  Timer:after(
    self.delay.duration,
    function()
      gStateMachine:change("title")
    end
  )
end

function HighScoreState:update(dt)
  Timer:update(dt)
end

function HighScoreState:render()
  love.graphics.setColor(0.14, 0.75, 0.38)
  love.graphics.setFont(gFonts.normal)
  love.graphics.printf(self.title, 0, WINDOW_HEIGHT / 2 - gFonts.normal:getHeight() * 1.5, WINDOW_WIDTH, "center")
end
