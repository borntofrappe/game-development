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
  love.graphics.setColor(0, 0, 0, 0.25)
  love.graphics.setLineWidth(1)
  for column = 1, COLUMNS + 1 do
    love.graphics.line((column - 1) * CELL_SIZE, 0, (column - 1) * CELL_SIZE, WINDOW_HEIGHT)
  end
  for row = 1, ROWS + 1 do
    love.graphics.line(0, (row - 1) * CELL_SIZE, WINDOW_WIDTH, (row - 1) * CELL_SIZE)
  end

  love.graphics.setColor(0, 0, 0)
  for k, gem in pairs(gGems) do
    love.graphics.rectangle("line", gem.x, gem.y, gem.size, gem.size)
  end

  love.graphics.print("Number of gem(s): " .. #gGems, 8, 8)
end

function getGems()
  local coords = {}
  for column = 1, COLUMNS do
    coords[column] = {}
    for row = 1, ROWS do
      coords[column][row] = true
    end
  end

  local gems = {}

  for i = 1, love.math.random(GEMS_MAX) do
    local size = GEMS_SIZES[love.math.random(#GEMS_SIZES)]
    local column, row

    while true do
      column = love.math.random(COLUMNS - (size - 1))
      row = love.math.random(ROWS - (size - 1))

      local canFit = true

      for c = column, column + (size - 1) do
        for r = row, row + (size - 1) do
          if not coords[c][r] then
            canFit = false
            break
          end
        end
        if not canFit then
          break
        end
      end

      if canFit then
        break
      end
    end

    table.insert(
      gems,
      {
        ["x"] = (column - 1) * CELL_SIZE,
        ["y"] = (row - 1) * CELL_SIZE,
        ["size"] = size * CELL_SIZE
      }
    )

    for c = column, column + (size - 1) do
      for r = row, row + (size - 1) do
        coords[c][r] = false
      end
    end
  end

  return gems
end
