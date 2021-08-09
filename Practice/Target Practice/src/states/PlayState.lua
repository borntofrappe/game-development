PlayState = BaseState:new()

local TWEEN_ANGLE = 0.25
local DELAY_FIRE = 0.1
local INTERVAL_CANNONBALL = 0.01

local GUI_WHITESPACE = 8
local GUI_PADDING = 10
local GUI_BUTTON_SIZE = 38

function PlayState:enter()
  self.terrain = Terrain:new()
  self.cannon = Cannon:new(self.terrain)
  self.target = Target:new(self.terrain)
  self.cannonball = Cannonball:new(self.cannon)

  self.angle = self.cannon.angle
  self.velocity = self.cannon.velocity

  self.trajectory = {}

  self.maxWidth = gFonts.normal:getWidth("Velocity 1234")
  local buttonVelocityDown =
    Button:new(
    GUI_PADDING,
    GUI_PADDING,
    GUI_BUTTON_SIZE,
    GUI_BUTTON_SIZE,
    "-",
    function()
      self:updateVelocity("down")
    end
  )

  local buttonVelocityUp =
    Button:new(
    buttonVelocityDown.x + buttonVelocityDown.width + GUI_WHITESPACE * 2 + self.maxWidth,
    buttonVelocityDown.y,
    GUI_BUTTON_SIZE,
    GUI_BUTTON_SIZE,
    "+",
    function()
      self:updateVelocity("up")
    end
  )

  local buttonAngleDown =
    Button:new(
    buttonVelocityDown.x,
    buttonVelocityDown.y + buttonVelocityDown.height + GUI_WHITESPACE,
    GUI_BUTTON_SIZE,
    GUI_BUTTON_SIZE,
    "-",
    function()
      self:updateAngle("down")
    end
  )

  local buttonAngleUp =
    Button:new(
    buttonVelocityUp.x,
    buttonVelocityDown.y + buttonVelocityDown.height + GUI_WHITESPACE,
    GUI_BUTTON_SIZE,
    GUI_BUTTON_SIZE,
    "+",
    function()
      self:updateAngle("up")
    end
  )

  local buttonFire =
    Button:new(
    buttonAngleDown.x,
    buttonAngleDown.y + buttonAngleDown.height + GUI_WHITESPACE,
    buttonAngleDown.width * 2 + GUI_WHITESPACE * 2 + self.maxWidth,
    GUI_BUTTON_SIZE,
    string.upper("Fire!"),
    function()
      self:fire()
    end
  )

  self.xVelocity = buttonVelocityDown.x + buttonVelocityDown.width + GUI_WHITESPACE
  self.xAngle = buttonAngleDown.x + buttonAngleDown.width + GUI_WHITESPACE
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
    Timer:reset()

    self.terrain = Terrain:new()
    self.cannon = Cannon:new(self.terrain)
    self.target = Target:new(self.terrain)
    self.cannonball = Cannonball:new(self.cannon)

    self.angle = self.cannon.angle
    self.velocity = self.cannon.velocity

    self.trajectory = {}
  end

  if love.keyboard.waspressed("right") then
    self:updateVelocity("up")
  end

  if love.keyboard.waspressed("left") then
    self:updateVelocity("down")
  end

  if love.keyboard.waspressed("up") then
    self:updateAngle("up")
  end

  if love.keyboard.waspressed("down") then
    self:updateAngle("down")
  end

  if love.keyboard.waspressed("return") then
    self:fire()
  end
end

function PlayState:render()
  love.graphics.setFont(gFonts.normal)
  for i, button in ipairs(self.buttons) do
    button:render()
  end

  love.graphics.setColor(0.18, 0.19, 0.26)
  love.graphics.printf(
    string.format("Velocity %d", self.velocity),
    self.xVelocity,
    self.yVelocity,
    self.maxWidth,
    "center"
  )
  love.graphics.printf(string.format("Angle %d", self.angle), self.xAngle, self.yAngle, self.maxWidth, "center")

  self.cannonball:render()
  self.cannon:render()
  self.target:render()
  self.terrain:render()
end

function PlayState:updateVelocity(direction)
  if direction == "up" then
    self.velocity = math.min(VELOCITY.max, self.velocity + VELOCITY.increments)
  else
    self.velocity = math.max(VELOCITY.min, self.velocity - VELOCITY.increments)
  end
end

function PlayState:updateAngle(direction)
  if direction == "up" then
    self.angle = math.min(ANGLE.max, self.angle + ANGLE.increments)
  else
    self.angle = math.max(ANGLE.min, self.angle - ANGLE.increments)
  end
end

function PlayState:getTrajectory()
  local a = self.cannon.angle
  local v = self.cannon.velocity

  local points = {}
  local theta = math.rad(a)

  local t = 0
  local dt = (self.terrain.points[3] - self.terrain.points[1]) / (v * math.cos(theta))

  while true do
    dx = v * t * math.cos(theta)
    dy = v * t * math.sin(theta) - 1 / 2 * GRAVITY * t ^ 2

    table.insert(points, self.cannon.x + dx)
    table.insert(points, self.cannon.y - dy)

    t = t + dt

    if self.cannon.y - dy > WINDOW_HEIGHT then
      break
    end
  end

  return points
end

function PlayState:fire()
  self.cannon.velocity = self.velocity

  Timer:reset()

  Timer:tween(
    TWEEN_ANGLE,
    {
      [self.cannon] = {["angle"] = self.angle}
    },
    function()
      self.trajectory = self:getTrajectory()

      local index = 1

      local indexStart
      for i = 1, #self.terrain.points, 2 do
        if self.terrain.points[i] >= self.trajectory[1] then
          indexStart = i
          break
        end
      end

      Timer:after(
        DELAY_FIRE,
        function()
          Timer:every(
            INTERVAL_CANNONBALL,
            function()
              index = index + 2
              self.cannonball.x = self.trajectory[index]
              self.cannonball.y = self.trajectory[index + 1]

              local r = self.cannonball.r
              if self.trajectory[index + 1] + r > self.terrain.points[indexStart + index + 2] then
                Timer:reset()

                local x1 = self.cannonball.x - r
                local x2 = self.cannonball.x + r

                self.cannonball.x = self.cannon.x
                self.cannonball.y = self.cannon.y

                local angle = 0
                local dangle = math.pi / math.floor(WINDOW_WIDTH / (r * 2) / 2)

                for i = 1, #self.terrain.points, 2 do
                  if self.terrain.points[i] > x1 then
                    self.terrain.points[i + 1] =
                      math.min(WINDOW_HEIGHT, self.terrain.points[i + 1] + math.sin(angle) * r)
                    angle = angle + dangle

                    if angle >= math.pi then
                      break
                    end
                  end
                end
              end

              if index + 2 >= #self.trajectory or indexStart + index + 2 >= #self.terrain.points then
                Timer:reset()

                self.cannonball.x = self.cannon.x
                self.cannonball.y = self.cannon.y
              end
            end
          )
        end
      )
    end
  )
end
