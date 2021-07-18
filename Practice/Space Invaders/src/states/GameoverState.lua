GameoverState = BaseState:new()

local COUNTDOWN_DURATION = 5

function GameoverState:enter()
  self.startCountdown = {
    ["duration"] = COUNTDOWN_DURATION,
    ["label"] = "startCountdown"
  }

  Timer:after(
    self.startCountdown.duration,
    function()
      gStateMachine:change("start")
    end,
    self.startCountdown.label
  )
end

function GameoverState:update(dt)
  Timer:update(dt)

  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("return") then
    Timer:remove(self.startCountdown.label)
    gStateMachine:change("start")
  end
end

function GameoverState:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(gFonts.normal)
  love.graphics.printf(
    string.upper("Gameover"),
    0,
    WINDOW_HEIGHT / 2 - gFonts.normal:getHeight() / 2,
    WINDOW_WIDTH,
    "center"
  )
end
