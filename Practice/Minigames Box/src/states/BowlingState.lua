BowlingState = BaseState:new()

local BALL_SPEED = 1000
local ANGLE_SPEED = 70

function BowlingState:enter()
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

  self.ball = ball

  local pins = {}

  self.arrow = {
    ["x0"] = self.ball.x,
    ["y0"] = self.ball.y,
    ["x1"] = self.ball.r * 1.5,
    ["x2"] = self.ball.r * 1.5 + 30,
    ["flap"] = 10
  }

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

      table.insert(pins, pin)
    end
    rows = rows + 1
  end

  self.pins = pins

  local edges = {}
  edges.body = love.physics.newBody(world, 0, 0)
  edges.shape =
    love.physics.newChainShape(true, 0, 0, PLAYING_WIDTH, 0, PLAYING_WIDTH, PLAYING_HEIGHT, 0, PLAYING_HEIGHT)
  edges.fixture = love.physics.newFixture(edges.body, edges.shape)

  self.edges = edges

  self.world = world

  self.angle = 0
  self.directionAngle = math.random(2) == 1 and 1 or -1
end

function BowlingState:update(dt)
  if love.keyboard.waspressed("escape") then
    gStateMachine:change("start")
  end

  if love.keyboard.waspressed("return") and self.state == "launching" then
    local ix = math.cos(math.rad(self.angle)) * BALL_SPEED
    local iy = math.sin(math.rad(self.angle)) * BALL_SPEED
    self.ball.body:applyLinearImpulse(ix, iy)
    self.state = "launched"
  end

  if self.state == "launched" then
    self.world:update(dt)
  end

  if self.state == "launching" then
    self.angle = self.angle + ANGLE_SPEED * dt * self.directionAngle
    if self.angle >= 45 then
      self.angle = 45
      self.directionAngle = -1
    end

    if self.angle <= -45 then
      self.angle = -45
      self.directionAngle = 1
    end
  end
end

function BowlingState:render()
  love.graphics.setColor(0.95, 0.95, 0.95)

  love.graphics.circle("fill", self.ball.body:getX(), self.ball.body:getY(), self.ball.shape:getRadius())

  for i, pin in pairs(self.pins) do
    love.graphics.circle("fill", pin.body:getX(), pin.body:getY(), pin.shape:getRadius())
  end

  if self.state == "launching" then
    love.graphics.setLineWidth(4)
    love.graphics.translate(self.arrow.x0, self.arrow.y0)
    love.graphics.rotate(math.rad(self.angle))
    love.graphics.line(self.arrow.x1, 0, self.arrow.x2, 0)
    love.graphics.line(self.arrow.x2, 0, self.arrow.x2 - self.arrow.flap, -self.arrow.flap)
    love.graphics.line(self.arrow.x2, 0, self.arrow.x2 - self.arrow.flap, self.arrow.flap)
  end
end
