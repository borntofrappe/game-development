GameoverState = BaseState:new()

local TWEEN_OPACITY = 0.2

function GameoverState:enter()
  local instruction = "Try again"
  local width = gFonts.normal:getWidth(instruction) * 2
  local height = gFonts.normal:getHeight() * 2

  self.button =
    Button:new(
    WINDOW_WIDTH / 2 - width / 2,
    WINDOW_HEIGHT / 2 + 26,
    width,
    height,
    instruction,
    function()
      gStateMachine:change("play")
    end
  )
end

function GameoverState:update(dt)
  if love.keyboard.waspressed("return") then
    gStateMachine:change(
      "play",
      {
        ["reset"] = true
      }
    )
  end

  if love.mouse.waspressed(2) or love.keyboard.waspressed("escape") then
    gStateMachine:change(
      "start",
      {
        ["reset"] = true
      }
    )
  end

  self.button:update()
end

function GameoverState:render()
  love.graphics.setColor(1, 1, 1, 0.5)
  love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)

  love.graphics.setColor(0.15, 0.16, 0.22)
  love.graphics.setFont(gFonts.large)
  love.graphics.printf(
    string.upper("Not even close"),
    0,
    WINDOW_HEIGHT / 2 - gFonts.large:getHeight(),
    WINDOW_WIDTH,
    "center"
  )

  love.graphics.setFont(gFonts.normal)
  self.button:render()
end
