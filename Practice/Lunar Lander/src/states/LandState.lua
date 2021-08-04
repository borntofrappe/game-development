LandState = BaseState:new()

function LandState:enter(params)
  self.lander = params.lander
  self.data = params.data

  self.data:updateScore()
  self.data:refuel()

  local messages = {
    "Congratulations",
    "Great job",
    "Smooth landing",
    "You did it",
    "The cargo is safe",
    "Nice"
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

    self.lander:destroy()

    gTerrain = getTerrain()

    gStateMachine:change("start")
  end

  if love.keyboard.waspressed("return") then
    Timer:reset()

    self.lander:destroy()

    gTerrain = getTerrain()

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

  love.graphics.setFont(gFonts.normal)
  love.graphics.printf(self.message.text:sub(1, self.message.index), 0, self.message.y, WINDOW_WIDTH, "center")
end
