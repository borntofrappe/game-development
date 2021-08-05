PlayState = BaseState:new()

local IMPULSE = 8
local VELOCITY = 14
local VELOCITY_THRESHOLD = 20
local FUEL_CONSUMPTION_SPEED = 20

function PlayState:enter(params)
  self.lander = Lander:new(gWorld)
  self.terrain = Terrain:new(gWorld, gPoints)

  self.data = params and params.data or Data:new(self.lander)

  gWorld:setCallbacks(
    function(fixture1, fixture2, contact)
      local userData = {}

      userData[fixture1:getUserData()] = true
      userData[fixture2:getUserData()] = true

      local hasCrashed = false

      if userData["core"] and userData["terrain"] then
        hasCrashed = true
      end

      if not hasCrashed and userData["landing-gear"] and userData["terrain"] then
        local vx, vy = self.lander.body:getLinearVelocity()

        gWorld:setCallbacks()
        self.terrain.body:destroy()

        if math.abs(vx) < VELOCITY_THRESHOLD / 2 and math.abs(vy) < VELOCITY_THRESHOLD then
          local isOnPlatform = false
          local x = self.lander.body:getX()
          local size = self.lander.core.shape:getRadius()

          for i, gPlatform in ipairs(gPlatforms) do
            if math.ceil(x - size / 2) > gPlatform[1] and math.floor(x + size / 2) < gPlatform[2] then
              isOnPlatform = true
              break
            end
          end

          if isOnPlatform then
            Timer:reset()

            gStateMachine:change(
              "land",
              {
                ["lander"] = self.lander,
                ["data"] = self.data
              }
            )
          else
            hasCrashed = true
          end
        else
          hasCrashed = true
        end

        if hasCrashed then
          Timer:reset()

          gWorld:setCallbacks()
          self.lander.body:destroy()
          self.terrain.body:destroy()

          gStateMachine:change(
            "crash",
            {
              ["data"] = self.data,
              ["contact"] = contact
            }
          )
        end
      end
    end
  )

  Timer:every(
    1,
    function()
      self.data["time"].value = self.data["time"].value + 1
    end
  )
end

function PlayState:update(dt)
  Timer:update(dt)

  self.data["altitude"].value = WINDOW_HEIGHT - self.lander.body:getY()
  local vx, vy = self.lander.body:getLinearVelocity()
  self.data["horizontal-speed"].value = vx
  self.data["vertical-speed"].value = vy

  if love.keyboard.waspressed("up") then
    self.lander.body:applyLinearImpulse(0, -IMPULSE)
  end

  if love.keyboard.waspressed("right") then
    self.lander.body:applyLinearImpulse(IMPULSE / 2, 0)
  elseif love.keyboard.waspressed("left") then
    self.lander.body:applyLinearImpulse(IMPULSE / 2 * -1, 0)
  end

  if love.keyboard.isDown("up") then
    if self.data.fuel.value > 0 then
      self.lander.body:applyForce(0, -VELOCITY)
      self.data["fuel"].value = self.data["fuel"].value - dt * FUEL_CONSUMPTION_SPEED
    end
  end

  if love.keyboard.isDown("right") then
    if self.data.fuel.value > 0 then
      self.lander.body:applyForce(VELOCITY / 2, 0)
      self.data["fuel"].value = self.data["fuel"].value - dt * FUEL_CONSUMPTION_SPEED / 2
    end
  elseif love.keyboard.isDown("left") then
    if self.data.fuel.value > 0 then
      self.lander.body:applyForce(VELOCITY / 2 * -1, 0)
      self.data["fuel"].value = self.data["fuel"].value - dt * FUEL_CONSUMPTION_SPEED / 2
    end
  end

  if self.lander.body:getX() < -self.lander.core.shape:getRadius() then
    self.terrain.body:destroy()
    gPoints, gPlatforms = getTerrain()
    self.terrain = Terrain:new(gWorld, gPoints)

    self.lander.body:setX(WINDOW_WIDTH + self.lander.core.shape:getRadius())
  end

  if self.lander.body:getX() > WINDOW_WIDTH + self.lander.core.shape:getRadius() then
    self.terrain.body:destroy()
    gPoints, gPlatforms = getTerrain()
    self.terrain = Terrain:new(gWorld, gPoints)

    self.lander.body:setX(-self.lander.core.shape:getRadius())
  end

  gWorld:update(dt)

  if love.keyboard.waspressed("escape") then
    Timer:reset()

    gWorld:setCallbacks()

    self.lander.body:destroy()
    self.terrain.body:destroy()

    gPoints, gPlatforms = getTerrain()

    gStateMachine:change("start")
  end
end

function PlayState:render()
  self.data:render()
  self.lander:render()

  if love.keyboard.isDown("up") then
    love.graphics.setColor(0.91, 0.68, 0.34)
    love.graphics.polygon("fill", self.lander.body:getWorldPoints(self.lander.thrusters[1].shape:getPoints()))
    love.graphics.polygon("fill", self.lander.body:getWorldPoints(self.lander.thrusters[2].shape:getPoints()))
  end

  if love.keyboard.isDown("right") then
    love.graphics.setColor(0.91, 0.68, 0.34)
    love.graphics.polygon("fill", self.lander.body:getWorldPoints(self.lander.thrusters[3].shape:getPoints()))
  elseif love.keyboard.isDown("left") then
    love.graphics.setColor(0.91, 0.68, 0.34)
    love.graphics.polygon("fill", self.lander.body:getWorldPoints(self.lander.thrusters[4].shape:getPoints()))
  end
end
