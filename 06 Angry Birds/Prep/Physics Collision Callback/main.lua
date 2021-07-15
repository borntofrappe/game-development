local WINDOW_WIDTH = 640
local WINDOW_HEIGHT = 460

local METER = 64
local GRAVITY = 9.81

local GROUND_HEIGHT = 100

local BALL_RADIUS = 18
local BALL_RESTITUTION = 0.95
local BALL_DENSITY = 1.5
local BALL_USER_DATA = "ball"

local BLOCK_WIDTH = 15
local BLOCK_HEIGHT = 120
local BLOCK_USER_DATA = "block"

local FORCE_X = 150
local FORCE_Y = 250

local world
local objects

local contactCounter
local contactPoints

function love.load()
  love.window.setTitle("Physics Collision Callbacks")
  love.graphics.setBackgroundColor(0.94, 0.94, 0.94)
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

  love.physics.setMeter(METER)

  world = love.physics.newWorld(0, GRAVITY * METER, false)
  objects = {}

  objects.ground = {}
  objects.ground.body = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT - GROUND_HEIGHT / 2)
  objects.ground.shape = love.physics.newRectangleShape(WINDOW_WIDTH, GROUND_HEIGHT)
  objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape)

  objects.ball = {}
  objects.ball.body = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, "dynamic")
  objects.ball.shape = love.physics.newCircleShape(BALL_RADIUS)
  objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, BALL_DENSITY)
  objects.ball.fixture:setRestitution(BALL_RESTITUTION)
  objects.ball.fixture:setUserData(BALL_USER_DATA)

  objects.block1 = {}
  objects.block1.body = love.physics.newBody(world, WINDOW_WIDTH / 4, WINDOW_HEIGHT / 2, "dynamic")
  objects.block1.shape = love.physics.newRectangleShape(BLOCK_WIDTH, BLOCK_HEIGHT)
  objects.block1.fixture = love.physics.newFixture(objects.block1.body, objects.block1.shape, 0.25)
  objects.block1.fixture:setUserData(BLOCK_USER_DATA)

  objects.block2 = {}
  objects.block2.body = love.physics.newBody(world, WINDOW_WIDTH * 3 / 4, WINDOW_HEIGHT / 2, "dynamic")
  objects.block2.shape = love.physics.newRectangleShape(BLOCK_WIDTH, BLOCK_HEIGHT)
  objects.block2.fixture = love.physics.newFixture(objects.block2.body, objects.block2.shape)
  objects.block2.fixture:setUserData(BLOCK_USER_DATA)

  contactCounter = 0
  contactPoints = {}
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  elseif key == "r" then
    objects.ball.body:setPosition(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
    objects.block1.body:setPosition(WINDOW_WIDTH / 4, WINDOW_HEIGHT / 2)
    objects.block2.body:setPosition(WINDOW_WIDTH * 3 / 4, WINDOW_HEIGHT / 2)
    objects.ball.body:setLinearVelocity(0, 0)
    objects.ball.body:setAngularVelocity(0)
    objects.block1.body:setLinearVelocity(0, 0)
    objects.block2.body:setLinearVelocity(0, 0)
    objects.block1.body:setAngle(0)
    objects.block2.body:setAngle(0)
    objects.block1.body:setAngularVelocity(0)
    objects.block2.body:setAngularVelocity(0)

    contactCounter = 0
    contactPoints = {}
  end
end

function love.update(dt)
  world:update(dt)
  world:setCallbacks(beginContact, endContact)

  if love.keyboard.isDown("left") then
    objects.ball.body:applyForce(-FORCE_X, 0)
  elseif love.keyboard.isDown("right") then
    objects.ball.body:applyForce(FORCE_X, 0)
  elseif love.keyboard.isDown("up") then
    objects.ball.body:applyForce(0, -FORCE_Y)
  end
end

function beginContact(f1, f2, contact)
  if
    (f1:getUserData() == BALL_USER_DATA or f1:getUserData() == BLOCK_USER_DATA) and
      (f2:getUserData() == BALL_USER_DATA or f2:getUserData() == BLOCK_USER_DATA)
   then
    contactCounter = contactCounter + 1
    local x, y = contact:getPositions()
    table.insert(
      contactPoints,
      {
        x = x,
        y = y
      }
    )
  end
end

function love.draw()
  love.graphics.setColor(0.3, 0.3, 0.3)
  love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape:getPoints()))

  love.graphics.polygon("fill", objects.block1.body:getWorldPoints(objects.block1.shape:getPoints()))
  love.graphics.polygon("fill", objects.block2.body:getWorldPoints(objects.block2.shape:getPoints()))

  love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())

  love.graphics.setColor(0.1, 0.1, 0.1)
  love.graphics.print("Contact counter: " .. contactCounter, 8, 8)
  love.graphics.print("Contact points", 8, 24)
  for i, v in ipairs(contactPoints) do
    love.graphics.print("(" .. v.x .. ", " .. v.y .. ")", 8, 40 + 16 * (i - 1))
  end
end
