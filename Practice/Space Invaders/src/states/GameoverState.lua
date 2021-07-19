GameoverState = BaseState:new()

local TITLE_STATE_DELAY = 5

function GameoverState:enter()
  self.delay = {
    ["duration"] = TITLE_STATE_DELAY,
    ["label"] = "title-state-delay"
  }

  Timer:after(
    self.delay.duration,
    function()
      gStateMachine:change("title")
    end,
    self.delay.label
  )
end

function GameoverState:update(dt)
  Timer:update(dt)

  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("return") then
    Timer:remove(self.delay.label)
    gStateMachine:change("title")
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
