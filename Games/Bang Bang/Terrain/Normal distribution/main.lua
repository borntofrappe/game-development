-- good luck
WINDOW_WIDTH = 620
WINDOW_HEIGHT = 440
POINTS = 100
POINT_RADIUS = 2
EULER_NUMBER = 2.71828183

function love.load()
  love.window.setTitle("Normal distribution")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  numberPoints = POINTS
  mean = WINDOW_WIDTH / 2
  standardDeviation = 120
  factor = 50000

  points = getPoints(numberPoints, mean, standardDeviation, factor)

  showRange = false
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "t" or key == "tab" then
    showRange = not showRange
  end

  if key == "up" or key == "down" then
    if key == "up" then
      if love.keyboard.isDown("m") then
        mean = mean + 20
      end
      if love.keyboard.isDown("s") then
        standardDeviation = standardDeviation + 20
      end
      if love.keyboard.isDown("f") then
        factor = factor + 1000
      end
    elseif key == "down" then
      if love.keyboard.isDown("m") then
        mean = mean - 20
      end
      if love.keyboard.isDown("s") then
        standardDeviation = standardDeviation - 20
      end
      if love.keyboard.isDown("f") then
        factor = factor - 1000
      end
    end
    points = getPoints(numberPoints, mean, standardDeviation, factor)
  end
end

function love.draw()
  love.graphics.print("Mean: " .. mean, 8, 8)
  love.graphics.print("Standard Deviation: " .. standardDeviation, 8, 24)
  love.graphics.print("Scaling factor: " .. factor, 8, 40)

  love.graphics.setColor(0.3, 0.3, 0.3)
  for i, point in ipairs(points) do
    love.graphics.circle("fill", point.x, point.y, POINT_RADIUS)
  end

  if showRange then
    love.graphics.line(mean, WINDOW_HEIGHT / 2, mean + standardDeviation, WINDOW_HEIGHT / 2)
    love.graphics.line(mean, WINDOW_HEIGHT / 2 + 10, mean + standardDeviation * 2, WINDOW_HEIGHT / 2 + 10)
    love.graphics.line(mean, WINDOW_HEIGHT / 2 + 20, mean + standardDeviation * 3, WINDOW_HEIGHT / 2 + 20)
  end
end

function getPoints(n, mu, sigma, f)
  local points = {}
  for i = 1, n + 1 do
    local x = (i - 1) * WINDOW_WIDTH / n
    local y = WINDOW_HEIGHT - getNormalDistribution(x, sigma, mu) * f
    table.insert(
      points,
      {
        ["x"] = x,
        ["y"] = y
      }
    )
  end
  return points
end

function getNormalDistribution(x, sigma, mu)
  return 1 / (sigma * (2 * math.pi) ^ 0.5) * EULER_NUMBER ^ ((-1 / 2) * ((x - mu) / sigma) ^ 2)
end
