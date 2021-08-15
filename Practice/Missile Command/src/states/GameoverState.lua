GameoverState = BaseState:new()

local START_STATE_DELAY = 2.5

function GameoverState:enter(params)
  Timer:after(
    START_STATE_DELAY,
    function()
      gStateMachine:change("start")
    end
  )
end

function GameoverState:update(dt)
  Timer:update(dt)

  if love.keyboard.waspressed("escape") or love.keyboard.waspressed("return") then
    Timer:reset()
    gStateMachine:change("start")
  end
end

function GameoverState:render()
  love.graphics.setColor(0, 0, 0)
  love.graphics.setFont(gFonts.normal)
  love.graphics.printf(
    string.upper("The end"),
    0,
    WINDOW_HEIGHT / 2 - gFonts.normal:getHeight() / 2,
    WINDOW_WIDTH,
    "center"
  )
end
