CountdownState = BaseState:new()

local COUNTDOWN = {
  ["duration"] = 2,
  ["speed"] = 1,
  ["label"] = "countdown"
}

function CountdownState:enter(params)
  self.countdown = COUNTDOWN.duration

  Timer:every(
    COUNTDOWN.speed,
    function()
      if self.countdown == 0 then
        Timer:remove(COUNTDOWN.label)
        gStateMachine:change(params.state)
      else
        self.countdown = self.countdown - 1
      end
    end,
    false,
    COUNTDOWN.label
  )
end

function CountdownState:update(dt)
  Timer:update(dt)
end

function CountdownState:render()
  love.graphics.setColor(0.95, 0.95, 0.95)
  love.graphics.setFont(gFonts.large)
  love.graphics.printf("Strike!", 0, WINDOW_HEIGHT / 2 - gFonts.large:getHeight() / 2, WINDOW_WIDTH, "center")
end
