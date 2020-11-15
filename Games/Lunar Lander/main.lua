require "src/Dependencies"

function love.load()
  love.window.setTitle("Lunar Lander")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.05, 0.05, 0.05)

  love.physics.setMeter(METER)
  world = love.physics.newWorld(0, GRAVITY * METER, true)
  world:setCallbacks(beginContact)
  lander = Lander:new(world)
  terrain = Terrain:new(world)

  data = {
    ["score"] = 0,
    ["time"] = 0,
    ["fuel"] = FUEL,
    ["altitude"] = 0,
    ["horizontal speed"] = 0,
    ["vertical speed"] = 0
  }

  love.keyboard.keyPressed = {}
  gStateMachine =
    StateMachine:create(
    {
      ["start"] = function()
        return StartState:create()
      end,
      ["orbit"] = function()
        return OrbitState:create()
      end,
      ["crash"] = function()
        return CrashState:create()
      end,
      ["land"] = function()
        return LandState:create()
      end
    }
  )

  gStateMachine:change("start")
end

function beginContact(f1, f2, coll)
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

    if (math.abs(vx / 2) + math.abs(vy)) > VELOCITY_CRASH then
      local x, y = coll:getPositions()
      if x and y then
        gStateMachine:change(
          "crash",
          {
            ["x"] = x,
            ["y"] = y
          }
        )
      end
    else
      gStateMachine:change("land")
    end
  end
end

function love.keypressed(key)
  love.keyboard.keyPressed[key] = true
end

function love.keyboard.wasPressed(key)
  return love.keyboard.keyPressed[key]
end

function love.update(dt)
  if love.keyboard.wasPressed("escape") then
    love.event.quit()
  end

  gStateMachine:update(dt)
  love.keyboard.keyPressed = {}
end

function love.draw()
  love.graphics.setColor(0.85, 0.85, 0.85)
  terrain:render()
  displayData()
  gStateMachine:render()
end

function displayData()
  love.graphics.setFont(gFonts["data"])
  displayKeyValuePairs(
    {"score", "time", "fuel"},
    {formatNumber, formatTime, formatNumber},
    WINDOW_WIDTH / 6 + 8,
    8,
    gFonts["data"]:getWidth("score  "),
    gFonts["data"]:getHeight() * 0.9
  )

  displayKeyValuePairs(
    {"altitude", "horizontal speed", "vertical speed"},
    {nil, formatHorizontalSpeed, formatVerticalSpeed},
    WINDOW_WIDTH / 2 + 16,
    8,
    gFonts["data"]:getWidth("horizontal speed  "),
    gFonts["data"]:getHeight() * 0.9
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
