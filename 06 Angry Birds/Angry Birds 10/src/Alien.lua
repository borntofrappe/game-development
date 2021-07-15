Alien = Class {}

function Alien:init(def)
  local world = def.world

  self.x = def.x
  self.y = def.y

  self.width = ALIEN_WIDTH
  self.height = ALIEN_HEIGHT

  self.type = def.type or "square"
  self.color = def.color or math.random(#gFrames["aliens"])
  self.variety = self.type == "square" and (math.random(2) == 1 and 1 or 3) or 2

  local body = love.physics.newBody(world, self.x, self.y, "dynamic")
  local shape =
    type == "square" and love.physics.newRectangleShape(self.width, self.height) or
    love.physics.newCircleShape((self.width) / 2)
  local fixture = love.physics.newFixture(body, shape)
  fixture:setUserData(self.type == "square" and "Target" or "Player")

  self.body = body
  self.shape = shape
  self.fixture = fixture
end

function Alien:render()
  love.graphics.draw(
    gTextures["aliens"],
    gFrames["aliens"][self.color][self.variety],
    math.floor(self.body:getX()),
    math.floor(self.body:getY()),
    self.body:getAngle(),
    1,
    1,
    math.floor(self.width / 2),
    math.floor(self.height / 2)
  )
end
