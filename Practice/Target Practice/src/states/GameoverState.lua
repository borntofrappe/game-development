GameoverState = BaseState:new()

function GameoverState:enter(params)
  self.terrain = params.terrain
  self.cannon = params.cannon
  self.target = params.target

  self.hasWon = params.hasWon

  local x = self.hasWon and self.target.x or self.cannon.wheel.x
  local y = self.hasWon and self.target.y or self.cannon.wheel.y + self.cannon.wheel.r
  self.collision = Collision:new(x, y)

  self.title = self.hasWon and "Congrats" or "Not even close"
  local instruction = self.hasWon and "Continue" or "Try again"
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
    gStateMachine:change("play")
  end

  if love.mouse.waspressed(2) or love.keyboard.waspressed("escape") then
    gStateMachine:change("start")
  end

  self.button:update()
end

function GameoverState:render()
  if self.hasWon then
    self.cannon:render()
  else
    self.target:render()
  end

  self.collision:render()

  self.terrain:render()

  love.graphics.setColor(1, 1, 1, OVERLAY_OPACITY)
  love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)

  love.graphics.setColor(0.15, 0.16, 0.22)
  love.graphics.setFont(gFonts.large)
  love.graphics.printf(
    string.upper(self.title),
    0,
    WINDOW_HEIGHT / 2 - gFonts.large:getHeight() - 24,
    WINDOW_WIDTH,
    "center"
  )

  love.graphics.setFont(gFonts.normal)
  self.button:render()
end
