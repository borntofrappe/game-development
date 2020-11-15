OrbitState = BaseState:create()

function OrbitState:update(dt)
  if love.keyboard.wasPressed("escape") then
    gStateMachine:change("start")
  end

  data["time"] = data["time"] + dt

  local vx, vy = lander.body:getLinearVelocity()
  data["horizontal speed"] = math.floor(vx)
  data["vertical speed"] = math.floor(vy)

  world:update(dt)

  if data["fuel"] > 0 and not lander.body:isDestroyed() then
    if love.keyboard.wasPressed("up") then
      lander:burst("up")
    end

    if love.keyboard.wasPressed("right") then
      lander:burst("right")
    elseif love.keyboard.wasPressed("left") then
      lander:burst("left")
    end

    if love.keyboard.isDown("up") then
      lander:push("up")
      data["fuel"] = data["fuel"] - 1
    end

    if love.keyboard.isDown("right") then
      lander:push("right")
      data["fuel"] = data["fuel"] - 0.5
    elseif love.keyboard.isDown("left") then
      lander:push("left")
      data["fuel"] = data["fuel"] - 0.5
    end
  end
end

function OrbitState:render()
  love.graphics.setColor(0.85, 0.85, 0.85)
  lander:render()
end
