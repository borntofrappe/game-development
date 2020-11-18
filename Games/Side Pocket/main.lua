require "src/Dependencies"

function love.load()
  love.window.setTitle("Side Pocket")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.02, 0.33, 0.12)

  isMoving = false
  isLaunching = false
  isGameover = false
  angle = math.pi

  isPlayerPocketed = false
  pocketedBalls = {}

  launcher = Launcher:new()
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

  local pocketsCoordinates = {
    {
      cx = surface.x + surface.lineWidth / 2,
      cy = surface.y + surface.lineWidth / 2
    },
    {
      cx = surface.x + surface.width / 2,
      cy = surface.y + surface.lineWidth / 2 - (surface.lineWidth - POCKET_RADIUS)
    },
    {
      cx = surface.x + surface.width - surface.lineWidth / 2,
      cy = surface.y + surface.lineWidth / 2
    },
    {
      cx = surface.x + surface.lineWidth / 2,
      cy = surface.y + surface.height - surface.lineWidth / 2
    },
    {
      cx = surface.x + surface.width / 2,
      cy = surface.y + surface.height - surface.lineWidth / 2 + (surface.lineWidth - POCKET_RADIUS)
    },
    {
      cx = surface.x + surface.width - surface.lineWidth / 2,
      cy = surface.y + surface.height - surface.lineWidth / 2
    }
  }

  pockets = {}

  for i, pocketsCoordinate in ipairs(pocketsCoordinates) do
    local body = love.physics.newBody(world, pocketsCoordinate.cx, pocketsCoordinate.cy)
    local shape = love.physics.newCircleShape(POCKET_RADIUS - POCKET_PADDING)
    local fixture = love.physics.newFixture(body, shape)
    fixture:setUserData("Pocket")
    fixture:setSensor(true)

    table.insert(
      pockets,
      {
        ["body"] = body,
        ["shape"] = shape,
        ["fixture"] = fixture
      }
    )
  end

  balls = initializeBalls()
  player = initializePlayer()
end

function initializePlayer()
  local player =
    Ball:new(
    {
      ["world"] = world,
      ["cx"] = surface.x + surface.width * 3 / 4,
      ["cy"] = surface.y + surface.height / 2,
      ["r"] = BALL_RADIUS,
      ["color"] = {
        ["r"] = 0.7,
        ["g"] = 0.7,
        ["b"] = 0.7
      }
    }
  )

  player.fixture:setUserData("Player")
  player.fixture:setRestitution(RESTITUTION)
  player.body:setLinearDamping(LINEAR_DAMPING)
  player.body:setMass(PLAYER_MASS)

  return player
end

function initializeBalls()
  local balls = {}

  local ballCounter = 1
  local ballX = surface.x + surface.width / 4
  local ballY = surface.y + surface.height / 2
  for i = 1, BALLS_COLUMNS do
    ballY = surface.y + surface.height / 2 - (i - 1) * BALL_RADIUS
    for j = 1, i do
      local number = ballCounter

      local ball =
        Ball:new(
        {
          ["world"] = world,
          ["cx"] = ballX,
          ["cy"] = ballY,
          ["r"] = BALL_RADIUS,
          ["number"] = number
        }
      )

      ball.fixture:setUserData("Ball")
      ball.fixture:setRestitution(RESTITUTION)
      ball.body:setLinearDamping(LINEAR_DAMPING)
      ball.body:setMass(BALL_MASS)

      table.insert(balls, ball)

      ballCounter = ballCounter + 1
      ballY = ballY + BALL_RADIUS * 2
    end
    ballX = ballX - BALL_RADIUS
  end

  return balls
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "space" then
    if not isMoving then
      if isLaunching then
        local impulseX = math.cos(angle) * IMPULSE
        local impulseY = math.sin(angle) * IMPULSE
        player.body:applyLinearImpulse(impulseX, impulseY)

        isMoving = true
        isLaunching = false
      else
        isLaunching = true
      end
    end
  end

  if key == "t" or key == "T" then
    for i, ball in ipairs(balls) do
      ball:toggleNumber()
    end
  end

  if key == "return" and isGameover then
    isGameover = false
    angle = math.pi
    player.body:destroy()
    player = initializePlayer()
    balls = initializeBalls()
    pocketed:reset()
  end
end

