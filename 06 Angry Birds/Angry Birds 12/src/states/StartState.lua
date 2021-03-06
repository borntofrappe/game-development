StartState = Class({__includes = BaseState})

local COLUMNS = math.floor(VIRTUAL_WIDTH / 1.5 / ALIEN_WIDTH)
local ROWS = math.floor(VIRTUAL_HEIGHT / 2 / ALIEN_HEIGHT)

function StartState:init()
  self.interval = 5
  self.timer = 0

  local world = love.physics.newWorld(0, 20)

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

  local aliens = {}
  for column = 1, COLUMNS do
    for row = 1, ROWS do
      local alien =
        Alien(
        {
          ["world"] = world,
          ["x"] = VIRTUAL_WIDTH / 6 + (column - 1) * ALIEN_WIDTH + ALIEN_WIDTH / 2,
          ["y"] = VIRTUAL_HEIGHT / 4 + (row - 1) * ALIEN_HEIGHT + ALIEN_HEIGHT / 2
        }
      )

      alien.body:setLinearVelocity(math.random(-100, 100), math.random(-100, 100))
      alien.fixture:setRestitution(0.6)

      table.insert(aliens, alien)
    end
  end

  self.world = world
  -- self.edges = edges
  self.aliens = aliens
end

function StartState:update(dt)
  self.timer = self.timer + dt
  if self.timer > self.interval then
    self.timer = self.timer % self.interval

    for k, alien in pairs(self.aliens) do
      alien.body:setLinearVelocity(math.random(-100, 100), math.random(0, 100) * -1)
    end
  end

  if love.keyboard.wasPressed("escape") then
    love.event.quit()
  end
  if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") or love.mouse.wasPressed(1) then
    gStateMachine:change("play")
  end

  self.world:update(dt)
end

function StartState:render()
  love.graphics.setColor(1, 1, 1)
  for k, alien in pairs(self.aliens) do
    alien:render()
  end

  love.graphics.setColor(0, 0, 0, 0.6)
  love.graphics.rectangle("fill", VIRTUAL_WIDTH / 2 - 190, VIRTUAL_HEIGHT / 2 - 64, 380, 120, 10)

  love.graphics.setFont(gFonts["big"])
  love.graphics.setColor(1, 1, 1)
  love.graphics.printf("Angry Birds", 0, VIRTUAL_HEIGHT / 2 - 48, VIRTUAL_WIDTH, "center")
  love.graphics.setFont(gFonts["normal"])
  love.graphics.printf("Click to play!", 0, VIRTUAL_HEIGHT / 2 + 16, VIRTUAL_WIDTH, "center")
end
