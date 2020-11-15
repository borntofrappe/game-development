StartState = BaseState:create()

function StartState:enter(params)
  if lander.body:isDestroyed() then
    lander = Lander:new(world)
  end
  if terrain.body:isDestroyed() then
    terrain = Terrain:new(world)
  end

  local messages = {
    "Good luck",
    "Give it your best",
    "Tricky terrain"
  }

  data["time"] = 0
  data["horizontal speed"] = 0
  data["vertical speed"] = 0
  data["fuel"] = FUEL
  data["altitude"] = formatAltitude(lander.body:getY())
  self.message = messages[love.math.random(#messages)]
  self.timer = 0
end

function StartState:update(dt)
  self.timer = self.timer + dt
  if self.timer > TIMER_DELAY or love.keyboard.wasPressed("return") then
    self.timer = 0
    gStateMachine:change("orbit")
  end
end

function StartState:render()
  love.graphics.setColor(0.85, 0.85, 0.85)
  lander:render()
  love.graphics.setFont(gFonts["message"])
  love.graphics.printf(
    self.message:upper(),
    0,
    WINDOW_HEIGHT / 2 - gFonts["message"]:getHeight(),
    WINDOW_WIDTH,
    "center"
  )
end