function love.update(dt)
  world:update(dt)

  if isMoving then
    local vx, vy = player.body:getLinearVelocity()
    if math.abs(vx) + math.abs(vy) < SPEED_THRESHOLD then
      local areBallsNotMoving = true
      for i, ball in pairs(balls) do
        local vx, vy = ball.body:getLinearVelocity()
        if math.abs(vx) + math.abs(vy) > SPEED_THRESHOLD then
          areBallsNotMoving = false
          break
        end
      end
      if areBallsNotMoving then
        isMoving = false
        launcher:reset()
      end
    end

    if isPlayerPocketed then
      player.body:destroy()
      player = initializePlayer()
      isPlayerPocketed = false
    end

    if #pocketedBalls > 0 then
      for i, body in ipairs(pocketedBalls) do
        body:destroy()
      end
      pocketedBalls = {}

      for i = #balls, 1, -1 do
        if balls[i].body:isDestroyed() then
          pocketed:addBall(balls[i].number)
          table.remove(balls, i)
        end
      end

      if #balls == 0 then
        isGameover = true
      end
    end
  else
    player.body:setLinearVelocity(0, 0)
    for i, ball in pairs(balls) do
      ball.body:setLinearVelocity(0, 0)
    end

    if isLaunching then
      launcher:update(dt)
    end

    if angle > math.pi * 2 then
      angle = 0
    elseif angle < 0 then
      angle = math.pi * 2
    end

    if love.keyboard.isDown("up") then
      if angle ~= math.pi * 3 / 2 and angle ~= math.pi / 2 then
        if angle < math.pi * 3 / 2 and angle > math.pi / 2 then
          angle = angle + dt
        else
          angle = angle - dt
        end
      end
    elseif love.keyboard.isDown("right") then
      if angle ~= math.pi and angle ~= 0 then
        if angle > math.pi then
          angle = angle + dt
        else
          angle = angle - dt
        end
      end
    elseif love.keyboard.isDown("down") then
      if angle ~= math.pi * 3 / 2 and angle ~= math.pi / 2 then
        if angle > math.pi / 2 and angle < math.pi * 3 / 2 then
          angle = angle - dt
        else
          angle = angle + dt
        end
      end
    elseif love.keyboard.isDown("left") then
      if angle ~= math.pi and angle ~= 0 then
        if angle > math.pi then
          angle = angle - dt
        else
          angle = angle + dt
        end
      end
    end
  end
end

function love.draw()
  launcher:render()
  pocketed:render()
  surface:render()

  for i, pocket in ipairs(pockets) do
    love.graphics.setColor(0.1, 0.12, 0.12)
    love.graphics.circle("fill", pocket.body:getX(), pocket.body:getY(), pocket.shape:getRadius() + POCKET_PADDING)
  end

  for i, ball in ipairs(balls) do
    ball:render()
  end

  player:render()

  if not isMoving then
    love.graphics.setLineWidth(1)
    for i = 1, 4 do
      local x = player.body:getX() + math.cos(angle) * (BALL_RADIUS * 3 * i)
      local y = player.body:getY() + math.sin(angle) * (BALL_RADIUS * 3 * i)
      if
        x > surface.x + surface.lineWidth / 2 + BALL_RADIUS and
          x < surface.x + surface.width - surface.lineWidth / 2 - BALL_RADIUS and
          y > surface.y + surface.lineWidth / 2 + BALL_RADIUS and
          y < surface.y + surface.height - surface.lineWidth / 2 - BALL_RADIUS
       then
        love.graphics.setColor(0.9, 0.9, 0.9, 0.5)
        love.graphics.circle("line", x, y, BALL_RADIUS)
        love.graphics.setColor(0.9, 0.9, 0.9, 0.1)
        love.graphics.circle("fill", x, y, BALL_RADIUS)
      end
    end
  end

  if isGameover then
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.setFont(gFonts["big"])
    love.graphics.printf(
      string.upper("Congrats"),
      surface.x,
      surface.y + surface.height / 2 - gFonts["big"]:getHeight() / 2,
      surface.width,
      "center"
    )
  end

  -- for i, edge in ipairs(edges) do
  --   love.graphics.setLineWidth(2)
  --   love.graphics.setColor(0, 1, 1)
  --   love.graphics.line(edge.body:getWorldPoints(edge.shape:getPoints()))
  -- end
end

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
