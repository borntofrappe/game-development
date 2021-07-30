TiltState = BaseState:new()

local GRAVITY = 500
local ANGLE_SPEED = 2
local ANGLE_INITIAL = 2 -- degrees

function TiltState:enter()
  local world = love.physics.newWorld(0, GRAVITY)

  local platform = {
    ["width"] = 220,
    ["height"] = 8
  }
  platform.x = PLAYING_WIDTH / 2 - platform.width / 2
  platform.y = PLAYING_HEIGHT / 3 - platform.height / 2

  platform.body =
    love.physics.newBody(world, platform.x + platform.width / 2, platform.y + platform.height / 2, "kinematic")
  platform.shape = love.physics.newRectangleShape(platform.width, platform.height)
  platform.fixture = love.physics.newFixture(platform.body, platform.shape)
  platform.body:setAngle(math.random(2) == 1 and math.rad(ANGLE_INITIAL * -1) or math.rad(ANGLE_INITIAL))

  self.platform = platform

  local ball = {
    ["x"] = PLAYING_WIDTH / 2,
    ["r"] = 12
  }
  ball.y = platform.y - ball.r - 10

  ball.body = love.physics.newBody(world, ball.x, ball.y, "dynamic")
  ball.shape = love.physics.newCircleShape(ball.r)
  ball.fixture = love.physics.newFixture(ball.body, ball.shape)
  ball.body:setSleepingAllowed(false)
  ball.fixture:setRestitution(0.5)
  ball.fixture:setFriction(0.25)

  self.ball = ball

  local container = {
    ["lineWidth"] = 5,
    ["width"] = platform.width / 3,
    ["height"] = 100
  }

  container.x =
    math.random(2) == 1 and platform.x - container.width / 2 or platform.x + platform.width - container.width / 2
  container.y = PLAYING_HEIGHT - container.height - container.lineWidth / 2

  container.body = love.physics.newBody(world, container.x, container.y)
  container.shape =
    love.physics.newChainShape(false, 0, 0, 0, container.height, container.width, container.height, container.width, 0)
  container.fixture = love.physics.newFixture(container.body, container.shape)

  self.container = container

  local walls = {}
  walls.body = love.physics.newBody(world, 0, 0)
  walls.shape =
    love.physics.newChainShape(true, 0, 0, PLAYING_WIDTH, 0, PLAYING_WIDTH, PLAYING_HEIGHT, 0, PLAYING_HEIGHT)
  walls.fixture = love.physics.newFixture(walls.body, walls.shape)

  self.walls = walls

  self.world = world
end

function TiltState:update(dt)
  self.world:update(dt)

  if love.mouse.isDown(1) then
    local x = love.mouse:getPosition()
    if x > PLAYING_WIDTH / 2 then
      self.platform.body:setAngle(self.platform.body:getAngle() + ANGLE_SPEED * dt)
    else
      self.platform.body:setAngle(self.platform.body:getAngle() + ANGLE_SPEED * dt * -1)
    end
  end
end

function TiltState:render()
  love.graphics.setColor(0.95, 0.95, 0.95)
  love.graphics.polygon("fill", self.platform.body:getWorldPoints(self.platform.shape:getPoints()))

  love.graphics.circle("fill", self.ball.body:getX(), self.ball.body:getY(), self.ball.shape:getRadius())

  love.graphics.setLineWidth(self.container.lineWidth)
  love.graphics.line(self.container.body:getWorldPoints(self.container.shape:getPoints()))
end
