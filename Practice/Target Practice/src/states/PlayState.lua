PlayState = BaseState:new()

local TWEEN_DURATION = 0.25

function PlayState:enter()
  -- x for the position of the wheel/rotation point
  -- y for the bottom
  self.cannon = Cannon:new(34 + 20, WINDOW_HEIGHT - 20)
  self.terrain = Terrain:new(self.cannon)

  self.angle = self.cannon.angle
  self.velocity = self.cannon.velocity
end

function PlayState:update(dt)
  Timer:update(dt)

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
    self.velocity = math.min(100, self.velocity + 5)
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
  end
end

function PlayState:render()
  love.graphics.setFont(gFonts.normal)
  love.graphics.setColor(0.83, 0.87, 0.92)
  love.graphics.print("Velocity: " .. self.velocity, 8, 8)
  love.graphics.print("Angle: " .. self.angle, 8, 32)

  self.cannon:render()
  self.terrain:render()
end
