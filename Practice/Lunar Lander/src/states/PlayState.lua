PlayState = BaseState:new()

local IMPULSE = 10
local VELOCITY = 10
local VELOCITY_THRESHOLD = 350

function PlayState:enter()
  lander = {}
  lander.body = love.physics.newBody(gWorld, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, "dynamic")

  lander.core = {}
  lander.core.shape = love.physics.newCircleShape(10)
  lander.core.fixture = love.physics.newFixture(lander.body, lander.core.shape)
  lander.core.fixture:setUserData("core")

  lander.landingGear = {}
  lander.landingGear[1] = {}
  lander.landingGear[1].shape = love.physics.newPolygonShape(-10, 13, -8, 10, -5, 10, -3, 13)
  lander.landingGear[1].fixture = love.physics.newFixture(lander.body, lander.landingGear[1].shape)
  lander.landingGear[1].fixture:setRestitution(0.1)

  lander.landingGear[2] = {}
  lander.landingGear[2].shape = love.physics.newPolygonShape(10, 13, 8, 10, 5, 10, 3, 13)
  lander.landingGear[2].fixture = love.physics.newFixture(lander.body, lander.landingGear[2].shape)
  lander.landingGear[2].fixture:setRestitution(0.1)

  lander.landingGear[3] = {}
  lander.landingGear[3].shape = love.physics.newRectangleShape(0, 7, 16, 3)
  lander.landingGear[3].fixture = love.physics.newFixture(lander.body, lander.landingGear[3].shape)
  lander.landingGear[3].fixture:setSensor(true)

  for _, landingGear in pairs(lander.landingGear) do
    landingGear.fixture:setUserData("landing-gear")
  end

  lander.thrusters = {}
  lander.thrusters[1] = {}
  lander.thrusters[1].shape = love.physics.newPolygonShape(-10, 13, -6.5, 17, -3, 13)

  lander.thrusters[2] = {}
  lander.thrusters[2].shape = love.physics.newPolygonShape(10, 13, 6.5, 17, 3, 13)

  lander.thrusters[3] = {}
  lander.thrusters[3].shape = love.physics.newPolygonShape(-8, 4, -14, 7, -8, 10)

  lander.thrusters[4] = {}
  lander.thrusters[4].shape = love.physics.newPolygonShape(8, 4, 14, 7, 8, 10)

  for _, thruster in pairs(lander.thrusters) do
    thruster.fixture = love.physics.newFixture(lander.body, thruster.shape)
    thruster.fixture:setSensor(true)
    thruster.fixture:setUserData("thruster")
  end

  self.lander = lander

  terrain = {}
  terrain.body = love.physics.newBody(gWorld, 0, 0)
  terrain.shape = love.physics.newChainShape(false, gTerrain)
  terrain.fixture = love.physics.newFixture(terrain.body, terrain.shape)
  terrain.fixture:setUserData("terrain")

  self.terrain = terrain

  gWorld:setCallbacks(
    function(fixture1, fixture2)
      local userData = {}

      userData[fixture1:getUserData()] = true
      userData[fixture2:getUserData()] = true

      if userData["core"] and userData["terrain"] then
        gWorld:setCallbacks()
        self.lander.body:destroy()
        self.terrain.body:destroy()

        gStateMachine:change("crash")
      end

      if userData["landing-gear"] and userData["terrain"] then
        local vx, vy = self.lander.body:getLinearVelocity()

        gWorld:setCallbacks()
        self.terrain.body:destroy()

        if vx ^ 2 + vy ^ 2 < VELOCITY_THRESHOLD then
          gStateMachine:change(
            "land",
            {
              ["lander"] = self.lander
            }
          )
        else
          self.lander.body:destroy()
          gStateMachine:change("crash")
        end
      end
    end
  )
end

function PlayState:update(dt)
  if love.keyboard.waspressed("escape") then
    gWorld:setCallbacks()
    self.lander.body:destroy()
    self.terrain.body:destroy()

    gStateMachine:change("start")
  end

  if love.keyboard.waspressed("up") then
    lander.body:applyLinearImpulse(0, -IMPULSE)
  end

  if love.keyboard.waspressed("right") then
    lander.body:applyLinearImpulse(IMPULSE / 2, 0)
  elseif love.keyboard.waspressed("left") then
    lander.body:applyLinearImpulse(-IMPULSE / 2, 0)
  end

  if love.keyboard.isDown("up") then
    lander.body:applyForce(0, -VELOCITY)
  end

  if love.keyboard.isDown("right") then
    lander.body:applyForce(VELOCITY / 2, 0)
  elseif love.keyboard.isDown("left") then
    lander.body:applyForce(-VELOCITY / 2, 0)
  end

  gWorld:update(dt)
end

function PlayState:render()
  love.graphics.setFont(gFonts.normal)
  local vx, vy = self.lander.body:getLinearVelocity()
  love.graphics.print("velocity " .. math.floor(vx ^ 2 + vy ^ 2), 8, 8)

  love.graphics.setLineWidth(2)
  love.graphics.circle("line", self.lander.body:getX(), self.lander.body:getY(), self.lander.core.shape:getRadius())
  for _, gear in pairs(self.lander.landingGear) do
    love.graphics.polygon("line", self.lander.body:getWorldPoints(gear.shape:getPoints()))
  end

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
