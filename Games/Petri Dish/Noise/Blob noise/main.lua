WINDOW_WIDTH = 480
WINDOW_HEIGHT = 480

RADIUS = 30
NOISE_MAX = math.floor(RADIUS / 6)
POINTS = 50

OFFSET_INITIAL_MAX = 1000
ANGLE_CHANGE_MAX = 0.01

function love.load()
  love.window.setTitle("Blob noise")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  blobs = {}

  for column = 1, 3 do
    for row = 1, 3 do
      local x = WINDOW_WIDTH / 4 * column
      local y = WINDOW_HEIGHT / 4 * row
      local offset = love.math.random(OFFSET_INITIAL_MAX)
      local angleChange = love.math.random(50, 100) / 100 * ANGLE_CHANGE_MAX
      table.insert(
        blobs,
        {
          ["x"] = x,
          ["y"] = y,
          ["points"] = getPoints(x, y, offset),
          ["offsetInitial"] = offset,
          ["offset"] = offset,
          ["angle"] = 0,
          ["angleChange"] = love.math.random(2) == 1 and angleChange or angleChange * -1
        }
      )
    end
  end
end

function getPoints(x, y, offset)
  local points = {}

  for i = 0, math.pi * 2, math.pi * 2 / POINTS do
    local offsetX = offset + math.cos(i)
    local offsetY = offset + math.sin(i)

    local r = RADIUS + love.math.noise(offsetX, offsetY) * NOISE_MAX
    local x = x + r * math.cos(i)
    local y = y + r * math.sin(i)
    table.insert(points, x)
    table.insert(points, y)
  end
  return points
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
  for i, blob in ipairs(blobs) do
    blob.angle = blob.angle + blob.angleChange
    blob.offset = blob.offsetInitial + love.math.noise(math.cos(blob.angle), math.sin(blob.angle))
    if math.abs(blob.angle) > math.pi * 2 then
      blob.angle = blob.angle % math.pi * 2
    end
    blob.points = getPoints(blob.x, blob.y, blob.offset)
  end
end

function love.draw()
  for i, blob in ipairs(blobs) do
    love.graphics.setColor(0.3, 0.3, 0.3, 0.15)
    love.graphics.polygon("fill", blob.points)
    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.setLineWidth(4)
    love.graphics.polygon("line", blob.points)
  end
end
