PlayState = BaseState:new()

local COUNTDOWN = 4
local PROGRESS_HEIGHT = 6

function PlayState:enter()
  self.timer = COUNTDOWN
end

function PlayState:update(dt)
  self.timer = math.max(0, self.timer - dt)
  if self.timer == 0 then
    gStateMachine:change("start")
  end
end

function PlayState:render()
  love.graphics.setColor(0.95, 0.95, 0.95)
  love.graphics.setFont(gFonts.normal)
  love.graphics.printf("Actual level", 0, WINDOW_HEIGHT / 2 - gFonts.normal:getHeight() / 2, WINDOW_WIDTH, "center")

  love.graphics.rectangle(
    "fill",
    WINDOW_PADDING,
    WINDOW_HEIGHT - WINDOW_PADDING - PROGRESS_HEIGHT,
    (WINDOW_WIDTH - WINDOW_PADDING * 2) * self.timer / COUNTDOWN,
    PROGRESS_HEIGHT
  )
end
