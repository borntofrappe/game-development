GameoverState = BaseState:new()

local START_STATE_DELAY = 3

function GameoverState:enter(params)
  self.data = params.data

  self.title = {
    ["text"] = string.upper("The end"),
    ["y"] = WINDOW_HEIGHT / 2 - gFonts.large:getHeight() - 6
  }

  self.points = {
    ["text"] = self.data.points .. " points",
    ["y"] = self.title.y + gFonts.large:getHeight() + 14
  }

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
  love.graphics.setFont(gFonts.large)
  love.graphics.printf(self.title.text, 0, self.title.y, WINDOW_WIDTH, "center")

  love.graphics.setFont(gFonts.normal)
  love.graphics.printf(self.points.text, 0, self.points.y, WINDOW_WIDTH, "center")
end
