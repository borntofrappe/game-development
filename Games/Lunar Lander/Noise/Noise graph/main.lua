WINDOW_WIDTH = 600
WINDOW_HEIGHT = 400
POINTS = WINDOW_WIDTH
OFFSET_INCREMENT = 0.015
OFFSET_INCREMENT_MAX = 0.05
OFFSET_INCREMENT_MIN = 0.005
OFFSET_INCREMENT_CHANGE = 0.005

function love.load()
  love.window.setTitle("Noise graph")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  local font = love.graphics.newFont("font.ttf", 14)
  love.graphics.setFont(font)

  offset = 0
  offsetStart = love.math.random(0, 1000)
  offsetIncrement = OFFSET_INCREMENT
  points = {}
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "down" then
    offsetIncrement = math.max(OFFSET_INCREMENT_MIN, offsetIncrement - OFFSET_INCREMENT_CHANGE)
  elseif key == "up" then
    offsetIncrement = math.min(OFFSET_INCREMENT_MAX, offsetIncrement + OFFSET_INCREMENT_CHANGE)
  end
end

function love.update(dt)
  points = {}
  offset = offsetStart
  for i = 0, POINTS do
    table.insert(points, i * (WINDOW_WIDTH / POINTS))
    table.insert(points, WINDOW_HEIGHT / 4 + love.math.noise(offset) * WINDOW_HEIGHT / 2)
    offset = offset + offsetIncrement
  end
  offsetStart = offsetStart + offsetIncrement
end

function love.draw()
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("There are " .. POINTS .. " points", 8, 8)
  love.graphics.print("The offset is increased by " .. offsetIncrement .. " at each iteration", 8, 24)
  love.graphics.line(points)
end
