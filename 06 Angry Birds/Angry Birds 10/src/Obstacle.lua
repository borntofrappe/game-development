Obstacle = Class {}

function Obstacle:init(def)
  local world = def.world

  self.x = def.x
  self.y = def.y

  self.direction = def.direction
  self.type = def.type or (sel.direction == "horizontal" and math.random(#H_OBSTACLES) or math.random(#V_OBSTACLES))

  self.width = self.direction == "horizontal" and H_OBSTACLES[self.type].width or V_OBSTACLES[self.type].width
  self.height = self.direction == "horizontal" and H_OBSTACLES[self.type].height or V_OBSTACLES[self.type].height

  self.variant = 1

  local body = love.physics.newBody(world, self.x, self.y, "dynamic")
  local shape = love.physics.newRectangleShape(self.width, self.height)
  local fixture = love.physics.newFixture(body, shape)
  fixture:setUserData("Obstacle")

  self.body = body
  self.shape = shape
  self.fixture = fixture
end

function Obstacle:render()
  love.graphics.draw(
    gTextures["obstacles"],
    gFrames["obstacles"][self.direction][self.type][self.variant],
    math.floor(self.body:getX()),
    math.floor(self.body:getY()),
    self.body:getAngle(),
    1,
    1,
    math.floor(self.width / 2),
    math.floor(self.height / 2)
  )
end
