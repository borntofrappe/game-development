WINDOW_WIDTH = 400
WINDOW_HEIGHT = 400
OFFSET_INCREMENT = 0.1
OFFSET_INCREMENT_MAX = 0.2
OFFSET_INCREMENT_MIN = 0.005
OFFSET_INCREMENT_CHANGE = 0.005

TIMER_INTERVAL = 0.1

function love.load()
  love.window.setTitle("Random functions")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.8, 0.8, 0.8)

  circle = {
    ["cx"] = WINDOW_WIDTH / 2,
    ["cy"] = WINDOW_HEIGHT / 2,
    ["r"] = 10
  }

  timer = 0

  mode = "random"
  offset = 0
  offsetIncrement = OFFSET_INCREMENT
end

function love.keypressed(key)
  local key = key:lower()
  if key == "escape" then
    love.event.quit()
  end
  if key == "r" then
    mode = "random"
  elseif key == "n" then
    mode = "noise"
  elseif key == "down" then
    offsetIncrement = math.max(OFFSET_INCREMENT_MIN, offsetIncrement - OFFSET_INCREMENT_CHANGE)
  elseif key == "up" then
    offsetIncrement = math.min(OFFSET_INCREMENT_MAX, offsetIncrement + OFFSET_INCREMENT_CHANGE)
  end
end

function love.update(dt)
  timer = timer + dt
  if timer >= TIMER_INTERVAL then
    timer = timer % TIMER_INTERVAL

    if mode == "random" then
      circle.cx = circle.r + love.math.random() * WINDOW_WIDTH - circle.r
    elseif mode == "noise" then
      circle.cx = circle.r + love.math.noise(offset) * WINDOW_WIDTH - circle.r
      offset = offset + offsetIncrement
    end
  end
end

function love.draw()
  love.graphics.setColor(0.1, 0.1, 0.1)
  love.graphics.print("Function: " .. mode, 8, 8)
  if mode == "noise" then
    love.graphics.print("Increment: " .. offsetIncrement, 8, 24)
  end

  love.graphics.setColor(0.3, 0.3, 0.3)
  love.graphics.circle("fill", circle.cx, circle.cy, circle.r)
end
