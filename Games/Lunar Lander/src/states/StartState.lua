StartState = BaseState:create()

function StartState:enter(params)
  if lander.body:isDestroyed() then
    lander = Lander:new(world)
  end
  if terrain.body:isDestroyed() then
    terrain = Terrain:new(world)
  end

  data["time"] = 0
  data["horizontal speed"] = 0
  data["vertical speed"] = 0
  data["fuel"] = FUEL
  data["altitude"] = formatAltitude(lander.body:getY())

  local messages = {
    "Good luck",
    "Give it your best",
    "Tricky terrain"
  }
  local message = messages[love.math.random(#messages)]

  self.message =
    Message:new(
    message,
    function()
      gStateMachine:change("orbit")
    end
  )
end

function StartState:update(dt)
  self.message:update(dt)

  if love.keyboard.wasPressed("return") then
    gStateMachine:change("orbit")
  end
end

function StartState:render()
  love.graphics.setColor(0.85, 0.85, 0.85)
  lander:render()

  self.message:render()
end
