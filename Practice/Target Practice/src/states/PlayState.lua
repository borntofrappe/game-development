PlayState = BaseState:new()

local TWEEN_ANGLE = 0.25
local INTERVAL_CANNONBALL = 0.01

local GUI_WHITESPACE = 8
local GUI_PADDING = 10
local GUI_BUTTON_SIZE = 38

function PlayState:enter(params)
  self.terrain = params and params.terrain or Terrain:new()
  self.cannon = params and params.cannon or Cannon:new(self.terrain)
  self.target = params and params.target or Target:new(self.terrain)

  self.cannonball = nil

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

  if love.mouse.waspressed(2) or love.keyboard.waspressed("escape") then
    Timer:reset()
    gStateMachine:change("start")
  end

  for i, button in ipairs(self.buttons) do
    button:update(dt)
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

  love.graphics.setColor(0.15, 0.16, 0.22)
  love.graphics.printf(
    string.format("Velocity %d", self.velocity),
    self.xVelocity,
    self.yVelocity,
    self.maxWidth,
    "center"
  )
  love.graphics.printf(string.format("Angle %d", self.angle), self.xAngle, self.yAngle, self.maxWidth, "center")

  if self.cannonball then
    self.cannonball:render()
  end

  self.cannon:render()
  self.target:render()
  self.terrain:render()

  --[[
    love.graphics.setColor(0.15, 0.16, 0.22)
    love.graphics.setLineWidth(2)
    if #self.trajectory > 0 then
      love.graphics.line(self.trajectory)
    end
  --]]
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
  -- from the end of the cannon
  local a = self.cannon.angle
  local v = self.cannon.velocity
  local x = self.cannon.body.x + self.cannon.body.width * math.cos(math.rad(self.cannon.angle))
  local y = self.cannon.body.y - self.cannon.body.width * math.sin(math.rad(self.cannon.angle))

  local points = {}
  local theta = math.rad(a)

  local t = 0
  local dt = (self.terrain.points[3] - self.terrain.points[1]) / (v * math.cos(theta))

  while true do
    dx = v * t * math.cos(theta)
    dy = v * t * math.sin(theta) - 1 / 2 * GRAVITY * t ^ 2

    table.insert(points, x + dx)
    table.insert(points, y - dy)

    t = t + dt

    if y - dy > WINDOW_HEIGHT then
      break
    end
  end

  return points
end

function PlayState:fire()
  self.cannon.velocity = self.velocity

  self.cannonball = nil
  Timer:reset()

  local tweenAngle = self.cannon.angle == self.angle and 0 or TWEEN_ANGLE
  -- have the interval dependant on the number of points in the trajectory
  -- from start to collision

  Timer:tween(
    tweenAngle,
    {
      [self.cannon] = {["angle"] = self.angle}
    },
    function()
      self.trajectory = self:getTrajectory()
      self.cannonball = Cannonball:new(self.cannon)

      local index = 1

      local indexStart
      for i = 1, #self.terrain.points, 2 do
        if self.terrain.points[i] >= self.trajectory[1] then
          indexStart = i
          break
        end
      end

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

            self.cannonball = nil

            -- aabb test considering the wheel
            if
              (x1 > self.cannon.wheel.x - self.cannon.wheel.r and x1 < self.cannon.wheel.x + self.cannon.wheel.r) or
                (x2 > self.cannon.wheel.x - self.cannon.wheel.r and x2 < self.cannon.wheel.x + self.cannon.wheel.r)
             then
              gStateMachine:change(
                "gameover",
                {
                  ["terrain"] = self.terrain,
                  ["cannon"] = self.cannon,
                  ["target"] = self.target
                }
              )
            elseif
              (x1 > self.target.x - self.target.width / 2 and x1 < self.target.x + self.target.width / 2) or
                (x2 > self.target.x - self.target.width / 2 and x2 < self.target.x + self.target.width / 2)
             then
              gStateMachine:change(
                "gameover",
                {
                  ["terrain"] = self.terrain,
                  ["cannon"] = self.cannon,
                  ["target"] = self.target,
                  ["hasWon"] = true
                }
              )
            else
              local angle = 0
              local dangle = math.pi / math.floor(WINDOW_WIDTH / (r * 2) / 2)

              for i = 1, #self.terrain.points, 2 do
                if self.terrain.points[i] > x1 then
                  -- - 1 to work with love.math.triangulate
                  self.terrain.points[i + 1] =
                    math.min(WINDOW_HEIGHT - 1, self.terrain.points[i + 1] + math.sin(angle) * r)
                  angle = angle + dangle

                  if angle >= math.pi then
                    self.terrain:updatePolygon()
                    break
                  end
                end
              end
            end
          end

          if index + 2 >= #self.trajectory or indexStart + index + 2 >= #self.terrain.points then
            Timer:reset()

            self.cannonball = nil
          end
        end
      )
    end
  )
end
