FeedbackState = BaseState:new()

function FeedbackState:enter(params)
  self.feedback = params.hasWon and "Congrats!" or "Too bad..."

  Timer:after(
    COUNTDOWN_FEEBACK,
    function()
      gStateMachine:change("countdown")
    end
  )
end

function FeedbackState:update(dt)
  Timer:update(dt)
end

function FeedbackState:render()
  love.graphics.setColor(0.95, 0.95, 0.95)
  love.graphics.setFont(gFonts.large)
  love.graphics.printf(self.feedback, 0, PLAYING_HEIGHT / 2 - gFonts.large:getHeight() / 2, PLAYING_WIDTH, "center")
end
