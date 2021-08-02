PlayState = BaseState:new()

function PlayState:enter()
  local world = love.physics.newWorld(0, 0)

  local balls = {}

  local r = BALL_SIZE

  local xStart = TABLE_INNER_WIDTH * 3 / 4
  local yStart = TABLE_INNER_HEIGHT / 2

  for i = 1, 6 do
    local angle = math.rad((i - 1) * 360 / 6 - 90)

    local x = xStart + math.cos(angle) * r * 2
    local y = yStart + math.sin(angle) * r * 2

    table.insert(
      balls,
      {
        ["number"] = #balls + 1,
        ["x"] = x,
        ["y"] = y,
        ["r"] = r,
        ["color"] = {
          ["r"] = math.random() ^ 0.35,
          ["g"] = math.random() ^ 0.35,
          ["b"] = math.random() ^ 0.35
        }
      }
    )
  end

  table.insert(
    balls,
    {
      ["number"] = #balls + 1,
      ["x"] = xStart,
      ["y"] = yStart,
      ["r"] = r,
      ["color"] = {
        ["r"] = math.random() ^ 0.35,
        ["g"] = math.random() ^ 0.35,
        ["b"] = math.random() ^ 0.35
      }
    }
  )

  for _, ball in ipairs(balls) do
    ball.body = love.physics.newBody(world, ball.x, ball.y, "dynamic")
    ball.shape = love.physics.newCircleShape(ball.r)
    ball.fixture = love.physics.newFixture(ball.body, ball.shape)
    ball.body:setLinearDamping(1)
    ball.fixture:setRestitution(0.5)
    ball.fixture:setFriction(0.7)
    ball.fixture:setDensity(0.8)
  end

  self.balls = balls

  local ball = {
    ["x"] = TABLE_INNER_WIDTH / 4,
    ["y"] = TABLE_INNER_HEIGHT / 2,
    ["r"] = r
  }

  ball.body = love.physics.newBody(world, ball.x, ball.y, "dynamic")
  ball.shape = love.physics.newCircleShape(ball.r)
  ball.fixture = love.physics.newFixture(ball.body, ball.shape)
  ball.body:setLinearDamping(1)
  ball.fixture:setFriction(0.7)
  ball.fixture:setRestitution(0.5)

  self.ball = ball

  local pocketsCoords = {
    {POCKET_PADDING, POCKET_PADDING},
    {TABLE_WIDTH - POCKET_PADDING, POCKET_PADDING},
    {TABLE_WIDTH / 2, POCKET_RADIUS},
    {TABLE_WIDTH / 2, TABLE_HEIGHT - POCKET_RADIUS},
    {TABLE_WIDTH - POCKET_PADDING, TABLE_HEIGHT - POCKET_PADDING},
    {POCKET_PADDING, TABLE_HEIGHT - POCKET_PADDING}
  }

  local pockets = {}
  for _, pocketCoords in ipairs(pocketsCoords) do
    local pocket = {
      ["x"] = pocketCoords[1],
      ["y"] = pocketCoords[2],
      ["r"] = POCKET_RADIUS
    }

    pocket.body = love.physics.newBody(world, pocket.x, pocket.y)
    pocket.shape = love.physics.newCircleShape(pocket.r)
    pocket.fixture = love.physics.newFixture(pocket.body, pocket.shape)
    pocket.fixture:setSensor(true)

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

  self.poolTable = poolTable

  local canvas = love.graphics.newCanvas()
  love.graphics.setCanvas(canvas)
  love.graphics.translate(TABLE_MARGIN, TABLE_MARGIN)

  love.graphics.setLineWidth(TABLE_LINE_WIDTH)
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("line", 0, 0, TABLE_WIDTH, TABLE_HEIGHT, 24)
  love.graphics.rectangle("line", TABLE_PADDING, TABLE_PADDING, TABLE_INNER_WIDTH, TABLE_INNER_HEIGHT)

  for _, pocket in ipairs(pockets) do
    love.graphics.circle("line", pocket.x, pocket.y, pocket.r)
  end

  love.graphics.setColor(0.18, 0.18, 0.19)
  love.graphics.setLineWidth(TABLE_PADDING - TABLE_LINE_WIDTH)
  love.graphics.rectangle(
    "line",
    TABLE_PADDING / 2,
    TABLE_PADDING / 2,
    TABLE_INNER_WIDTH + TABLE_PADDING,
    TABLE_INNER_HEIGHT + TABLE_PADDING,
    20
  )

  for _, pocket in ipairs(pockets) do
    love.graphics.circle("fill", pocket.x, pocket.y, POCKET_INNER_RADIUS)
  end

  love.graphics.setCanvas()

  self.canvas = canvas

  self.world = world
end

function PlayState:update(dt)
  self.world:update(dt)

  if love.keyboard.waspressed("escape") then
    gStateMachine:change("start")
  end

  if love.keyboard.isDown("return") then
    self.ball.body:applyLinearImpulse(60, math.random(-1, 1))
  end
end

function PlayState:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(self.canvas)

  love.graphics.translate(TABLE_MARGIN, TABLE_MARGIN)
  love.graphics.translate(TABLE_PADDING, TABLE_PADDING)

  love.graphics.setLineWidth(4)
  for _, ball in ipairs(self.balls) do
    love.graphics.setColor(ball.color.r, ball.color.g, ball.color.b)
    love.graphics.circle("line", ball.body:getX(), ball.body:getY(), ball.shape:getRadius() - 2)
  end

  love.graphics.setColor(1, 1, 1)
  love.graphics.circle("fill", self.ball.body:getX(), self.ball.body:getY(), self.ball.shape:getRadius() - 2)
end
