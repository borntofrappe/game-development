require "src/Dependencies"

function love.load()
  love.window.setTitle("Side Pocket")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  launcher = Launcher:new()
  pocketed = Pocketed:new({6, 2, 3, 5, 8})
  surface =
    Panel:new(
    {
      ["x"] = 16,
      ["y"] = WINDOW_HEIGHT / 3 + 28,
      ["width"] = WINDOW_WIDTH - 32,
      ["height"] = WINDOW_HEIGHT - (WINDOW_HEIGHT / 3 + 42),
      ["lineWidth"] = 20,
      ["rx"] = 24
    }
  )

  love.physics.setMeter(METER)
  world = love.physics.newWorld(0, 0, true)

  local border = {
    {
      x1 = 26,
      y1 = WINDOW_HEIGHT / 3 + 38,
      x2 = 16 + WINDOW_WIDTH - 42,
      y2 = WINDOW_HEIGHT / 3 + 38
    },
    {
      x1 = 16 + WINDOW_WIDTH - 42,
      y1 = WINDOW_HEIGHT / 3 + 38,
      x2 = 16 + WINDOW_WIDTH - 42,
      y2 = WINDOW_HEIGHT / 3 + 28 + WINDOW_HEIGHT - (WINDOW_HEIGHT / 3 + 42) - 10
    },
    {
      x1 = 16 + WINDOW_WIDTH - 42,
      y1 = WINDOW_HEIGHT / 3 + 28 + WINDOW_HEIGHT - (WINDOW_HEIGHT / 3 + 42) - 10,
      x2 = 26,
      y2 = WINDOW_HEIGHT / 3 + 28 + WINDOW_HEIGHT - (WINDOW_HEIGHT / 3 + 42) - 10
    },
    {
      x1 = 26,
      y1 = WINDOW_HEIGHT / 3 + 28 + WINDOW_HEIGHT - (WINDOW_HEIGHT / 3 + 42) - 10,
      x2 = 26,
      y2 = WINDOW_HEIGHT / 3 + 38
    }
  }
  edges = {}
  for i, segment in ipairs(border) do
    local body = love.physics.newBody(world, segment.x1, segment.y1)
    local shape = love.physics.newEdgeShape(0, 0, segment.x2 - segment.x1, segment.y2 - segment.y1)
    local fixture = love.physics.newFixture(body, shape)

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
      cx = 32,
      cy = WINDOW_HEIGHT / 3 + 44
    },
    {
      cx = 16 + (16 + WINDOW_WIDTH - 48) / 2,
      cy = WINDOW_HEIGHT / 3 + 44
    },
    {
      cx = 16 + WINDOW_WIDTH - 48,
      cy = WINDOW_HEIGHT / 3 + 44
    },
    {
      cx = 16 + WINDOW_WIDTH - 48,
      cy = WINDOW_HEIGHT / 3 + 28 + WINDOW_HEIGHT - (WINDOW_HEIGHT / 3 + 42) - 16
    },
    {
      cx = 16 + (16 + WINDOW_WIDTH - 48) / 2,
      cy = WINDOW_HEIGHT / 3 + 28 + WINDOW_HEIGHT - (WINDOW_HEIGHT / 3 + 42) - 16
    },
    {
      cx = 32,
      cy = WINDOW_HEIGHT / 3 + 28 + WINDOW_HEIGHT - (WINDOW_HEIGHT / 3 + 42) - 16
    }
  }

  pockets = {}

  for i, hole in ipairs(holes) do
    local body = love.physics.newBody(world, hole.cx, hole.cy)
    local shape = love.physics.newCircleShape(POCKET_RADIUS)
    local fixture = love.physics.newFixture(body, shape)

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
  for i = 1, 3 do
    ballY = surface.y + surface.height / 2 - (i - 1) * (BALL_RADIUS * 1.5)
    for j = 1, i do
      local body = love.physics.newBody(world, ballX, ballY, "dynamic")
      local shape = love.physics.newCircleShape(BALL_RADIUS)
      local fixture = love.physics.newFixture(body, shape)
      table.insert(
        balls,
        {
          ["body"] = body,
          ["shape"] = shape,
          ["fixture"] = fixture
        }
      )
      ballY = ballY + (BALL_RADIUS * 1.5) * 2
    end
    ballX = ballX - BALL_RADIUS * 2
  end

  player = {}
  player.body =
    love.physics.newBody(world, surface.x + surface.width * 3 / 4, surface.y + surface.height / 2, "dynamic")
  player.shape = love.physics.newCircleShape(BALL_RADIUS)
  player.fixture = love.physics.newFixture(player.body, player.shape)
  player.fixture:setRestitution(0.65)

  isLaunching = false
  force = 0
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
  if key == "space" then
    if isLaunching then
      -- launch
      force = FORCE_MULTIPLIER * launcher:getValue() / 100
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
end

function love.draw()
  launcher:render()
  pocketed:render()
  surface:render()

  love.graphics.setColor(0.3, 0.3, 0.3)
  love.graphics.circle("fill", player.body:getX(), player.body:getY(), player.shape:getRadius())

  for i, ball in ipairs(balls) do
    love.graphics.circle("fill", ball.body:getX(), ball.body:getY(), ball.shape:getRadius())
  end

  for i, pocket in ipairs(pockets) do
    love.graphics.circle("fill", pocket.body:getX(), pocket.body:getY(), pocket.shape:getRadius())
  end

  -- for i, edge in ipairs(edges) do
  --   love.graphics.setLineWidth(2)
  --   love.graphics.setColor(0, 1, 0.2)
  --   love.graphics.line(edge.body:getWorldPoints(edge.shape:getPoints()))
  -- end
end
