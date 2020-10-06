PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.world = love.physics.newWorld(GRAVITY_X, GRAVITY_Y)
  self.isDragging = false
  self.isUpdating = false

  self.player =
    Alien(
    {
      world = self.world,
      x = PLAYER.x,
      y = PLAYER.y,
      type = "circle"
    }
  )
  self.player.fixture:setRestitution(0.8)

  self.target =
    Alien(
    {
      world = self.world,
      x = TARGET.x,
      y = TARGET.y
    }
  )

  self.obstacles = {}
  for i = 1, #OBSTACLES do
    self.obstacles[i] =
      Obstacle(
      {
        world = self.world,
        x = OBSTACLES[i].x,
        y = OBSTACLES[i].y,
        direction = OBSTACLES[i].direction,
        type = 1
      }
    )
  end

  self.edges = {}
  for k, edge in pairs(EDGES) do
    self.edges[k] = {}
    self.edges[k].body = love.physics.newBody(self.world, edge.x1, edge.y1, "static")
    self.edges[k].shape = love.physics.newEdgeShape(0, 0, edge.x2 - edge.x1, edge.y2 - edge.y1)
    self.edges[k].fixture = love.physics.newFixture(self.edges[k].body, self.edges[k].shape)
    self.edges[k].fixture:setUserData("Edge")
  end

  self.destroyedObjects = {}

  function beginContact(f1, f2, contact)
    local userData = {}
    userData[f1:getUserData()] = true
    userData[f2:getUserData()] = true

    if (userData["Player"] and userData["Obstacle"]) or (userData["Player"] and userData["Target"]) then
      if f1:getUserData() == "Player" then
        local vX, vY = f1:getBody():getLinearVelocity()
        local vSum = math.abs(vX) + math.abs(vY)
        if vSum > VELOCITY_DESTROY then
          table.insert(self.destroyedObjects, f2:getBody())
        end
      else
        local vX, vY = f2:getBody():getLinearVelocity()
        local vSum = math.abs(vX) + math.abs(vY)
        if vSum > VELOCITY_DESTROY then
          table.insert(self.destroyedObjects, f1:getBody())
        end
      end
    end
    if userData["Obstacle"] and userData["Target"] then
      if f1:getUserData() == "Obstacle" then
        local vX, vY = f1:getBody():getLinearVelocity()
        local vSum = math.abs(vX) + math.abs(vY)
        if vSum > VELOCITY_DESTROY then
          table.insert(self.destroyedObjects, f2:getBody())
        end
      else
        local vX, vY = f2:getBody():getLinearVelocity()
        local vSum = math.abs(vX) + math.abs(vY)
        if vSum > VELOCITY_DESTROY then
          table.insert(self.destroyedObjects, f1:getBody())
        end
      end
    end
  end

  self.world:setCallbacks(beginContact)
end

function PlayState:update(dt)
  if love.keyboard.wasPressed("escape") or love.mouse.wasPressed(2) then
    gStateMachine:change("start")
  end

  if love.mouse.wasPressed(1) then
    local x, y = push:toGame(love.mouse.getPosition())
    if
      not self.isUpdating and not self.isDragging and math.abs(x - self.player.x) < ALIEN_WIDTH and
        math.abs(y - self.player.y) < ALIEN_WIDTH
     then
      self.isDragging = true
    end
  end

  if not self.isUpdating and self.isDragging then
    local x, y = push:toGame(love.mouse.getPosition())
    self.player.body:setPosition(x, y)
  end

  if love.mouse.wasReleased(1) then
    if not self.isUpdating and self.isDragging then
      local x, y = push:toGame(love.mouse.getPosition())

      if math.abs(x - self.player.x) < ALIEN_WIDTH and math.abs(y - self.player.y) < ALIEN_WIDTH then
        self.player.body:setPosition(self.player.x, self.player.y)
      else
        local dx = self.player.x - x
        local dy = self.player.y - y
        self.player.body:setLinearVelocity(dx * 5, dy * 5)

        self.isDragging = false
        self.isUpdating = true
      end
    end
  end

  if self.isUpdating then
    self.world:update(dt)
    if #self.destroyedObjects > 0 then
      for k, body in pairs(self.destroyedObjects) do
        if not body:isDestroyed() then
          body:destroy()
        end
      end
      self.destroyedObjects = {}

      for i = #self.obstacles, 1, -1 do
        if self.obstacles[i].body:isDestroyed() then
          table.remove(self.obstacles, i)
        end
      end

      if self.target and self.target.body:isDestroyed() then
        self.target = nil
      end
    end

    local vX, vY = self.player.body:getLinearVelocity()
    local vSum = math.abs(vX) + math.abs(vY)
    if vSum < VELOCITY_RESET then
      self.player.body:setPosition(self.player.x, self.player.y)
      self.isUpdating = false
    end
  end
end

function PlayState:render()
  love.graphics.setColor(1, 1, 1, 0.5)
  love.graphics.circle("fill", self.player.x, self.player.y, ALIEN_WIDTH)

  love.graphics.setColor(1, 1, 1, 1)
  self.player:render()

  if self.target then
    self.target:render()
  end

  for k, obstacle in pairs(self.obstacles) do
    obstacle:render()
  end

  if not self.isDragging and not self.isUpdating then
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(gFonts["normal"])
    love.graphics.printf("Drag and release", 0, VIRTUAL_HEIGHT / 2 - 24, VIRTUAL_WIDTH, "center")
  end
end
