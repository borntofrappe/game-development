WINDOW_WIDTH = 580
WINDOW_HEIGHT = 460
BALL_RADIUS = 8

function love.load()
  math.randomseed(os.time())
  love.window.setTitle("Ball Pit")

  world = love.physics.newWorld(0, 400)

  boxBody = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 4, "dynamic")
  boxShape = love.physics.newRectangleShape(40, 40)
  boxFixture = love.physics.newFixture(boxBody, boxShape, 15)

  balls = {}
  ballsCounter = 1
  for i = 1, math.floor(WINDOW_WIDTH / (BALL_RADIUS * 2)) do
    for j = 1, 10 do
      balls[ballsCounter] = {
        body = love.physics.newBody(
          world,
          BALL_RADIUS + i * BALL_RADIUS * 2,
          WINDOW_HEIGHT / 2 + j * BALL_RADIUS * 2,
          "dynamic"
        ),
        shape = love.physics.newCircleShape(BALL_RADIUS),
        color = {
          ["r"] = math.random(30, 90) / 100,
          ["g"] = math.random(30, 90) / 100,
          ["b"] = math.random(30, 90) / 100
        }
      }
      balls[ballsCounter].fixture = love.physics.newFixture(balls[ballsCounter].body, balls[ballsCounter].shape)

      ballsCounter = ballsCounter + 1
    end
  end

  pit = {}
  pit[1] = {
    body = love.physics.newBody(world, 0, 0, "static"),
    shape = love.physics.newEdgeShape(0, 0, 0, WINDOW_HEIGHT)
  }
  pit[2] = {
    body = love.physics.newBody(world, 0, WINDOW_HEIGHT, "static"),
    shape = love.physics.newEdgeShape(0, 0, WINDOW_WIDTH, 0)
  }
  pit[3] = {
    body = love.physics.newBody(world, WINDOW_WIDTH, 0, "static"),
    shape = love.physics.newEdgeShape(0, 0, 0, WINDOW_HEIGHT)
  }
  pit[4] = {
    body = love.physics.newBody(world, 0, 0, "static"),
    shape = love.physics.newEdgeShape(0, 0, WINDOW_WIDTH, 0)
  }
  for i, p in ipairs(pit) do
    p.fixture = love.physics.newFixture(p.body, p.shape)
  end

  love.graphics.setBackgroundColor(0.08, 0.08, 0.08)
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  elseif key == "space" then
    boxBody:setPosition(math.random(50, WINDOW_WIDTH - 50), WINDOW_HEIGHT / 4)
    boxBody:setLinearVelocity(0, 200)
  end
end

function love.update(dt)
  world:update(dt)
end

function love.draw()
  for i, ball in ipairs(balls) do
    love.graphics.setColor(ball.color.r, ball.color.g, ball.color.b)
    love.graphics.circle("fill", ball.body:getX(), ball.body:getY(), ball.shape:getRadius())
  end

  love.graphics.setColor(1, 1, 1)
  love.graphics.polygon("fill", boxBody:getWorldPoints(boxShape:getPoints()))
end
