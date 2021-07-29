FeedbackState = BaseState:new()

function FeedbackState:enter(params)
  self.feedback = params.hasWon and "Congrats!" or "Too bad..."
end

function FeedbackState:update(dt)
  if love.keyboard.waspressed("escape") then
    gStateMachine:change("start")
  end

  if love.keyboard.waspressed("return") then
    gStateMachine:change(
      "countdown",
      {
        ["state"] = "bowling" -- ideally a random state
      }
    )
  end
end

function FeedbackState:render()
  love.graphics.setColor(0.95, 0.95, 0.95)
  love.graphics.setFont(gFonts.large)
  love.graphics.printf(self.feedback, 0, WINDOW_HEIGHT / 2 - gFonts.large:getHeight() / 2, WINDOW_WIDTH, "center")
end
