WINDOW_WIDTH = 600
WINDOW_HEIGHT = 300
OFFSET_INCREMENT = 0.1
OFFSET_INCREMENT_MAX = 0.2
OFFSET_INCREMENT_MIN = 0.005
OFFSET_INCREMENT_CHANGE = 0.005

TIMER_INTERVAL = 0.1

function love.load()
  love.window.setTitle("Random functions")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0, 0.05, 0.12)

  local font = love.graphics.newFont("font.ttf", 14)
  love.graphics.setFont(font)

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
  love.graphics.setColor(1, 1, 1)
  love.graphics.print("Press:", 8, 8)
  love.graphics.print('"r" to use love.math.random', 8, 24)
  love.graphics.print('"n" to use love.math.noise', 8, 40)
  love.graphics.print('"down" to reduce the change in the noise offset', 8, 56)
  love.graphics.print('"up" to increase the change in the noise offset', 8, 72)

  love.graphics.printf("Current values", 0, 8, WINDOW_WIDTH - 8, "right")
  love.graphics.printf("Mode: " .. mode, 0, 24, WINDOW_WIDTH - 8, "right")
  love.graphics.printf("Offset increment: " .. offsetIncrement, 0, 40, WINDOW_WIDTH - 8, "right")

  love.graphics.circle("fill", circle.cx, circle.cy, circle.r)
end
