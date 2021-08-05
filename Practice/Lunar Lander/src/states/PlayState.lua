PlayState = BaseState:new()

local VELOCITY_THRESHOLD = 20

function PlayState:enter(params)
  self.lander = Lander:new(gWorld)
  self.data = params and params.data or Data:new(self.lander)
  self.terrain = Terrain:new(gWorld)

  gWorld:setCallbacks(
    function(fixture1, fixture2, contact)
      local userData = {}

      userData[fixture1:getUserData()] = true
      userData[fixture2:getUserData()] = true

      if userData["core"] and userData["terrain"] then
        Timer:reset()

        gWorld:setCallbacks()
        self.lander:destroy()
        self.terrain:destroy()

        gStateMachine:change(
          "crash",
          {
            ["data"] = self.data,
            ["contact"] = contact
          }
        )
      end

      if userData["landing-gear"] and userData["terrain"] then
        local vx, vy = self.lander.body:getLinearVelocity()

        gWorld:setCallbacks()
        self.terrain:destroy()

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

          self.lander:destroy()

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
      self.data:updateTime()
    end
  )
end

function PlayState:update(dt)
  Timer:update(dt)

  self.data:setAltitude(self.lander)
  self.data:setVelocity(self.lander)

  if love.keyboard.waspressed("up") then
    self.lander:applyLinearImpulse("up")
  end

  if love.keyboard.waspressed("right") then
    self.lander:applyLinearImpulse("right")
  elseif love.keyboard.waspressed("left") then
    self.lander:applyLinearImpulse("left")
  end

  if love.keyboard.isDown("up") then
    if self.data.fuel.value > 0 then
      self.lander:applyForce("up")
      self.data:updateFuel(dt)
    end
  end

  if love.keyboard.isDown("right") then
    if self.data.fuel.value > 0 then
      self.lander:applyForce("right")
    end
  elseif love.keyboard.isDown("left") then
    if self.data.fuel.value > 0 then
      self.lander:applyForce("left")
    end
  end

  gWorld:update(dt)

  if love.keyboard.waspressed("escape") then
    Timer:reset()

    gWorld:setCallbacks()

    self.lander:destroy()
    self.terrain:destroy()

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
