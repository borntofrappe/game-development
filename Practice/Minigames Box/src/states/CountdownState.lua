CountdownState = BaseState:new()

local COUNTDOWN = 2

function CountdownState:enter(params)
  self.title = string.upper(params.state .. "!")

  Timer:after(
    COUNTDOWN,
    function()
      gStateMachine:change(params.state)
    end
  )
end

function CountdownState:update(dt)
  Timer:update(dt)
end

function CountdownState:render()
  love.graphics.setColor(0.95, 0.95, 0.95)
  love.graphics.setFont(gFonts.large)
  love.graphics.printf(self.title, 0, WINDOW_HEIGHT / 2 - gFonts.large:getHeight() / 2, WINDOW_WIDTH, "center")
end
