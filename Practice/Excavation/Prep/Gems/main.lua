local COLUMNS = 10
local ROWS = 8
local CELL_SIZE = 40

local WINDOW_WIDTH = COLUMNS * CELL_SIZE
local WINDOW_HEIGHT = ROWS * CELL_SIZE

local GEMS_MAX = 4
local GEMS_SIZES = {1, 2, 3}

function love.load()
  love.window.setTitle("Gems")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  gGems = getGems()
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "r" then
    gGems = getGems()
  end
end

function love.draw()
  love.graphics.setColor(0, 0, 0)
  love.graphics.setLineWidth(0.5)
  for column = 1, COLUMNS + 1 do
    love.graphics.line((column - 1) * CELL_SIZE, 0, (column - 1) * CELL_SIZE, WINDOW_HEIGHT)
  end
  for row = 1, ROWS + 1 do
    love.graphics.line(0, (row - 1) * CELL_SIZE, WINDOW_WIDTH, (row - 1) * CELL_SIZE)
  end

  love.graphics.setColor(0, 0, 0)
  love.graphics.setLineWidth(5)
  for k, gem in pairs(gGems) do
    love.graphics.rectangle("line", gem.x, gem.y, gem.size, gem.size)
  end
end

function getGems()
  local layers = {}
  for k, size in pairs(GEMS_SIZES) do
    layers[size] = {}
    for column = 1, COLUMNS do
      layers[size][column] = {}
      for row = 1, ROWS do
        local isFree = column + (size - 1) <= COLUMNS and row + (size - 1) <= ROWS
        layers[size][column][row] = isFree
      end
    end
  end

  local gems = {}

  for i = 1, love.math.random(GEMS_MAX) do
    local size = GEMS_SIZES[love.math.random(#GEMS_SIZES)]
    local column, row
    repeat
      column = love.math.random(COLUMNS)
      row = love.math.random(ROWS)
    until layers[size][column][row] == true

    table.insert(
      gems,
      {
        ["x"] = (column - 1) * CELL_SIZE,
        ["y"] = (row - 1) * CELL_SIZE,
        ["size"] = size * CELL_SIZE
      }
    )

    layers[size][column][row] = false
    for c = column, column + (size - 1) do
      layers[size][c][row] = false
    end
    for r = row, row + (size - 1) do
      layers[size][column][r] = false
    end
  end

  return gems
end
