CrashState = BaseState:new()

function CrashState:enter(params)
  self.data = params.data

  local contact = params.contact

  local x, y = contact:getPositions()
  local nx, ny = contact:getNormal()

  local xMin = nx > 0 and 50 or -50
  local yMin = ny > 0 and 50 or -50
  local xMax = xMin + nx * 20
  local yMax = yMin + ny * 20

  self.particles = Particles:new(x, y, xMin, yMin, xMax, yMax)

  local messages = {
    "Too bad",
    "Better luck next time",
    "Let's call it a practice run",
    "Far from the perfect landing"
  }

  self.message = {
    ["text"] = messages[love.math.random(#messages)],
    ["y"] = WINDOW_HEIGHT / 2 - gFonts.normal:getHeight(),
    ["index"] = 0
  }

  self.interval = {
    ["duration"] = 0.12
  }

  Timer:every(
    self.interval.duration,
    function()
      self.message.index = self.message.index + 1
      if self.message.index == #self.message.text then
        Timer:reset()
      end
    end
  )
end

function CrashState:update(dt)
  Timer:update(dt)
  self.particles:update(dt)

  if love.keyboard.waspressed("escape") then
    Timer:reset()

    gTerrain = getTerrain()

    gStateMachine:change("start")
  end

  if love.keyboard.waspressed("return") then
    Timer:reset()

    gTerrain = getTerrain()

    gStateMachine:change("play")
  end
end

function CrashState:render()
  self.data:render()

  love.graphics.setFont(gFonts.normal)
  love.graphics.printf(self.message.text:sub(1, self.message.index), 0, self.message.y, WINDOW_WIDTH, "center")

  self.particles:render()
end
