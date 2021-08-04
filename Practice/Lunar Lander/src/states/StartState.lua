StartState = BaseState:new()

function StartState:enter()
  local yStart = -gFonts.large:getHeight()
  local yFinish = WINDOW_HEIGHT / 2 - gFonts.large:getHeight()

  local sensor = {}
  sensor.body = love.physics.newBody(gWorld, WINDOW_WIDTH / 2, yStart, "dynamic")
  sensor.shape = love.physics.newCircleShape(1)
  sensor.fixture = love.physics.newFixture(sensor.body, sensor.shape)
  sensor.fixture:setRestitution(0.2)
  sensor.fixture:setUserData("sensor")

  self.sensor = sensor

  local threshold = {}
  threshold.body = love.physics.newBody(gWorld, 0, yFinish)
  threshold.shape = love.physics.newChainShape(false, 0, 0, WINDOW_WIDTH, 0)
  threshold.fixture = love.physics.newFixture(threshold.body, threshold.shape)
  threshold.fixture:setUserData("threshold")

  self.threshold = threshold

  local instructions = {
    "Good luck",
    "Bonne chance",
    "Give it your best shot",
    "You can do this",
    "Slow and steady",
    "Patience is key",
    "It's not a sprint"
  }

  self.instruction = {
    ["text"] = instructions[love.math.random(#instructions)],
    ["y"] = yFinish + gFonts.large:getHeight() + 24,
    ["index"] = 0
  }

  self.interval = {
    ["duration"] = 0.12,
    ["label"] = "instruction"
  }

  gWorld:setCallbacks(
    function(fixture1, fixture2)
      local userData = {}
      userData[fixture1:getUserData()] = true
      userData[fixture2:getUserData()] = true

      if userData["sensor"] and userData["threshold"] then
        gWorld:setCallbacks()
        Timer:every(
          self.interval.duration,
          function()
            self.instruction.index = self.instruction.index + 1
            if self.instruction.index == #self.instruction.text then
              Timer:remove(self.interval.label)
            end
          end,
          false,
          self.interval.label
        )
      end
    end
  )
end

function StartState:update(dt)
  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("return") then
    Timer:remove(self.interval.label)

    gWorld:setCallbacks()
    self.sensor.body:destroy()
    self.threshold.body:destroy()

    gStateMachine:change("play")
  end

  Timer:update(dt)
  gWorld:update(dt)
end

function StartState:render()
  love.graphics.setColor(0, 0, 0, 0.85)
  love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)

  love.graphics.setColor(0.95, 0.95, 0.95)
  love.graphics.setFont(gFonts.large)
  love.graphics.printf(TITLE:upper(), 0, self.sensor.body:getY(), WINDOW_WIDTH, "center")

  love.graphics.setFont(gFonts.normal)
  love.graphics.printf(
    self.instruction.text:sub(1, self.instruction.index),
    0,
    self.instruction.y,
    WINDOW_WIDTH,
    "center"
  )
end
