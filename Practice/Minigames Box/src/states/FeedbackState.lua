FeedbackState = BaseState:new()

local COUNTDOWN = 2

function FeedbackState:enter(params)
  self.feedback = params.hasWon and "Congrats!" or "Too bad..."

  Timer:after(
    COUNTDOWN,
    function()
      gStateMachine:change("start") -- ideally you'd move to the countdown and another game
    end
  )
end

function FeedbackState:update(dt)
  Timer:update(dt)
end

function FeedbackState:render()
  love.graphics.setColor(0.95, 0.95, 0.95)
  love.graphics.setFont(gFonts.large)
  love.graphics.printf(self.feedback, 0, WINDOW_HEIGHT / 2 - gFonts.large:getHeight() / 2, WINDOW_WIDTH, "center")
end
