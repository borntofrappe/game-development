PlayState = BaseState:new()

local TWEEN_DURATION = 0.25

local WHITESPACE = 10

function PlayState:enter()
  -- x for the position of the wheel/rotation point
  -- y for the bottom
  self.cannon = Cannon:new(34 + 20, WINDOW_HEIGHT - 20)
  self.terrain = Terrain:new(self.cannon)

  self.angle = self.cannon.angle
  self.velocity = self.cannon.velocity

  self.maxWidth = gFonts.normal:getWidth("Velocity 90")

  local buttonVelocityDown =
    Button:new(
    8,
    8,
    42,
    42,
    "-",
    function()
      self.velocity = math.max(5, self.velocity - 5)
    end
  )

  local buttonVelocityUp =
    Button:new(
    buttonVelocityDown.x + buttonVelocityDown.width + WHITESPACE * 2 + self.maxWidth,
    8,
    42,
    42,
    "+",
    function()
      self.velocity = math.min(90, self.velocity + 5)
    end
  )

  local buttonAngleDown =
    Button:new(
    buttonVelocityDown.x,
    buttonVelocityDown.y + buttonVelocityDown.height + WHITESPACE,
    42,
    42,
    "-",
    function()
      self.angle = math.max(0, self.angle - 5)
    end
  )

  local buttonAngleUp =
    Button:new(
    buttonVelocityUp.x,
    buttonVelocityDown.y + buttonVelocityDown.height + WHITESPACE,
    42,
    42,
    "+",
    function()
      self.angle = math.min(90, self.angle + 5)
    end
  )

  local buttonFire =
    Button:new(
    buttonAngleDown.x,
    buttonAngleDown.y + buttonAngleDown.height + WHITESPACE,
    buttonAngleDown.width * 2 + WHITESPACE * 2 + self.maxWidth,
    42,
    string.upper("Fire"),
    function()
      self.cannon.velocity = self.velocity
      Timer:tween(
        TWEEN_DURATION,
        {
          [self.cannon] = {["angle"] = self.angle}
        }
      )
      -- you'd fire after the tween animation
    end
  )

  self.xVelocity = buttonVelocityDown.x + buttonVelocityDown.width + WHITESPACE
  self.xAngle = buttonAngleDown.x + buttonAngleDown.width + WHITESPACE
  self.yVelocity = buttonVelocityDown.y + buttonVelocityDown.height / 2 - gFonts.normal:getHeight() / 2
  self.yAngle = buttonAngleDown.y + buttonAngleDown.height / 2 - gFonts.normal:getHeight() / 2

  self.buttons = {
    buttonVelocityDown,
    buttonVelocityUp,
    buttonAngleDown,
    buttonAngleUp,
    buttonFire
  }
end

function PlayState:update(dt)
  Timer:update(dt)

  for i, button in ipairs(self.buttons) do
    button:update(dt)
  end

  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  -- debugging
  if love.keyboard.waspressed("tab") then
    self.terrain = Terrain:new(self.cannon)
  end

  if love.keyboard.waspressed("up") then
    self.angle = math.min(90, self.angle + 5)
  end

  if love.keyboard.waspressed("down") then
    self.angle = math.max(0, self.angle - 5)
  end

  if love.keyboard.waspressed("right") then
    self.velocity = math.min(90, self.velocity + 5)
  end

  if love.keyboard.waspressed("left") then
    self.velocity = math.max(5, self.velocity - 5)
  end

  if love.keyboard.waspressed("return") then
    self.cannon.velocity = self.velocity
    Timer:tween(
      TWEEN_DURATION,
      {
        [self.cannon] = {["angle"] = self.angle}
      }
    )
  -- you'd fire after the tween animation
  end
end

function PlayState:render()
  love.graphics.setFont(gFonts.normal)
  for i, button in ipairs(self.buttons) do
    button:render()
  end

  love.graphics.setColor(0.83, 0.87, 0.92)
  love.graphics.printf(
    string.format("Velocity %02d", self.velocity),
    self.xVelocity,
    self.yVelocity,
    self.maxWidth,
    "center"
  )
  love.graphics.printf(string.format("Angle %02d", self.angle), self.xAngle, self.yAngle, self.maxWidth, "center")

  self.cannon:render()
  self.terrain:render()
end
