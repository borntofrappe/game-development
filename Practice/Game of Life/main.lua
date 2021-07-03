require "src/Dependencies"

local COLUMNS = 21
local ROWS = 19

local grid

function love.load()
  love.window.setTitle("Game of Life")
  love.graphics.setBackgroundColor(0.01, 0.07, 0.1)

  math.randomseed(os.time())
  love.window.setMode(0, 0)
  local WINDOW_WIDTH, WINDOW_HEIGHT = love.graphics.getDimensions()

  local CELL_SIZE = math.min(math.floor(WINDOW_WIDTH / 2 / COLUMNS), math.floor(WINDOW_HEIGHT / 1.5 / ROWS))
  grid = Grid:new(COLUMNS, ROWS, CELL_SIZE)

  GRID_OFFSET = {
    ["x"] = (WINDOW_WIDTH - grid.width) / 2,
    ["y"] = (WINDOW_HEIGHT - grid.height) / 2
  }
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  elseif key == "s" then
    grid:step()
  elseif key == "r" then
    grid:reset()
  end
end

function love.draw()
  love.graphics.translate(GRID_OFFSET.x, GRID_OFFSET.y)
  grid:render()
end
