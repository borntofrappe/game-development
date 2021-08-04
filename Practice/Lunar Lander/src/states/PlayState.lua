PlayState = BaseState:new()

local IMPULSE = 10
local VELOCITY = 12
local VELOCITY_THRESHOLD = 20
local FUEL_SPEED = 20

function PlayState:enter(params)
  self.lander = Lander:new(gWorld)
  self.data = params and params.data or Data:new(self.lander)
  self.terrain = Terrain:new(gWorld)

  gWorld:setCallbacks(
    function(fixture1, fixture2)
      local userData = {}

      userData[fixture1:getUserData()] = true
      userData[fixture2:getUserData()] = true

      if userData["core"] and userData["terrain"] then
        Timer:reset()

        gWorld:setCallbacks()
        self.lander.body:destroy()
        self.terrain.body:destroy()

        gStateMachine:change(
          "crash",
          {
            ["data"] = self.data
          }
        )
      end

      if userData["landing-gear"] and userData["terrain"] then
        local vx, vy = self.lander.body:getLinearVelocity()

        gWorld:setCallbacks()
        self.terrain.body:destroy()

        if math.abs(vx) < VELOCITY_THRESHOLD / 2 and math.abs(vy) < VELOCITY_THRESHOLD then
          Timer:reset()

          gStateMachine:change(
            "land",
            {
              ["lander"] = self.lander,
              ["data"] = self.data
            }
          )
        else
          Timer:reset()

          self.lander.body:destroy()
          gStateMachine:change(
            "crash",
            {
              ["data"] = self.data
            }
          )
        end
      end
    end
  )

  Timer:every(
    1,
    function()
      self.data.metrics.time.value = self.data.metrics.time.value + 1
    end
  )
end

function PlayState:update(dt)
  Timer:update(dt)

  self.data.metrics.altitude.value = WINDOW_HEIGHT - self.lander.body:getY()
  local vx, vy = self.lander.body:getLinearVelocity()
  self.data.metrics["horizontal-speed"].value = vx
  self.data.metrics["vertical-speed"].value = vy

  if love.keyboard.waspressed("up") then
    self.lander.body:applyLinearImpulse(0, -IMPULSE)
  end

  if love.keyboard.waspressed("right") then
    self.lander.body:applyLinearImpulse(IMPULSE / 2, 0)
  elseif love.keyboard.waspressed("left") then
    self.lander.body:applyLinearImpulse(-IMPULSE / 2, 0)
  end

  if love.keyboard.isDown("up") then
    if self.data.metrics.fuel.value > 0 then
      self.data.metrics.fuel.value = math.max(0, self.data.metrics.fuel.value - dt * FUEL_SPEED)
      self.lander.body:applyForce(0, -VELOCITY)
    end
  end

  if love.keyboard.isDown("right") then
    if self.data.metrics.fuel.value > 0 then
      self.lander.body:applyForce(VELOCITY / 2, 0)
    end
  elseif love.keyboard.isDown("left") then
    if self.data.metrics.fuel.value > 0 then
      self.lander.body:applyForce(-VELOCITY / 2, 0)
    end
  end

  gWorld:update(dt)

  if love.keyboard.waspressed("escape") then
    Timer:reset()
    gWorld:setCallbacks()
    self.lander.body:destroy()
    self.terrain.body:destroy()
    gTerrain = getTerrain()

    gStateMachine:change("start")
  end
end

function PlayState:render()
  self.data:render()
  self.lander:render()

  if love.keyboard.isDown("up") then
    love.graphics.polygon("fill", self.lander.body:getWorldPoints(self.lander.thrusters[1].shape:getPoints()))
    love.graphics.polygon("fill", self.lander.body:getWorldPoints(self.lander.thrusters[2].shape:getPoints()))
  end

  if love.keyboard.isDown("right") then
    love.graphics.polygon("fill", self.lander.body:getWorldPoints(self.lander.thrusters[3].shape:getPoints()))
  elseif love.keyboard.isDown("left") then
    love.graphics.polygon("fill", self.lander.body:getWorldPoints(self.lander.thrusters[4].shape:getPoints()))
  end
end
