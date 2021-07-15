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

  local player =
    Alien(
    {
      ["world"] = world,
      ["x"] = VIRTUAL_WIDTH / 4,
      ["y"] = VIRTUAL_HEIGHT / 2,
      ["type"] = "circle"
    }
  )

  player.fixture:setRestitution(0.8)

  local target =
    Alien(
    {
      ["world"] = world,
      ["x"] = VIRTUAL_WIDTH * 3 / 4,
      ["y"] = VIRTUAL_HEIGHT / 2
    }
  )

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
  love.graphics.setColor(1, 1, 1)

  self.player:render()
  self.target:render()
end
