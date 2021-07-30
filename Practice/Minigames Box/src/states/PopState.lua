PopState = BaseState:new()

local GRAVITY = 200
local WEIGHT_LINEAR_VELOCITY = {
  ["y"] = 100,
  ["x"] = {-60, 60}
}
local BALLOON_FORCE = GRAVITY * 1.3

function PopState:enter()
  local world = love.physics.newWorld(0, GRAVITY)

  local balloons = {}

  local yMin = math.floor(PLAYING_HEIGHT / 3)
  local yMax = math.floor(PLAYING_HEIGHT / 1.5)

  local n = 3
  local r = 25
  for i = 1, n do
    local y = math.random(yMin, yMax)
    local balloon = {
      ["x"] = PLAYING_WIDTH / 2 + (i - (n + 1) / 2) * r * 2.5,
      ["y"] = y,
      ["r"] = r
    }

    balloon.body = love.physics.newBody(world, balloon.x, balloon.y, "dynamic")
    balloon.shape = love.physics.newCircleShape(balloon.r)
    balloon.fixture = love.physics.newFixture(balloon.body, balloon.shape)
    balloon.fixture:setRestitution(0.5)

    balloon.force = balloon.body:getMass() * BALLOON_FORCE * -1 -- mass * gravity to have the balloon stand still
    table.insert(balloons, balloon)
  end

  self.balloons = balloons

  local size = 40
  local weight = {
    ["x"] = PLAYING_WIDTH / 2 - 20,
    ["y"] = PLAYING_HEIGHT - size - 20,
    ["size"] = size
  }

  weight.body = love.physics.newBody(world, weight.x + weight.size / 2, weight.y + weight.size / 2, "dynamic")
  weight.shape = love.physics.newRectangleShape(weight.size, weight.size)
  weight.fixture = love.physics.newFixture(weight.body, weight.shape)
  weight.body:setLinearVelocity(
    math.random(WEIGHT_LINEAR_VELOCITY.x[1], WEIGHT_LINEAR_VELOCITY.x[2]),
    WEIGHT_LINEAR_VELOCITY.y
  )

  self.weight = weight

  local joints = {}
  for _, balloon in ipairs(balloons) do
    local body1 = balloon.body
    local body2 = weight.body

    local x1 = body1:getX()
    local y1 = body1:getY()

    local x2 = body2:getX()
    local y2 = body2:getY()

    local joint = love.physics.newDistanceJoint(body1, body2, x1, y1, x2, y2)

    table.insert(joints, joint)
  end

  self.joints = joints

  local walls = {}
  walls.body = love.physics.newBody(world, 0, 0)
  walls.shape =
    love.physics.newChainShape(false, 0, 0, 0, PLAYING_HEIGHT, PLAYING_WIDTH, PLAYING_HEIGHT, PLAYING_WIDTH, 0)
  walls.fixture = love.physics.newFixture(walls.body, walls.shape)
  walls.fixture:setUserData("walls")

  self.walls = walls

  self.world = world
end

function PopState:update(dt)
  for _, balloon in ipairs(self.balloons) do
    balloon.body:applyForce(0, balloon.force)
  end

  self.world:update(dt)
end

function PopState:render()
  love.graphics.setColor(0.95, 0.95, 0.95)
  love.graphics.setLineWidth(1)
  for _, joint in ipairs(self.joints) do
    local x1, y1, x2, y2 = joint:getAnchors()
    love.graphics.line(x1, y1, x2, y2)
  end

  for _, balloon in ipairs(self.balloons) do
    love.graphics.circle("fill", balloon.body:getX(), balloon.body:getY(), balloon.shape:getRadius())
  end

  love.graphics.polygon("fill", self.weight.body:getWorldPoints(self.weight.shape:getPoints()))
end
