PlayState = BaseState:new()

local IMPULSE = 10
local VELOCITY = 12
local VELOCITY_THRESHOLD = 20
local FUEL = 1000
local FUEL_SPEED = 20

function PlayState:enter()
  lander = {}
  lander.body = love.physics.newBody(gWorld, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 4, "dynamic")

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

  local yStart = 8
  local yGap = gFonts.small:getHeight() * 1.5
  local widthRightColumn = gFonts.small:getWidth("Horizontal Velocity 12 →")

  local data = {
    ["score"] = {
      ["label"] = "Score",
      ["value"] = 0,
      ["format"] = function(value)
        local formattedValue = string.format("%04d", value)
        return string.format("Score% 8s", formattedValue)
      end,
      ["x"] = 18,
      ["y"] = yStart
    },
    ["time"] = {
      ["label"] = "Time",
      ["value"] = 0,
      ["format"] = function(value)
        local seconds = value
        local minutes = math.floor(seconds / 60)
        seconds = seconds - minutes * 60

        local formattedValue = string.format("%02d:%02d", minutes, seconds)

        return string.format("Time% 9s", formattedValue)
      end,
      ["x"] = 18,
      ["y"] = yStart + yGap
    },
    ["fuel"] = {
      ["label"] = "Fuel",
      ["value"] = FUEL,
      ["format"] = function(value)
        local formattedValue = string.format("%04d", value)
        return string.format("Fuel% 9s", formattedValue)
      end,
      ["x"] = 18,
      ["y"] = yStart + yGap * 2
    },
    ["altitude"] = {
      ["label"] = "Altitude",
      ["value"] = WINDOW_HEIGHT - lander.body:getY(),
      ["format"] = function(value)
        return string.format("Altitude % 14d", value)
      end,
      ["x"] = WINDOW_WIDTH - widthRightColumn - 18,
      ["y"] = yStart
    },
    ["horizontal-speed"] = {
      ["label"] = "Horizontal speed",
      ["value"] = 0,
      ["format"] = function(value)
        local suffix = " "
        if value > 0 then
          suffix = "→"
        elseif value < 0 then
          suffix = "←"
        end

        return string.format("Horizontal Speed % 4d " .. suffix, value)
      end,
      ["x"] = WINDOW_WIDTH - widthRightColumn - 18,
      ["y"] = yStart + yGap
    },
    ["vertical-speed"] = {
      ["label"] = "Vertical Speed",
      ["value"] = 0,
      ["format"] = function(value)
        local suffix = " "
        if value > 0 then
          suffix = "↓"
        elseif value < 0 then
          suffix = "↑"
        end

        return string.format("Vertical Speed % 6d " .. suffix, value)
      end,
      ["x"] = WINDOW_WIDTH - widthRightColumn - 18,
      ["y"] = yStart + yGap * 2
    }
  }

  self.data = data

  Timer:every(
    1,
    function()
      self.data.time.value = self.data.time.value + 1
    end
  )
end

function PlayState:update(dt)
  Timer:update(dt)

  self.data.altitude.value = WINDOW_HEIGHT - self.lander.body:getY()
  local vx, vy = self.lander.body:getLinearVelocity()
  self.data["horizontal-speed"].value = vx
  self.data["vertical-speed"].value = vy

  if love.keyboard.waspressed("up") then
    lander.body:applyLinearImpulse(0, -IMPULSE)
  end

  if love.keyboard.waspressed("right") then
    lander.body:applyLinearImpulse(IMPULSE / 2, 0)
  elseif love.keyboard.waspressed("left") then
    lander.body:applyLinearImpulse(-IMPULSE / 2, 0)
  end

  if love.keyboard.isDown("up") then
    if self.data.fuel.value > 0 then
      self.data.fuel.value = math.max(0, self.data.fuel.value - dt * FUEL_SPEED)
      lander.body:applyForce(0, -VELOCITY)
    end
  end

  if love.keyboard.isDown("right") then
    if self.data.fuel.value > 0 then
      lander.body:applyForce(VELOCITY / 2, 0)
    end
  elseif love.keyboard.isDown("left") then
    if self.data.fuel.value > 0 then
      lander.body:applyForce(-VELOCITY / 2, 0)
    end
  end

  gWorld:update(dt)

  if love.keyboard.waspressed("escape") then
    Timer:reset()
    gWorld:setCallbacks()
    self.lander.body:destroy()
    self.terrain.body:destroy()

    gStateMachine:change("start")
  end
end

function PlayState:render()
  love.graphics.setFont(gFonts.small)
  for _, data in pairs(self.data) do
    love.graphics.print(data.format(data.value):upper(), data.x, data.y)
  end

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
