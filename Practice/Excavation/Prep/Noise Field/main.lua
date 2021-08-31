local COLUMNS = 25
local ROWS = 16
local CELL_SIZE = 20

local OFFSET_INCREMENT = 0.1 -- the lower the less varied the noise field
local OFFSET_START_MAX = 1000
local ALPHA_MAX = 0.5
local VALUE_MAX = 5

local WINDOW_WIDTH = COLUMNS * CELL_SIZE
local WINDOW_HEIGHT = ROWS * CELL_SIZE

function love.load()
  love.window.setTitle("Noise Field")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  gNoiseField = getNoiseField()
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "r" then
    gNoiseField = getNoiseField()
  end
end

function love.draw()
  for k, noise in pairs(gNoiseField) do
    love.graphics.setColor(0, 0, 0, noise.alpha)
    love.graphics.rectangle("fill", noise.x, noise.y, CELL_SIZE, CELL_SIZE)

    love.graphics.setColor(0, 0, 0)
    love.graphics.printf(noise.value, noise.x, noise.y + CELL_SIZE / 2 - 8, CELL_SIZE, "center")
  end
end

function getNoiseField()
  local textures = {}
  local offsetStartColumn = love.math.random(OFFSET_START_MAX)
  local offsetStartRow = love.math.random(OFFSET_START_MAX)
  local offsetColumn = offsetStartColumn
  local offsetRow = offsetStartRow

  for column = 1, COLUMNS do
    offsetRow = 0
    for row = 1, ROWS do
      offsetRow = offsetRow + OFFSET_INCREMENT
      local x = (column - 1) * CELL_SIZE
      local y = (row - 1) * CELL_SIZE
      local noise = love.math.noise(offsetColumn, offsetRow)
      local alpha = noise * ALPHA_MAX
      local value = math.floor(noise * VALUE_MAX) + 1

      table.insert(
        textures,
        {
          ["x"] = x,
          ["y"] = y,
          ["alpha"] = alpha,
          ["value"] = value
        }
      )
    end
    offsetColumn = offsetColumn + OFFSET_INCREMENT
  end

  return textures
end
