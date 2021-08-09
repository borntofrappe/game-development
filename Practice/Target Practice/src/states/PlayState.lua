PlayState = BaseState:new()

local GRAVITY = 9
local TWEEN_DURATION = 0.25
local INTERVAL_DURATION = 0.02

local WHITESPACE = 10
local PADDING = 12
local BUTTON_SIZE = 42

function PlayState:enter()
  -- x for the position of the wheel/rotation point
  -- y for the bottom
  self.cannon = Cannon:new(34 + 20, WINDOW_HEIGHT - 20)
  self.terrain = Terrain:new(self.cannon)
  self.target = Target:new(WINDOW_WIDTH - 50 - 20, self.terrain.points[#self.terrain.points])
  self.cannonball = Cannonball:new(self.cannon.x, self.cannon.y - self.cannon.offsetHeight)

  self.angle = self.cannon.angle
  self.velocity = self.cannon.velocity

  self.trajectory = {}

  -- gui buttons
  self.maxWidth = gFonts.normal:getWidth("Velocity 1234")
  local buttonVelocityDown =
    Button:new(
    PADDING,
    PADDING,
    BUTTON_SIZE,
    BUTTON_SIZE,
    "-",
    function()
      self.velocity = math.max(5, self.velocity - 5)
    end
  )

  local buttonVelocityUp =
    Button:new(
    buttonVelocityDown.x + buttonVelocityDown.width + WHITESPACE * 2 + self.maxWidth,
    buttonVelocityDown.y,
    BUTTON_SIZE,
    BUTTON_SIZE,
    "+",
    function()
      self.velocity = math.min(150, self.velocity + 5)
    end
  )

  local buttonAngleDown =
    Button:new(
    buttonVelocityDown.x,
    buttonVelocityDown.y + buttonVelocityDown.height + WHITESPACE,
    BUTTON_SIZE,
    BUTTON_SIZE,
    "-",
    function()
      self.angle = math.max(0, self.angle - 5)
    end
  )

  local buttonAngleUp =
    Button:new(
    buttonVelocityUp.x,
    buttonVelocityDown.y + buttonVelocityDown.height + WHITESPACE,
    BUTTON_SIZE,
    BUTTON_SIZE,
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
    BUTTON_SIZE,
    string.upper("Fire!"),
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
    self.target = Target:new(WINDOW_WIDTH - 50 - 20, self.terrain.points[#self.terrain.points])
  end

  if love.keyboard.waspressed("up") then
    self.angle = math.min(90, self.angle + 5)
  end

  if love.keyboard.waspressed("down") then
    self.angle = math.max(0, self.angle - 5)
  end

  if love.keyboard.waspressed("right") then
    self.velocity = math.min(150, self.velocity + 5)
  end

  if love.keyboard.waspressed("left") then
    self.velocity = math.max(5, self.velocity - 5)
  end

  if love.keyboard.waspressed("return") then
    self.cannon.velocity = self.velocity

    Timer:reset()

    Timer:tween(
      TWEEN_DURATION,
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

        Timer:every(
          INTERVAL_DURATION,
          function()
            index = index + 2
            self.cannonball.x = self.trajectory[index]
            self.cannonball.y = self.trajectory[index + 1]

            local r = self.cannonball.size / 2
            if self.trajectory[index + 1] + r > self.terrain.points[indexStart + index + 2] then
              Timer:reset()

              local x1 = self.cannonball.x - r
              local x2 = self.cannonball.x + r

              self.cannonball.x = self.cannon.x
              self.cannonball.y = self.cannon.y - self.cannon.offsetHeight

              local angle = 0
              -- *2 to consider the diameter, *2 given the x y sequence
              local dangle = math.pi / math.floor(WINDOW_WIDTH / (r * 2)) * 2

              for i = 1, #self.terrain.points, 2 do
                if self.terrain.points[i] > x1 then
                  self.terrain.points[i + 1] = self.terrain.points[i + 1] + math.sin(angle) * r
                  angle = angle + dangle

                  -- :)
                  if angle >= math.pi then
                    break
                  end
                end
              end
            end

            if index + 2 >= #self.trajectory or indexStart + index + 2 >= #self.terrain.points then
              Timer:reset()

              self.cannonball.x = self.cannon.x
              self.cannonball.y = self.cannon.y - self.cannon.offsetHeight
            end
          end
        )
      end
    )
  end
end

function PlayState:render()
  love.graphics.setFont(gFonts.normal)
  for i, button in ipairs(self.buttons) do
    button:render()
  end

  love.graphics.setColor(0.83, 0.87, 0.92)
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

  --[[
    if #self.trajectory > 0 then
      love.graphics.setColor(1, 0.8, 0.15)
      love.graphics.setLineWidth(3)
      love.graphics.line(self.trajectory)
    end
  ]]
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
    table.insert(points, self.cannon.y - self.cannon.offsetHeight - dy)

    t = t + dt

    if self.cannon.y - dy > WINDOW_HEIGHT then
      break
    end
  end

  return points
end
