PlayState = BaseState:new()

local IMPULSE_BALL = 400

function PlayState:enter()
  self.state = "waiting"
  local world = love.physics.newWorld(0, 0)

  local balls = {}

  local r = BALL_SIZE

  local xStart = TABLE_INNER_WIDTH * 3 / 4
  local yStart = TABLE_INNER_HEIGHT / 2

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
      ["color"] = {
        ["r"] = math.random() ^ 0.2,
        ["g"] = math.random() ^ 0.8,
        ["b"] = math.random() ^ 0.8
      }
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
    ["color"] = {
      ["r"] = math.random() ^ 0.2,
      ["g"] = math.random() ^ 0.8,
      ["b"] = math.random() ^ 0.8
    }
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
    ["r"] = r
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
    ["angle"] = 180,
    ["offset"] = self.ball.r * 1.5
  }

  self.cue = cue

  local pocketsCoords = {
    {POCKET_PADDING, POCKET_PADDING},
    {TABLE_INNER_WIDTH - POCKET_PADDING, POCKET_PADDING},
    {TABLE_INNER_WIDTH / 2, 0},
    {TABLE_INNER_WIDTH / 2, TABLE_INNER_HEIGHT},
    {TABLE_INNER_WIDTH - POCKET_PADDING, TABLE_INNER_HEIGHT - POCKET_PADDING},
    {POCKET_PADDING, TABLE_INNER_HEIGHT - POCKET_PADDING}
  }

  local pockets = {}
  for _, pocketCoords in ipairs(pocketsCoords) do
    local pocket = {
      ["x"] = pocketCoords[1],
      ["y"] = pocketCoords[2],
      ["r"] = POCKET_RADIUS
    }

    pocket.body = love.physics.newBody(world, pocket.x, pocket.y)
    pocket.shape = love.physics.newCircleShape(pocket.r - 4)
    pocket.fixture = love.physics.newFixture(pocket.body, pocket.shape)
    pocket.fixture:setSensor(true)
    pocket.fixture:setUserData("pocket")

    table.insert(pockets, pocket)
  end

  self.pockets = pockets

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

  if love.keyboard.waspressed("escape") then
    gStateMachine:change("start")
  end

  if love.mouse.waspressed(1) and self.state == "waiting" then
    self.state = "playing"
    local ix = math.cos(math.rad(self.cue.angle)) * IMPULSE_BALL
    local iy = math.sin(math.rad(self.cue.angle)) * IMPULSE_BALL
    self.ball.body:applyLinearImpulse(ix * -1, iy * -1)
  end

  if self.state == "playing" then
    if self.ball.isPocketed then
      self.ball.isPocketed = false
      self.ball.body:setLinearVelocity(0, 0)
      self.ball.body:setX(self.ball.x)
      self.ball.body:setY(self.ball.y)
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
    if vx ^ 2 + vy ^ 2 < 8 then
      self.ball.body:setLinearVelocity(0, 0)
      self.state = "waiting"
    end
  elseif self.state == "waiting" then
    local x, y = love.mouse:getPosition()
    if x > 0 and x < WINDOW_WIDTH and y > 0 and y < WINDOW_HEIGHT then
      local dx = x - (TABLE_MARGIN + TABLE_PADDING) - self.ball.body:getX()
      local dy = y - (TABLE_MARGIN + TABLE_PADDING) - self.ball.body:getY()
      self.cue.angle = math.atan2(dy, dx) * 180 / math.pi
    end
  end
end

function PlayState:render()
  love.graphics.translate(TABLE_MARGIN, TABLE_MARGIN)

  love.graphics.setColor(1, 1, 1)
  love.graphics.setLineWidth(TABLE_LINE_WIDTH)
  love.graphics.rectangle("line", 0, 0, TABLE_WIDTH, TABLE_HEIGHT, 24)
  love.graphics.rectangle("line", TABLE_PADDING, TABLE_PADDING, TABLE_INNER_WIDTH, TABLE_INNER_HEIGHT)

  love.graphics.translate(TABLE_PADDING, TABLE_PADDING)
  for _, pocket in ipairs(self.pockets) do
    love.graphics.circle("line", pocket.x, pocket.y, pocket.r)
  end

  love.graphics.setColor(0.18, 0.18, 0.19)
  love.graphics.setLineWidth(TABLE_PADDING - TABLE_LINE_WIDTH)
  love.graphics.rectangle(
    "line",
    -TABLE_PADDING / 2,
    -TABLE_PADDING / 2,
    TABLE_INNER_WIDTH + TABLE_PADDING,
    TABLE_INNER_HEIGHT + TABLE_PADDING,
    20
  )
  for _, pocket in ipairs(self.pockets) do
    love.graphics.circle("fill", pocket.x, pocket.y, POCKET_INNER_RADIUS)
  end

  love.graphics.setLineWidth(BALL_LINE_WIDTH)
  for _, ball in pairs(self.balls) do
    love.graphics.setColor(ball.color.r, ball.color.g, ball.color.b)
    love.graphics.circle("line", ball.body:getX(), ball.body:getY(), ball.shape:getRadius() - BALL_LINE_WIDTH / 2)
  end

  love.graphics.setColor(1, 1, 1)
  love.graphics.circle("fill", self.ball.body:getX(), self.ball.body:getY(), self.ball.shape:getRadius())

  if self.state == "waiting" then
    love.graphics.setLineWidth(4)
    love.graphics.translate(self.ball.body:getX(), self.ball.body:getY())
    love.graphics.rotate(math.rad(self.cue.angle))
    love.graphics.translate(self.cue.offset, 0)
    love.graphics.line(0, 0, self.cue.length, 0)
  end
end
