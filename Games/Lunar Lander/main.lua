require "src/Dependencies"

function love.load()
  love.window.setTitle("Lunar Lander")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.05, 0.05, 0.05)

  font = love.graphics.newFont("res/font.ttf", 14)
  love.graphics.setFont(font)

  data = {
    ["score"] = 0,
    ["time"] = 0,
    ["fuel"] = 1000,
    ["altitude"] = 0,
    ["horizontal speed"] = 0,
    ["vertical speed"] = 0
  }

  love.physics.setMeter(METER)
  world = love.physics.newWorld(0, GRAVITY * METER, true)
  world:setCallbacks(beginContact)

  lander = Lander:new(world)
  terrain = Terrain:new(world)

  particleImage = love.graphics.newImage("res/particle.png")
  particleSystem = love.graphics.newParticleSystem(particleImage, 200)

  particleSystem:setPosition(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
  particleSystem:setParticleLifetime(0.25, 0.75)
  particleSystem:setEmissionArea("uniform", 18, 18)
  particleSystem:setRadialAcceleration(0, 500)
  particleSystem:setLinearDamping(10, 20)
  particleSystem:setSizes(0, 1, 1, 0)
  particleSystem:setRotation(0, math.pi * 2)

  hasCrashed = false
  hasLanded = false
  message = nil
  isWaiting = false
  timer = 0
  timerWaiting = 0
end

function beginContact(f1, f2, coll)
  if not isWaiting then
    local bodies = {}
    bodies[f1:getBody():getUserData()] = true
    bodies[f2:getBody():getUserData()] = true

    if bodies["Lander"] and bodies["Terrain"] then
      local vx, vy
      if f1:getBody():getUserData() == "Lander" then
        vx, vy = f1:getBody():getLinearVelocity()
      else
        vx, vy = f2:getBody():getLinearVelocity()
      end

      if vy > VELOCITY_CRASH then
        local x, y = coll:getPositions()
        if x and y then
          particleSystem:setPosition(x, y - 5)
          particleSystem:emit(20)
          hasCrashed = true
        end
      else
        hasLanded = true
      end
    end
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if not lander.body:isDestroyed() and not isWaiting then
    if key == "up" then
      lander:burst("up")
    end

    if key == "right" then
      lander:burst("right")
    elseif key == "left" then
      lander:burst("left")
    end
  end
end

function love.update(dt)
  particleSystem:update(dt)
  world:update(dt)

  if not lander.body:isDestroyed() and not isWaiting then
    timer = timer + dt
    data["time"] = timer
    local vx, vy = lander.body:getLinearVelocity()
    data["horizontal speed"] = math.floor(vx)
    data["vertical speed"] = math.floor(vy)

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

    if hasCrashed then
      lander.body:destroy()
      message = MESSAGES["hasCrashed"][love.math.random(#MESSAGES["hasCrashed"])]
      isWaiting = true
    end

    if hasLanded then
      isWaiting = true
      message = MESSAGES["hasLanded"][love.math.random(#MESSAGES["hasLanded"])]
    end
  end

  if isWaiting then
    timerWaiting = timerWaiting + dt
    if timerWaiting > TIMER_DELAY then
      timer = 0
      timerWaiting = 0
      isWaiting = false
      message = nil
      if hasCrashed then
        lander = Lander:new(world)
        hasCrashed = false
      elseif hasLanded then
        data["score"] = data["score"] + 100
        lander.body:destroy()
        lander = Lander:new(world)
        hasLanded = false
      end
    end
  end
end

function love.draw()
  love.graphics.setColor(0.85, 0.85, 0.85)

  terrain:render()
  lander:render()
  love.graphics.draw(particleSystem)

  displayData()

  if isWaiting then
    love.graphics.printf(message, 0, WINDOW_HEIGHT / 2 - font:getHeight(), WINDOW_WIDTH, "center")
  end
end

function displayData()
  displayKeyValuePairs(
    {"score", "time", "fuel"},
    {formatNumber, formatTime, formatNumber},
    WINDOW_WIDTH / 6 + 8,
    8,
    font:getWidth("score  "),
    font:getHeight() * 0.9
  )

  displayKeyValuePairs(
    {"altitude", "horizontal speed", "vertical speed"},
    {nil, formatHorizontalSpeed, formatVerticalSpeed},
    WINDOW_WIDTH / 2 + 16,
    8,
    font:getWidth("horizontal speed  "),
    font:getHeight() * 0.9
  )
end

function displayKeyValuePairs(keys, formattingFunctions, startX, startY, gapX, gapY)
  for i, key in ipairs(keys) do
    local formattingFunction = formattingFunctions[i]
    local value = formattingFunction and formattingFunction(data[key]) or data[key]
    local y = startY + (i - 1) * gapY
    local xKey = startX
    local xValue = startX + gapX

    love.graphics.print(key:upper(), xKey, y)
    love.graphics.print(value, xValue, y)
  end
end
