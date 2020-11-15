LandState = BaseState:create()

function LandState:enter()
  data["score"] = data["score"] + (WINDOW_HEIGHT - data["altitude"]) + data["fuel"]

  local messages = {
    "Congratulations",
    "Great job",
    "Smooth landing",
    "You did it",
    "The cargo is safe",
    "Nice"
  }

  local message = messages[love.math.random(#messages)]

  self.message =
    Message:new(
    message,
    function()
      lander.body:destroy()
      terrain.body:destroy()
      gStateMachine:change("start")
    end
  )
end

function LandState:update(dt)
  self.message:update(dt)

  if love.keyboard.wasPressed("return") then
    lander.body:destroy()
    terrain.body:destroy()
    gStateMachine:change("start")
  end
end

function LandState:render()
  love.graphics.setColor(0.85, 0.85, 0.85)
  lander:render()

  self.message:render()
end
