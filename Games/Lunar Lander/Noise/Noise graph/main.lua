WINDOW_WIDTH = 400
WINDOW_HEIGHT = 400
NUMBER_POINTS = 400
NUMBER_POINTS_MAX = 500
NUMBER_POINTS_MIN = 200
NUMBER_POINTS_CHANGE = 20

OFFSET_INCREMENT = 0.015
OFFSET_INCREMENT_MAX = 0.05
OFFSET_INCREMENT_MIN = 0.005
OFFSET_INCREMENT_CHANGE = 0.005

function love.load()
  love.window.setTitle("Noise graph")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.8, 0.8, 0.8)

  offset = 0
  offsetStart = love.math.random(1000)

  numberPoints = NUMBER_POINTS
  offsetIncrement = OFFSET_INCREMENT
  points = {}
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "up" then
    offsetIncrement = math.min(OFFSET_INCREMENT_MAX, offsetIncrement + OFFSET_INCREMENT_CHANGE)
  elseif key == "down" then
    offsetIncrement = math.max(OFFSET_INCREMENT_MIN, offsetIncrement - OFFSET_INCREMENT_CHANGE)
  elseif key == "right" then
    numberPoints = math.min(NUMBER_POINTS_MAX, numberPoints + NUMBER_POINTS_CHANGE)
  elseif key == "left" then
    numberPoints = math.max(NUMBER_POINTS_MIN, numberPoints - NUMBER_POINTS_CHANGE)
  end
end

function love.update(dt)
  points = {}
  offset = offsetStart
  for i = 0, numberPoints do
    table.insert(points, i * (WINDOW_WIDTH / numberPoints))
    table.insert(points, WINDOW_HEIGHT * 3 / 8 + love.math.noise(offset) * WINDOW_HEIGHT / 4)
    offset = offset + offsetIncrement
  end
  offsetStart = offsetStart + offsetIncrement
end

function love.draw()
  love.graphics.setColor(0.1, 0.1, 0.1)
  love.graphics.print("Points: " .. numberPoints, 8, 8)
  love.graphics.print("Increment: " .. offsetIncrement, 8, 24)
  love.graphics.setColor(0.3, 0.3, 0.3)
  love.graphics.setLineWidth(2)
  love.graphics.line(points)
end
