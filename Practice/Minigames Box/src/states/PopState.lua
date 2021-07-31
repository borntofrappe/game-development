PopState = BaseState:new()

local GRAVITY = 200
local WEIGHT_LINEAR_VELOCITY = {
  ["y"] = 50,
  ["x"] = {-60, 60}
}
local BALLOON_FORCE = GRAVITY * 1.5

function PopState:enter()
  self.timer = COUNTDOWN_LEVEL
  self.hasWon = false

  local world = love.physics.newWorld(0, GRAVITY)

  local size = 40
  local weight = {
    ["size"] = size
  }
  weight.x = PLAYING_WIDTH / 2 - weight.size / 2
  weight.y = PLAYING_HEIGHT - weight.size * 1.5

  weight.body = love.physics.newBody(world, weight.x + weight.size / 2, weight.y + weight.size / 2, "dynamic")
  weight.shape = love.physics.newRectangleShape(weight.size, weight.size)
  weight.fixture = love.physics.newFixture(weight.body, weight.shape)
  weight.body:setLinearVelocity(
    math.random(WEIGHT_LINEAR_VELOCITY.x[1], WEIGHT_LINEAR_VELOCITY.x[2]),
    WEIGHT_LINEAR_VELOCITY.y
  )
  weight.fixture:setRestitution(0.25)

  self.weight = weight

  local balloons = {}

  local yMin = math.floor(PLAYING_HEIGHT / 3)
  local yMax = math.floor(PLAYING_HEIGHT / 1.5)

  local n = math.random(2, 5)
  local r = math.random(20, 25)
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

    balloon.joint =
      love.physics.newDistanceJoint(
      balloon.body,
      weight.body,
      balloon.body:getX(),
      balloon.body:getY(),
      weight.body:getX(),
      weight.body:getY()
    )

    table.insert(balloons, balloon)
  end

  self.balloons = balloons

  local walls = {}
  walls.body = love.physics.newBody(world, 0, 0)
  walls.shape =
    love.physics.newChainShape(true, 0, 0, PLAYING_WIDTH, 0, PLAYING_WIDTH, PLAYING_HEIGHT, 0, PLAYING_HEIGHT)
  walls.fixture = love.physics.newFixture(walls.body, walls.shape)
  walls.fixture:setUserData("walls")

  self.walls = walls

  self.world = world
end

function PopState:update(dt)
  self.timer = math.max(0, self.timer - dt)

  if self.timer == 0 then
    gStateMachine:change(
      "feedback",
      {
        ["hasWon"] = self.hasWon
      }
    )
  end

  for _, balloon in ipairs(self.balloons) do
    balloon.body:applyForce(0, balloon.force)
  end

  self.world:update(dt)

  if love.mouse.waspressed(1) and not self.hasWon then
    local mouseX, mouseY = love.mouse:getPosition()

    for i, balloon in ipairs(self.balloons) do
      local x = balloon.body:getX()
      local y = balloon.body:getY()
      local r = balloon.shape:getRadius()
      if ((mouseX - WINDOW_PADDING) - x) ^ 2 + ((mouseY - WINDOW_PADDING) - y) ^ 2 < r ^ 2 then
        balloon.joint:destroy()
        balloon.body:destroy()
        table.remove(self.balloons, i)

        if #self.balloons == 0 then
          self.hasWon = true
        end
        break
      end
    end
  end
end

function PopState:render()
  love.graphics.setColor(0.28, 0.25, 0.18)
  love.graphics.rectangle(
    "fill",
    0,
    PLAYING_HEIGHT - COUNTDOWN_LEVEL_BAR_HEIGHT,
    PLAYING_WIDTH * self.timer / COUNTDOWN_LEVEL,
    COUNTDOWN_LEVEL_BAR_HEIGHT
  )

  love.graphics.setColor(0.38, 0.35, 0.27)
  for _, balloon in ipairs(self.balloons) do
    love.graphics.setColor(0.38, 0.35, 0.27)

    love.graphics.setLineWidth(1)
    local x1, y1, x2, y2 = balloon.joint:getAnchors()
    love.graphics.line(x1, y1, x2, y2)

    love.graphics.circle("fill", balloon.body:getX(), balloon.body:getY(), balloon.shape:getRadius())
  end

  love.graphics.setColor(0.38, 0.35, 0.27)
  love.graphics.polygon("fill", self.weight.body:getWorldPoints(self.weight.shape:getPoints()))
  love.graphics.setColor(0.28, 0.25, 0.18)
  love.graphics.setLineWidth(4)
  love.graphics.polygon("line", self.weight.body:getWorldPoints(self.weight.shape:getPoints()))
end
