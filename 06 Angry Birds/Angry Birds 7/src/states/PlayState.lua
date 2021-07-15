PlayState = Class({__includes = BaseState})

local PLAYER_RADIUS = ALIEN_WIDTH / 2

function PlayState:init()
  local world = love.physics.newWorld(0, 300)

  local edges = {}
  for k, edge in pairs(EDGES) do
    local body = love.physics.newBody(world, edge.x1, edge.y1, "static")
    local shape = love.physics.newEdgeShape(0, 0, edge.x2 - edge.x1, edge.y2 - edge.y1)
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

  local player = {
    color = math.random(#gFrames["aliens"]),
    variety = 2
  }

  local target = {
    color = math.random(#gFrames["aliens"]),
    variety = math.random(2) == 1 and 1 or 3
  }

  player.body = love.physics.newBody(world, VIRTUAL_WIDTH / 4, VIRTUAL_HEIGHT / 2, "dynamic")
  player.shape = love.physics.newCircleShape(PLAYER_RADIUS)
  player.fixture = love.physics.newFixture(player.body, player.shape)
  player.fixture:setRestitution(0.8)

  target.body = love.physics.newBody(world, VIRTUAL_WIDTH * 3 / 4, VIRTUAL_HEIGHT / 2, "dynamic")
  target.shape = love.physics.newRectangleShape(ALIEN_WIDTH, ALIEN_HEIGHT)
  target.fixture = love.physics.newFixture(target.body, target.shape)
  target.fixture:setRestitution(0.5)

  self.world = world
  -- self.edges = edges
  self.player = player
  self.target = target
end

function PlayState:update(dt)
  if love.keyboard.wasPressed("escape") or love.mouse.wasPressed(2) then
    gStateMachine:change("start")
  end

  self.world:update(dt)

  self.world:setGravity(0, 300)

  if love.keyboard.wasPressed("left") then
    self.player.body:setLinearVelocity(-200, 0)
  elseif love.keyboard.wasPressed("right") then
    self.player.body:setLinearVelocity(200, 0)
  elseif love.keyboard.wasPressed("up") then
    self.world:setGravity(0, 0)
    self.player.body:setLinearVelocity(0, -200)
  end
end

function PlayState:render()
  love.graphics.setFont(gFonts["big"])
  love.graphics.setColor(0, 0, 0)
  love.graphics.printf("PlayState", 0, VIRTUAL_HEIGHT / 2 - 48, VIRTUAL_WIDTH, "center")

  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(
    gTextures["aliens"],
    gFrames["aliens"][self.player.color][self.player.variety],
    math.floor(self.player.body:getX()),
    math.floor(self.player.body:getY()),
    0,
    1,
    1,
    math.floor(PLAYER_RADIUS),
    math.floor(PLAYER_RADIUS)
  )

  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(
    gTextures["aliens"],
    gFrames["aliens"][self.target.color][self.target.variety],
    math.floor(self.target.body:getX()),
    math.floor(self.target.body:getY()),
    0,
    1,
    1,
    math.floor(ALIEN_WIDTH / 2),
    math.floor(ALIEN_HEIGHT / 2)
  )
end
