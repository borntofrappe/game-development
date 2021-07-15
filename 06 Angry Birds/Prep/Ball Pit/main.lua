local WINDOW_WIDTH = 640
local WINDOW_HEIGHT = 460

local GRAVITY_Y = 300

local BALL_RADIUS = 8
local BALLS_COLUMNS = math.floor(WINDOW_WIDTH / (BALL_RADIUS * 2))
local BALLS_ROWS = 10

local BOX_DENSITY = 15
local BOX_SIZE = 40
local BOX_INITIAL_VELOCITY_Y = -100

local world
local box
local balls
local edges

function love.load()
  math.randomseed(os.time())
  love.window.setTitle("Ball Pit")
  love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

  world = love.physics.newWorld(0, GRAVITY_Y)

  box = {}
  box.body = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 4, "dynamic")
  box.shape = love.physics.newRectangleShape(BOX_SIZE, BOX_SIZE)
  box.fixture = love.physics.newFixture(box.body, box.shape, BOX_DENSITY)
  box.body:setLinearVelocity(0, BOX_INITIAL_VELOCITY_Y)

  balls = {}
  for i = 1, BALLS_COLUMNS do
    for j = 1, BALLS_ROWS do
      local body =
        love.physics.newBody(
        world,
        BALL_RADIUS + i * BALL_RADIUS * 2,
        WINDOW_HEIGHT / 2 + j * BALL_RADIUS * 2,
        "dynamic"
      )
      local shape = love.physics.newCircleShape(BALL_RADIUS)
      local fixture = love.physics.newFixture(body, shape)

      table.insert(
        balls,
        {
          ["body"] = body,
          ["shape"] = shape,
          ["fixture"] = fixture,
          ["color"] = {
            ["r"] = math.random(),
            ["g"] = math.random(),
            ["b"] = math.random()
          }
        }
      )
    end
  end

  edges = {}
  edges[1] = {
    ["body"] = love.physics.newBody(world, 0, 0, "static"),
    ["shape"] = love.physics.newEdgeShape(0, 0, 0, WINDOW_HEIGHT)
  }
  edges[2] = {
    ["body"] = love.physics.newBody(world, 0, WINDOW_HEIGHT, "static"),
    ["shape"] = love.physics.newEdgeShape(0, 0, WINDOW_WIDTH, 0)
  }
  edges[3] = {
    ["body"] = love.physics.newBody(world, WINDOW_WIDTH, 0, "static"),
    ["shape"] = love.physics.newEdgeShape(0, 0, 0, WINDOW_HEIGHT)
  }
  edges[4] = {
    ["body"] = love.physics.newBody(world, 0, 0, "static"),
    ["shape"] = love.physics.newEdgeShape(0, 0, WINDOW_WIDTH, 0)
  }

  for k, edge in pairs(edges) do
    edge.fixture = love.physics.newFixture(edge.body, edge.shape)
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  elseif key == "r" or key == "space" then
    box.body:setPosition(math.random(BOX_SIZE, WINDOW_WIDTH - BOX_SIZE), WINDOW_HEIGHT / 4)
    box.body:setLinearVelocity(0, BOX_INITIAL_VELOCITY_Y)
  end
end

function love.update(dt)
  world:update(dt)
end

function love.draw()
  for k, ball in pairs(balls) do
    love.graphics.setColor(ball.color.r, ball.color.g, ball.color.b)
    love.graphics.circle("fill", ball.body:getX(), ball.body:getY(), ball.shape:getRadius())
  end

  love.graphics.setColor(0.94, 0.94, 0.94)
  love.graphics.polygon("fill", box.body:getWorldPoints(box.shape:getPoints()))
end
