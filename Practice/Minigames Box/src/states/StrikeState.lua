StrikeState = BaseState:new()

local BALL_SPEED = 1000
local ANGLE_SPEED = 70
local ANGLE_MIN = -45
local ANGLE_MAX = 45

function StrikeState:enter()
  self.timer = COUNTDOWN_LEVEL
  self.hasWon = false
  self.state = "launching"

  local world = love.physics.newWorld(0, 0)

  local ball = {
    ["x"] = PLAYING_WIDTH / 4,
    ["y"] = PLAYING_HEIGHT / 2,
    ["r"] = 20
  }

  ball.body = love.physics.newBody(world, ball.x, ball.y, "dynamic")
  ball.body:setLinearDamping(1)
  ball.shape = love.physics.newCircleShape(ball.r)
  ball.fixture = love.physics.newFixture(ball.body, ball.shape)
  ball.fixture:setRestitution(0.5)
  ball.fixture:setFriction(1)
  ball.fixture:setUserData("ball")

  self.ball = ball

  self.arrow = {
    ["x0"] = self.ball.x,
    ["y0"] = self.ball.y,
    ["x1"] = self.ball.r * 1.5,
    ["x2"] = self.ball.r * 1.5 + 30,
    ["flap"] = 10
  }

  local pins = {}

  local columns = 3
  local rows = 1
  local r = 10
  local xStart = PLAYING_WIDTH * 3 / 4
  local yStart = PLAYING_HEIGHT / 2
  for column = 1, columns do
    for row = 1, rows do
      local pin = {
        ["x"] = xStart + (column - (columns - 1) / 2 - 1) * r * 2.5,
        ["y"] = yStart + (row - (rows - 1) / 2 - 1) * r * 2.5,
        ["r"] = r
      }

      pin.body = love.physics.newBody(world, pin.x, pin.y, "dynamic")
      pin.body:setLinearDamping(1)
      pin.shape = love.physics.newCircleShape(pin.r)
      pin.fixture = love.physics.newFixture(pin.body, pin.shape)
      pin.fixture:setRestitution(0.5)
      pin.fixture:setUserData("pin-c" .. column .. "-r" .. row)

      table.insert(pins, pin)
    end
    rows = rows + 1
  end

  local struckPins = {}
  for _, pin in ipairs(pins) do
    struckPins[pin.fixture:getUserData()] = false
  end

  self.pins = pins

  local walls = {}
  walls.body = love.physics.newBody(world, 0, 0)
  walls.shape =
    love.physics.newChainShape(true, 0, 0, PLAYING_WIDTH, 0, PLAYING_WIDTH, PLAYING_HEIGHT, 0, PLAYING_HEIGHT)
  walls.fixture = love.physics.newFixture(walls.body, walls.shape)
  walls.fixture:setUserData("walls")

  self.walls = walls

  world:setCallbacks(
    function(fixture1, fixture2)
      if self.hasWon then
        return
      end

      local userData = {fixture1:getUserData(), fixture2:getUserData()}
      for _, data in ipairs(userData) do
        if data:sub(1, 3) == "pin" and not struckPins[data] then
          struckPins[data] = true

          local hasWon = true
          for _, struckPin in pairs(struckPins) do
            if not struckPin then
              hasWon = false
              break
            end
          end

          if hasWon then
            self.hasWon = hasWon
          end
        end
      end
    end
  )

  self.world = world

  self.angle = math.random(ANGLE_MIN, ANGLE_MAX)
  self.directionAngle = math.random(2) == 1 and 1 or -1
end

function StrikeState:update(dt)
  self.timer = math.max(0, self.timer - dt)

  if self.timer == 0 then
    gStateMachine:change(
      "feedback",
      {
        ["hasWon"] = self.hasWon
      }
    )
  end

  if love.mouse.waspressed(1) and self.state == "launching" then
    local x, y = love.mouse:getPosition()
    if
      x > WINDOW_PADDING and x < WINDOW_WIDTH - WINDOW_PADDING and y > WINDOW_PADDING and
        y < WINDOW_HEIGHT - WINDOW_PADDING
     then
      local ix = math.cos(math.rad(self.angle)) * BALL_SPEED
      local iy = math.sin(math.rad(self.angle)) * BALL_SPEED
      self.ball.body:applyLinearImpulse(ix, iy)
      self.state = "launched"
    end
  end

  if self.state == "launched" then
    self.world:update(dt)
  end

  if self.state == "launching" then
    self.angle = self.angle + ANGLE_SPEED * dt * self.directionAngle
    if self.angle >= ANGLE_MAX then
      self.angle = ANGLE_MAX
      self.directionAngle = -1
    end

    if self.angle <= ANGLE_MIN then
      self.angle = ANGLE_MIN
      self.directionAngle = 1
    end
  end
end

function StrikeState:render()
  love.graphics.setColor(0.28, 0.25, 0.18)
  love.graphics.rectangle(
    "fill",
    0,
    PLAYING_HEIGHT - COUNTDOWN_LEVEL_BAR_HEIGHT,
    PLAYING_WIDTH * self.timer / COUNTDOWN_LEVEL,
    COUNTDOWN_LEVEL_BAR_HEIGHT
  )

  love.graphics.setColor(0.38, 0.35, 0.27)
  love.graphics.circle("fill", self.ball.body:getX(), self.ball.body:getY(), self.ball.shape:getRadius())
  love.graphics.setColor(0.28, 0.25, 0.18)
  love.graphics.setLineWidth(4)
  love.graphics.circle("line", self.ball.body:getX(), self.ball.body:getY(), self.ball.shape:getRadius())

  love.graphics.setColor(0.38, 0.35, 0.27)
  love.graphics.setLineWidth(1)
  for i, pin in pairs(self.pins) do
    love.graphics.circle("line", pin.x, pin.y, pin.r * 0.8)
    love.graphics.circle("fill", pin.body:getX(), pin.body:getY(), pin.shape:getRadius())
  end

  if self.state == "launching" then
    love.graphics.setColor(0.28, 0.25, 0.18)
    love.graphics.setLineWidth(4)
    love.graphics.translate(self.arrow.x0, self.arrow.y0)
    love.graphics.rotate(math.rad(self.angle))
    love.graphics.line(self.arrow.x1, 0, self.arrow.x2, 0)
    love.graphics.line(self.arrow.x2, 0, self.arrow.x2 - self.arrow.flap, -self.arrow.flap)
    love.graphics.line(self.arrow.x2, 0, self.arrow.x2 - self.arrow.flap, self.arrow.flap)
  end
end
