PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.world = love.physics.newWorld(GRAVITY_X, GRAVITY_Y)
  self.isDragging = false
  self.isUpdating = false
  self.hasWon = false
  self.timer = 0

  self.hasCollided = false
  self.copies = {}

  self.level = LEVELS[math.random(#LEVELS)]

  self.player =
    Alien(
    {
      world = self.world,
      x = self.level.player.x,
      y = self.level.player.y,
      type = "circle"
    }
  )
  self.player.fixture:setRestitution(0.8)
  self.player.body:setAngularDamping(1)

  self.target =
    Alien(
    {
      world = self.world,
      x = self.level.target.x,
      y = self.level.target.y
    }
  )

  self.obstacles = {}
  for i = 1, #self.level.obstacles do
    self.obstacles[i] =
      Obstacle(
      {
        world = self.world,
        x = self.level.obstacles[i].x,
        y = self.level.obstacles[i].y,
        direction = self.level.obstacles[i].direction,
        type = self.level.obstacles[i].type
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
      self.hasCollided = true

      if f1:getUserData() == "Player" then
        local vX, vY = f1:getBody():getLinearVelocity()
        local vSum = math.abs(vX) + math.abs(vY)
        if vSum > VELOCITY_DESTROY then
          table.insert(self.destroyedObjects, f2:getBody())
        else
          gSounds["bounce"]:stop()
          gSounds["bounce"]:play()
        end
      else
        local vX, vY = f2:getBody():getLinearVelocity()
        local vSum = math.abs(vX) + math.abs(vY)
        if vSum > VELOCITY_DESTROY then
          table.insert(self.destroyedObjects, f1:getBody())
        else
          gSounds["bounce"]:stop()
          gSounds["bounce"]:play()
        end
      end
    end
    if userData["Obstacle"] and userData["Target"] then
      if f1:getUserData() == "Obstacle" then
        local vX, vY = f1:getBody():getLinearVelocity()
        local vSum = math.abs(vX) + math.abs(vY)
        if vSum > VELOCITY_DESTROY then
          table.insert(self.destroyedObjects, f2:getBody())
        else
          gSounds["bounce"]:stop()
          gSounds["bounce"]:play()
        end
      else
        local vX, vY = f2:getBody():getLinearVelocity()
        local vSum = math.abs(vX) + math.abs(vY)
        if vSum > VELOCITY_DESTROY then
          table.insert(self.destroyedObjects, f1:getBody())
        else
          gSounds["bounce"]:stop()
          gSounds["bounce"]:play()
        end
      end
    end
    if userData["Player"] and userData["Edge"] then
      gSounds["bounce"]:setVolume(0.1)
      gSounds["bounce"]:stop()
      gSounds["bounce"]:play()
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
    if math.abs(x - self.player.x) < VIRTUAL_WIDTH / 4 - ALIEN_WIDTH / 2 then
      self.player.body:setX(x)
    end
    if y + ALIEN_WIDTH / 2 < VIRTUAL_HEIGHT - TILE_SIZE / 2 then
      self.player.body:setY(y)
    end
  end

  if love.mouse.wasReleased(1) then
    if not self.isUpdating and self.isDragging then
      local x, y = push:toGame(love.mouse.getPosition())

      if (math.abs(x - self.player.x) < ALIEN_WIDTH and math.abs(y - self.player.y) < ALIEN_WIDTH) then
        self.player.body:setPosition(self.player.x, self.player.y)
      else
        local dx = self.player.x - x
        local dy = self.player.y - y
        self.player.body:setLinearVelocity(dx * 5, dy * 5)

        self.isUpdating = true
      end
      self.isDragging = false
    end
  end

  if self.isUpdating then
    self.world:update(dt)

    if not self.hasCollided and #self.copies == 0 and love.keyboard.wasPressed("space") then
      local x, y = self.player.body:getPosition()
      local vX, vY = self.player.body:getLinearVelocity()
      local color = self.player.color
      for i = 1, 2 do
        local copy =
          Alien(
          {
            world = self.world,
            x = vX > 0 and x - ALIEN_WIDTH / 2 or x + ALIEN_WIDTH / 2,
            y = i == 1 and y - ALIEN_HEIGHT / 2 or y + ALIEN_HEIGHT / 2,
            type = "circle",
            color = color
          }
        )
        copy.fixture:setRestitution(0.8)
        copy.body:setAngularDamping(1)
        copy.body:setLinearVelocity(vX, vY)
        table.insert(self.copies, copy)
      end
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
          local breakSounds = 4
          for i = 1, breakSounds do
            gSounds["break" .. i]:stop()
          end
          local breakSound = math.random(breakSounds)
          gSounds["break" .. breakSound]:play()
        end
      end

      if self.target and self.target.body:isDestroyed() then
        self.target = nil
        self.hasWon = true
        gSounds["kill"]:play()
      end
    end

    local vX, vY = self.player.body:getLinearVelocity()
    local vSum = math.abs(vX) + math.abs(vY)
    if vSum < VELOCITY_RESET then
      local isCopyMoving = false
      for k, copy in pairs(self.copies) do
        local vX, vY = copy.body:getLinearVelocity()
        local vSum = math.abs(vX) + math.abs(vY)
        if vSum > VELOCITY_RESET then
          isCopyMoving = true
          break
        end
      end

      if not isCopyMoving then
        self.player.body:setPosition(self.player.x, self.player.y)
        self.isUpdating = false
        self.hasCollided = false
        for k, copy in pairs(self.copies) do
          copy.body:destroy()
        end
        self.copies = {}
      end
    end
  end

  if self.hasWon then
    self.timer = self.timer + dt
    if self.timer > COUNTDOWN_TIMER then
      gStateMachine:change("start")
      backgroundVariety = math.random(#gFrames["background"])
    end
  end
end

function PlayState:render()
  if not self.isUpdating then
    love.graphics.setColor(0, 0, 0, 0.25)
    love.graphics.circle("fill", self.player.x, self.player.y, ALIEN_WIDTH)
  end

  love.graphics.setColor(1, 1, 1, 1)

  for k, obstacle in pairs(self.obstacles) do
    obstacle:render()
  end

  self.player:render()
  for k, copy in pairs(self.copies) do
    copy:render()
  end

  if self.target then
    self.target:render()
  end

  if self.hasWon then
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(gFonts["big"])
    love.graphics.printf(string.upper("Victory"), 0, VIRTUAL_HEIGHT / 2 - 48, VIRTUAL_WIDTH, "center")
  end
end
