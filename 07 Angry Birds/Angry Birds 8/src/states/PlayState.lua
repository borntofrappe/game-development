PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.world = love.physics.newWorld(0, 300)

  self.player =
    Alien(
    {
      world = self.world,
      x = VIRTUAL_WIDTH / 4,
      y = VIRTUAL_HEIGHT / 2,
      type = "circle"
    }
  )
  self.player.fixture:setRestitution(0.8)

  self.target =
    Alien(
    {
      world = self.world,
      x = VIRTUAL_WIDTH * 3 / 4,
      y = VIRTUAL_HEIGHT / 2
    }
  )
  self.target.fixture:setRestitution(0.5)

  self.edges = {}
  for k, edge in pairs(EDGES) do
    self.edges[k] = {}
    self.edges[k].body = love.physics.newBody(self.world, edge.x1, edge.y1, "static")
    self.edges[k].shape = love.physics.newEdgeShape(0, 0, edge.x2 - edge.x1, edge.y2 - edge.y1)
    self.edges[k].fixture = love.physics.newFixture(self.edges[k].body, self.edges[k].shape)
  end
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
  love.graphics.setColor(1, 1, 1)

  self.player:render()
  self.target:render()
end
