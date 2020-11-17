require "src/Dependencies"

function beginContact(f1, f2)
  local fixtures = {}
  fixtures[f1:getUserData()] = true
  fixtures[f2:getUserData()] = true
  if fixtures["Ball"] and fixtures["Pocket"] then
    if f1:getUserData() == "Ball" then
      table.insert(pocketedBalls, f1:getBody())
    else
      table.insert(pocketedBalls, f2:getBody())
    end
  end

  if fixtures["Player"] and fixtures["Pocket"] then
    isPlayerPocketed = true
  end
end

function love.load()
  love.window.setTitle("Side Pocket")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  launcher = Launcher:new()
  pocketedBalls = {}
  pocketed = Pocketed:new()

  surface =
    Panel:new(
    {
      ["x"] = 18,
      ["y"] = WINDOW_HEIGHT / 3 + 30,
      ["width"] = WINDOW_WIDTH - 36,
      ["height"] = WINDOW_HEIGHT - (WINDOW_HEIGHT / 3 + 30 + 18),
      ["lineWidth"] = 24,
      ["rx"] = 18
    }
  )

  love.physics.setMeter(METER)
  world = love.physics.newWorld(0, 0, true)
  world:setCallbacks(beginContact)

  local border = {
    {
      x1 = surface.x + surface.lineWidth / 2,
      y1 = surface.y + surface.lineWidth / 2,
      x2 = surface.x + surface.width - surface.lineWidth / 2,
      y2 = surface.y + surface.lineWidth / 2
    },
    {
      x1 = surface.x + surface.width - surface.lineWidth / 2,
      y1 = surface.y + surface.lineWidth / 2,
      x2 = surface.x + surface.width - surface.lineWidth / 2,
      y2 = surface.y + surface.height - surface.lineWidth / 2
    },
    {
      x1 = surface.x + surface.width - surface.lineWidth / 2,
      y1 = surface.y + surface.height - surface.lineWidth / 2,
      x2 = surface.x + surface.lineWidth / 2,
      y2 = surface.y + surface.height - surface.lineWidth / 2
    },
    {
      x1 = surface.x + surface.lineWidth / 2,
      y1 = surface.y + surface.height - surface.lineWidth / 2,
      x2 = surface.x + surface.lineWidth / 2,
      y2 = surface.y + surface.lineWidth / 2
    }
  }
  edges = {}
  for i, segment in ipairs(border) do
    local body = love.physics.newBody(world, segment.x1, segment.y1)
    local shape = love.physics.newEdgeShape(0, 0, segment.x2 - segment.x1, segment.y2 - segment.y1)
    local fixture = love.physics.newFixture(body, shape)
    fixture:setUserData("Edge")
    table.insert(
      edges,
      {
        ["body"] = body,
        ["shape"] = shape,
        ["fixture"] = fixture
      }
    )
  end

  local holes = {
    {
      cx = surface.x + surface.lineWidth / 2 + 4,
      cy = surface.y + surface.lineWidth / 2 + 4
    },
    {
      cx = surface.x + surface.width / 2,
      cy = surface.y + surface.lineWidth / 2 - (surface.lineWidth - POCKET_RADIUS)
    },
    {
      cx = surface.x + surface.width - surface.lineWidth / 2 - 4,
      cy = surface.y + surface.lineWidth / 2 + 4
    },
    {
      cx = surface.x + surface.lineWidth / 2 + 4,
      cy = surface.y + surface.height - surface.lineWidth / 2 - 4
    },
    {
      cx = surface.x + surface.width / 2,
      cy = surface.y + surface.height - surface.lineWidth / 2 + (surface.lineWidth - POCKET_RADIUS)
    },
    {
      cx = surface.x + surface.width - surface.lineWidth / 2 - 4,
      cy = surface.y + surface.height - surface.lineWidth / 2 - 4
    }
  }

  pockets = {}

  for i, hole in ipairs(holes) do
    local body = love.physics.newBody(world, hole.cx, hole.cy)
    local shape = love.physics.newCircleShape(POCKET_RADIUS)
    local fixture = love.physics.newFixture(body, shape)
    fixture:setSensor(true)
    fixture:setUserData("Pocket")

    table.insert(
      pockets,
      {
        ["body"] = body,
        ["shape"] = shape,
        ["fixture"] = fixture
      }
    )
  end

  balls = {}
  local ballX = surface.x + surface.width / 4
  local ballY = surface.y + surface.height / 2
  for i = 1, 4 do
    ballY = surface.y + surface.height / 2 - (i - 1) * BALL_RADIUS
    for j = 1, i do
      local ball = Ball:new(world, ballX, ballY, BALL_RADIUS)
      ball.fixture:setRestitution(0.75)
      ball.fixture:setUserData("Ball")
      table.insert(balls, ball)

      ballY = ballY + BALL_RADIUS * 2
    end
    ballX = ballX - BALL_RADIUS
  end

  player = Ball:new(world, surface.x + surface.width * 3 / 4, surface.y + surface.height / 2, BALL_RADIUS)
  player.fixture:setRestitution(0.65)
  player.fixture:setUserData("Player")

  isLaunching = false
  isPlayerPocketed = false
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
  if key == "space" then
    if isLaunching then
      local force = FORCE_MULTIPLIER * launcher:getValue() / 100
      player.body:applyLinearImpulse(-force, 0)
      launcher:reset()

      isLaunching = false
    else
      isLaunching = true
    end
  end
end

function love.update(dt)
  world:update(dt)
  if isLaunching then
    launcher:update(dt)
  end

  if isPlayerPocketed then
    player.body:setPosition(surface.x + surface.width * 3 / 4, surface.y + surface.height / 2)

    isPlayerPocketed = false
  end

  if #pocketedBalls > 0 then
    for i, body in ipairs(pocketedBalls) do
      body:destroy()
    end
    pocketedBalls = {}

    for i = #balls, 1, -1 do
      if balls[i].body:isDestroyed() then
        pocketed:addBall(i)
        table.remove(balls, i)
      end
    end
  end
end

function love.draw()
  launcher:render()
  pocketed:render()
  surface:render()

  player:render()

  for i, ball in ipairs(balls) do
    ball:render()
  end

  for i, pocket in ipairs(pockets) do
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.circle("fill", pocket.body:getX(), pocket.body:getY(), pocket.shape:getRadius())
  end

  -- for i, edge in ipairs(edges) do
  --   love.graphics.setLineWidth(2)
  --   love.graphics.setColor(0, 1, 0.2)
  --   love.graphics.line(edge.body:getWorldPoints(edge.shape:getPoints()))
  -- end
end
