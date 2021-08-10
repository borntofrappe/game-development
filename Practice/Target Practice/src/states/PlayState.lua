PlayState = BaseState:new()

local TWEEN_ANGLE = 0.25
local INTERVAL_CANNONBALL = 0.01

local GUI_WHITESPACE = 8
local GUI_PADDING = 10
local GUI_BUTTON_SIZE = 38

function PlayState:enter(params)
  if params and params.reset then
    gTerrain = Terrain:new()
    gCannon = Cannon:new(gTerrain)
    gTarget = Target:new(gTerrain)
  end

  self.cannonball = nil

  self.angle = gCannon.angle
  self.velocity = gCannon.velocity

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
    gStateMachine:change(
      "start",
      {
        ["reset"] = true
      }
    )
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

  gCannon:render()
  gTerrain:render()
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
  local a = gCannon.angle
  local v = gCannon.velocity
  local x = gCannon.body.x + gCannon.body.width * math.cos(math.rad(gCannon.angle))
  local y = gCannon.body.y - gCannon.body.width * math.sin(math.rad(gCannon.angle))

  local points = {}
  local theta = math.rad(a)

  local t = 0
  local dt = (gTerrain.points[3] - gTerrain.points[1]) / (v * math.cos(theta))

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
  gCannon.velocity = self.velocity

  self.cannonball = nil
  Timer:reset()

  local tweenAngle = gCannon.angle == self.angle and 0 or TWEEN_ANGLE

  Timer:tween(
    tweenAngle,
    {
      [gCannon] = {["angle"] = self.angle}
    },
    function()
      self.trajectory = self:getTrajectory()
      self.cannonball = Cannonball:new(gCannon)

      local index = 1

      local indexStart
      for i = 1, #gTerrain.points, 2 do
        if gTerrain.points[i] >= self.trajectory[1] then
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
          if self.trajectory[index + 1] + r > gTerrain.points[indexStart + index + 2] then
            Timer:reset()

            local x1 = self.cannonball.x - r
            local x2 = self.cannonball.x + r

            self.cannonball = nil

            if gCannon.wheel.x > x1 and gCannon.wheel.x < x2 then
              gStateMachine:change("gameover")
            elseif
              (x1 > gTarget.x and x1 < gTarget.x + gTarget.width) or (x2 > gTarget.x and x2 < gTarget.x + gTarget.width)
             then
              gStateMachine:change("victory")
            else
              local angle = 0
              local dangle = math.pi / math.floor(WINDOW_WIDTH / (r * 2) / 2)

              for i = 1, #gTerrain.points, 2 do
                if gTerrain.points[i] > x1 then
                  -- - 1 to work with love.math.triangulate
                  gTerrain.points[i + 1] = math.min(WINDOW_HEIGHT - 1, gTerrain.points[i + 1] + math.sin(angle) * r)
                  angle = angle + dangle

                  if angle >= math.pi then
                    gTerrain:updatePolygon()
                    break
                  end
                end
              end
            end
          end

          if index + 2 >= #self.trajectory or indexStart + index + 2 >= #gTerrain.points then
            Timer:reset()

            self.cannonball = nil
          end
        end,
        true
      )
    end
  )
end
