CountdownState = BaseState:new()

function CountdownState:enter()
  local state = gStates[math.random(#gStates)]
  self.title = string.upper(state .. "!")

  Timer:after(
    COUNTDOWN_FEEBACK,
    function()
      gStateMachine:change(state)
    end
  )
end

function CountdownState:update(dt)
  Timer:update(dt)
end

function CountdownState:render()
  love.graphics.setColor(0.95, 0.95, 0.95)
  love.graphics.setFont(gFonts.large)
  love.graphics.printf(self.title, 0, PLAYING_HEIGHT / 2 - gFonts.large:getHeight() / 2, PLAYING_WIDTH, "center")
end
