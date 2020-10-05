PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.player = {
    color = math.random(#gFrames["aliens"]),
    variety = 2
  }

  self.target = {
    color = math.random(#gFrames["aliens"]),
    variety = math.random(2) == 1 and 1 or 3
  }

  self.world = love.physics.newWorld(0, 300)

  self.edges = {}
  for k, edge in pairs(EDGES) do
    self.edges[k] = {}
    self.edges[k].body = love.physics.newBody(self.world, edge.x1, edge.y1, "static")
    self.edges[k].shape = love.physics.newEdgeShape(0, 0, edge.x2 - edge.x1, edge.y2 - edge.y1)
    self.edges[k].fixture = love.physics.newFixture(self.edges[k].body, self.edges[k].shape)
  end

  self.player.body = love.physics.newBody(self.world, VIRTUAL_WIDTH / 4, VIRTUAL_HEIGHT / 2, "dynamic")
  self.player.shape = love.physics.newCircleShape(PLAYER_RADIUS)
  self.player.fixture = love.physics.newFixture(self.player.body, self.player.shape)
  self.player.fixture:setRestitution(0.8)

  self.target.body = love.physics.newBody(self.world, VIRTUAL_WIDTH * 3 / 4, VIRTUAL_HEIGHT / 2, "dynamic")
  self.target.shape = love.physics.newRectangleShape(ALIEN_WIDTH, ALIEN_HEIGHT)
  self.target.fixture = love.physics.newFixture(self.target.body, self.target.shape)
  self.target.fixture:setRestitution(0.5)
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

  -- love.graphics.setColor(0, 1, 0)
  -- love.graphics.circle("fill", self.player.body:getX(), self.player.body:getY(), 2)
  -- love.graphics.circle("fill", self.target.body:getX(), self.target.body:getY(), 2)

  -- love.graphics.setColor(0, 1, 0)
  -- love.graphics.setLineWidth(PLAYER_RADIUS)
  -- for k, edge in pairs(self.edges) do
  --   love.graphics.line(edge.body:getWorldPoints(edge.shape:getPoints()))
  -- end
end
