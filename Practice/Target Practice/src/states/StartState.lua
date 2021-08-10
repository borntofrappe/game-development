StartState = BaseState:new()

function StartState:enter()
  self.cannon = Cannon:new()

  self.cannon.angle = 40

  local instruction = string.upper("Play")
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

function StartState:update(dt)
  local x, y = love.mouse:getPosition()
  if x > self.cannon.x and x < WINDOW_WIDTH and y > 0 and y < self.cannon.y then
    local angle = math.atan((self.cannon.y - y) / (x - self.cannon.x))
    self.cannon.angle = math.max(math.min(ANGLE.max, angle * 180 / math.pi), ANGLE.min)
  end

  if love.keyboard.waspressed("return") then
    gStateMachine:change("play")
  end

  if love.mouse.waspressed(2) or love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  self.button:update()
end

function StartState:render()
  love.graphics.setColor(0.15, 0.16, 0.22)
  love.graphics.setFont(gFonts.large)
  love.graphics.printf(TITLE:upper(), 0, WINDOW_HEIGHT / 2 - gFonts.large:getHeight(), WINDOW_WIDTH, "center")

  love.graphics.setFont(gFonts.normal)
  self.button:render()

  self.cannon:render()
end
