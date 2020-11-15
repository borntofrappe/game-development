LandState = BaseState:create()

function LandState:enter()
  self.timer = 0

  local messages = {
    "Congratulations",
    "Great job",
    "Safe landing"
  }

  data["score"] = data["score"] + (WINDOW_HEIGHT - data["altitude"]) + data["fuel"]
  self.message = messages[love.math.random(#messages)]
end

function LandState:update(dt)
  self.timer = self.timer + dt
  if self.timer > TIMER_DELAY or love.keyboard.wasPressed("return") then
    self.timer = 0
    lander.body:destroy()
    terrain.body:destroy()
    gStateMachine:change("start")
  end
end

function LandState:render()
  love.graphics.setColor(0.85, 0.85, 0.85)
  if not lander.body:isDestroyed() then
    lander:render()
  end

  love.graphics.setFont(gFonts["message"])
  love.graphics.printf(
    self.message:upper(),
    0,
    WINDOW_HEIGHT / 2 - gFonts["message"]:getHeight(),
    WINDOW_WIDTH,
    "center"
  )
end
