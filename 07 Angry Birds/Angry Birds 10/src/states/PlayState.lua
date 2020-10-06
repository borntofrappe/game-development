PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.world = love.physics.newWorld(0, 300)

  -- self.collisionUserData = {}

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
    -- self.collisionUserData = {f1:getUserData(), f2:getUserData()}

    local userData = {}
    userData[f1:getUserData()] = true
    userData[f2:getUserData()] = true

    if (userData["Player"] and userData["Obstacle"]) or (userData["Player"] and userData["Target"]) then
      if f1:getUserData() == "Player" then
        local vX, vY = f1:getBody():getLinearVelocity()
        local vSum = math.abs(vX) + math.abs(vY)
        if vSum > 100 then
          table.insert(self.destroyedObjects, f2:getBody())
        end
      else
        local vX, vY = f2:getBody():getLinearVelocity()
        local vSum = math.abs(vX) + math.abs(vY)
        if vSum > 100 then
          table.insert(self.destroyedObjects, f1:getBody())
        end
      end
    end
    if userData["Obstacle"] and userData["Target"] then
      if f1:getUserData() == "Obstacle" then
        local vX, vY = f1:getBody():getLinearVelocity()
        local vSum = math.abs(vX) + math.abs(vY)
        if vSum > 100 then
          table.insert(self.destroyedObjects, f2:getBody())
        end
      else
        local vX, vY = f2:getBody():getLinearVelocity()
        local vSum = math.abs(vX) + math.abs(vY)
        if vSum > 100 then
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
end

function PlayState:render()
  love.graphics.setColor(1, 1, 1)

  self.player:render()

  if self.target then
    self.target:render()
  end

  for k, obstacle in pairs(self.obstacles) do
    obstacle:render()
  end

  -- love.graphics.setFont(gFonts["normal"])
  -- love.graphics.setColor(0.1, 1, 0.1)
  -- for i, label in ipairs(self.collisionUserData) do
  --   love.graphics.print("Collision body " .. i .. ": " .. label, 8, 8 + (i - 1) * 32)
  -- end
end
