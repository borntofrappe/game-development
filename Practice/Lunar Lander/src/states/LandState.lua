LandState = BaseState:new()

function LandState:enter(params)
  self.lander = params.lander
  self.data = params.data

  self.data["fuel"].value = self.data["fuel"].value + 150
  self.data["score"].value = self.data["score"].value + WINDOW_HEIGHT - self.data["altitude"].value

  local messages = {
    "Congratulations",
    "Great job",
    "Smooth landing",
    "You did it",
    "The cargo is safe",
    "Nice one"
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

function LandState:update(dt)
  Timer:update(dt)

  if love.keyboard.waspressed("escape") then
    Timer:reset()

    self.lander.body:destroy()

    gPoints, gPlatforms = getTerrain()

    gStateMachine:change("start")
  end

  if love.keyboard.waspressed("return") then
    Timer:reset()

    self.lander.body:destroy()
    self.data["time"].value = 0

    gPoints, gPlatforms = getTerrain()

    gStateMachine:change(
      "play",
      {
        ["data"] = self.data
      }
    )
  end
end

function LandState:render()
  self.data:render()
  self.lander:render()

  love.graphics.setColor(0.94, 0.94, 0.95)
  love.graphics.setFont(gFonts.normal)
  love.graphics.printf(self.message.text:sub(1, self.message.index), 0, self.message.y, WINDOW_WIDTH, "center")
end
