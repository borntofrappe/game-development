PlayState = BaseState:new()

local IMPULSE_BALL = 400
local VELOCITY_MIN = 8

function PlayState:enter()
  self.state = "waiting"

  local world = love.physics.newWorld(0, 0)

  local balls = {}

  local xStart = TABLE_INNER_WIDTH * 3 / 4
  local yStart = TABLE_INNER_HEIGHT / 2
  local r = BALL_SIZE
  local keyPrefix = "ball"

  local i = 1
  while i <= 6 do
    local angle = math.rad((i - 1) * 360 / 6 - 90)

    local x = xStart + math.cos(angle) * r * 2
    local y = yStart + math.sin(angle) * r * 2

    local key = keyPrefix .. i
    balls[key] = {
      ["key"] = key,
      ["isPocketed"] = false,
      ["x"] = x,
      ["y"] = y,
      ["r"] = r,
      ["color"] = gColors.balls[i]
    }

    i = i + 1
  end

  local key = keyPrefix .. i
  balls[key] = {
    ["key"] = key,
    ["isPocketed"] = false,
    ["x"] = xStart,
    ["y"] = yStart,
    ["r"] = r,
    ["color"] = gColors.balls[i]
  }

  for _, ball in pairs(balls) do
    ball.body = love.physics.newBody(world, ball.x, ball.y, "dynamic")
    ball.shape = love.physics.newCircleShape(ball.r)
    ball.fixture = love.physics.newFixture(ball.body, ball.shape)
    ball.body:setLinearDamping(1)
    ball.fixture:setRestitution(0.75)
    ball.fixture:setUserData(ball.key)
  end

  self.balls = balls

  local ball = {
    ["key"] = keyPrefix,
    ["isPocketed"] = false,
    ["x"] = TABLE_INNER_WIDTH / 4,
    ["y"] = TABLE_INNER_HEIGHT / 2,
    ["r"] = r,
    ["color"] = gColors.balls[#gColors.balls]
  }

  ball.body = love.physics.newBody(world, ball.x, ball.y, "dynamic")
  ball.shape = love.physics.newCircleShape(ball.r)
  ball.fixture = love.physics.newFixture(ball.body, ball.shape)
  ball.body:setLinearDamping(1)
  ball.fixture:setRestitution(0.5)
  ball.fixture:setUserData(ball.key)

  self.ball = ball

  local cue = {
    ["length"] = CUE_LENGTH,
    ["offset"] = ball.r * 1.5
  }

  local angle = math.pi
  local x, y = love.mouse:getPosition()
  if x > 0 and x < WINDOW_WIDTH and y > 0 and y < WINDOW_HEIGHT then
    x = x - (TABLE_MARGIN + TABLE_PADDING)
    y = y - (TABLE_MARGIN + TABLE_PADDING)
    local dx = x - self.ball.body:getX()
    local dy = y - self.ball.body:getY()
    angle = math.atan2(dy, dx)
  end

  cue.angle = angle

  self.cue = cue

  for _, pocketCoords in ipairs(POCKET_COORDS) do
    local body = love.physics.newBody(world, pocketCoords[1], pocketCoords[2])
    local shape = love.physics.newCircleShape(POCKET_RADIUS * 0.8)
    local fixture = love.physics.newFixture(body, shape)
    fixture:setSensor(true)
    fixture:setUserData("pocket")
  end

  local poolTable = {
    ["x"] = 0,
    ["y"] = 0,
    ["width"] = TABLE_INNER_WIDTH,
    ["height"] = TABLE_INNER_HEIGHT
  }

  poolTable.body = love.physics.newBody(world, poolTable.x, poolTable.y)
  poolTable.shape =
    love.physics.newChainShape(
    true,
    poolTable.x,
    poolTable.y,
    poolTable.x + poolTable.width,
    poolTable.y,
    poolTable.x + poolTable.width,
    poolTable.y + poolTable.height,
    poolTable.x,
    poolTable.y + poolTable.height
  )
  poolTable.fixture = love.physics.newFixture(poolTable.body, poolTable.shape)
  poolTable.fixture:setFriction(0.75)
  poolTable.fixture:setUserData("table")

  self.poolTable = poolTable

  world:setCallbacks(
    function(fixture1, fixture2)
      if fixture1:getUserData() == "pocket" then
        if fixture2:getUserData() == keyPrefix then
          self.ball.isPocketed = true
        elseif fixture2:getUserData():sub(1, #keyPrefix) == keyPrefix then
          self.balls[fixture2:getUserData()].isPocketed = true
        end
      elseif fixture2:getUserData() == "pocket" then
        if fixture1:getUserData() == keyPrefix then
          self.ball.isPocketed = true
        elseif fixture1:getUserData():sub(1, #keyPrefix) == keyPrefix then
          self.balls[fixture1:getUserData()].isPocketed = true
        end
      end
    end
  )

  self.world = world
end

function PlayState:update(dt)
  self.world:update(dt)

  if love.mouse.waspressed(1) and self.state == "waiting" then
    self.state = "playing"
    local ix = math.cos(self.cue.angle) * IMPULSE_BALL * -1
    local iy = math.sin(self.cue.angle) * IMPULSE_BALL * -1
    self.ball.body:applyLinearImpulse(ix, iy)
  end

  if self.state == "playing" then
    if self.ball.isPocketed then
      self.ball.isPocketed = false
      self.ball.body:setLinearVelocity(0, 0)
      self.ball.body:setX(self.ball.x)
      self.ball.body:setY(self.ball.y)

      local x, y = love.mouse:getPosition()
      if x > 0 and x < WINDOW_WIDTH and y > 0 and y < WINDOW_HEIGHT then
        x = x - (TABLE_MARGIN + TABLE_PADDING)
        y = y - (TABLE_MARGIN + TABLE_PADDING)
        local dx = x - self.ball.body:getX()
        local dy = y - self.ball.body:getY()
        self.cue.angle = math.atan2(dy, dx)
      end
    end

    for k, ball in pairs(self.balls) do
      if ball.isPocketed then
        ball.body:destroy()
        self.balls[k] = nil

        local gameover = true
        for l, b in pairs(self.balls) do
          if b then
            gameover = false
            break
          end
        end
        if gameover then
          love.event.quit()
        else
          break
        end
      end
    end

    local vx, vy = self.ball.body:getLinearVelocity()
    if vx ^ 2 + vy ^ 2 < VELOCITY_MIN then
      local isMoving = false
      for _, ball in pairs(self.balls) do
        local vx, vy = ball.body:getLinearVelocity()
        if vx ^ 2 + vy ^ 2 > VELOCITY_MIN then
          isMoving = true
          break
        end
      end

      if not isMoving then
        self.ball.body:setLinearVelocity(0, 0)
        for _, ball in pairs(self.balls) do
          ball.body:setLinearVelocity(0, 0)
        end

        self.state = "waiting"
      end
    end
  elseif self.state == "waiting" then
    local x, y = love.mouse:getPosition()
    if x > 0 and x < WINDOW_WIDTH and y > 0 and y < WINDOW_HEIGHT then
      x = x - (TABLE_MARGIN + TABLE_PADDING)
      y = y - (TABLE_MARGIN + TABLE_PADDING)
      local dx = x - self.ball.body:getX()
      local dy = y - self.ball.body:getY()
      self.cue.angle = math.atan2(dy, dx)
    end
  end
end

function PlayState:render()
  for _, ball in pairs(self.balls) do
    love.graphics.setColor(ball.color.r, ball.color.g, ball.color.b)
    love.graphics.circle("fill", ball.body:getX(), ball.body:getY(), ball.shape:getRadius())
  end

  love.graphics.setColor(self.ball.color.r, self.ball.color.g, self.ball.color.b)
  love.graphics.circle("fill", self.ball.body:getX(), self.ball.body:getY(), self.ball.shape:getRadius())

  if self.state == "waiting" then
    love.graphics.setColor(gColors.ui.r, gColors.ui.g, gColors.ui.b)
    love.graphics.setLineWidth(CUE_LINE_WIDTH)
    love.graphics.translate(self.ball.body:getX(), self.ball.body:getY())
    love.graphics.rotate(self.cue.angle)
    love.graphics.translate(self.cue.offset, 0)
    love.graphics.line(0, 0, self.cue.length, 0)
  end
end
