require "Grid"
require "Cell"
Timer = require "Timer"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
PADDING = 25
COLUMNS = 10
ROWS = 10

function love.load()
  love.window.setTitle("Algorithms — Simplified Dijkstra")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.18, 0.18, 0.18)

  grid = Grid:new()
  grid:sidewinder()

  -- starting point for Dijkstra
  cell = {
    ["column"] = 1,
    ["row"] = 1,
    ["width"] = grid.cells[1][1].width,
    ["height"] = grid.cells[1][1].height
  }
end

function love.mousepressed(x, y, button)
  if button == 1 then
    Timer:reset()

    grid = Grid:new()
    grid:sidewinder()
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "r" then
    Timer:reset()

    grid = Grid:new()
    grid:sidewinder()
  end

  if key == "up" then
    cell.row = math.max(1, cell.row - 1)
  elseif key == "right" then
    cell.column = math.min(grid.columns, cell.column + 1)
  elseif key == "down" then
    cell.row = math.min(grid.rows, cell.row + 1)
  elseif key == "left" then
    cell.column = math.max(1, cell.column - 1)
  end

  if key == "return" then
    for r = 1, grid.rows do
      for c = 1, grid.columns do
        grid.cells[r][c].distance = nil
      end
    end

    Timer:reset()

    dijkstra(grid.cells[cell.row][cell.column], 0)
  end
end

function love.update(dt)
  Timer:update(dt)
end

function love.draw()
  love.graphics.translate(PADDING, PADDING)
  grid:render()

  love.graphics.setColor(1, 1, 1, 0.2)
  love.graphics.rectangle("fill", (cell.column - 1) * cell.width, (cell.row - 1) * cell.height, cell.width, cell.height)
end

--[[ Dijkstra algorithm
- mark the current cell with a "distance" value
- call the function for any accessible neighbor and with an incremented "distance" value 
]]
function dijkstra(cell, distance)
  grid.cells[cell.row][cell.column].distance = distance

  local connections = {
    {
      ["gate"] = "up",
      ["dc"] = 0,
      ["dr"] = -1
    },
    {
      ["gate"] = "right",
      ["dc"] = 1,
      ["dr"] = 0
    },
    {
      ["gate"] = "down",
      ["dc"] = 0,
      ["dr"] = 1
    },
    {
      ["gate"] = "left",
      ["dc"] = -1,
      ["dr"] = 0
    }
  }

  for i = #connections, 1, -1 do
    if
      cell.column + connections[i].dc < 1 or cell.column + connections[i].dc > grid.columns or
        cell.row + connections[i].dr < 1 or
        cell.row + connections[i].dr > grid.rows
     then
      table.remove(connections, i)
    end
  end

  for i, connection in ipairs(connections) do
    -- consider the distance to avoid visiting the same cell twice
    if
      not grid.cells[cell.row][cell.column].gates[connection.gate] and
        not grid.cells[cell.row + connection.dr][cell.column + connection.dc].distance
     then
      Timer:after(
        0.5,
        function()
          dijkstra(grid.cells[cell.row + connection.dr][cell.column + connection.dc], distance + 1)
        end
      )
    end
  end
end
