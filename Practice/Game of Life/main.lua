require "src/Dependencies"

local COLUMNS = 21
local ROWS = 19

local grid
local menu

function love.load()
  love.window.setTitle("Game of Life")
  love.graphics.setBackgroundColor(0.01, 0.07, 0.1)

  math.randomseed(os.time())
  love.window.setMode(0, 0)
  WINDOW_WIDTH, WINDOW_HEIGHT = love.graphics.getDimensions()

  local CELL_SIZE = math.min(math.floor(WINDOW_WIDTH / 2 / COLUMNS), math.floor(WINDOW_HEIGHT / 1.5 / ROWS))
  grid = Grid:new(COLUMNS, ROWS, CELL_SIZE)

  local options = {
    {
      ["text"] = "Step forward",
      ["callback"] = function()
        grid:step()
      end
    },
    {
      ["text"] = "Reset simulation",
      ["callback"] = function()
        grid:reset()
      end
    },
    {
      ["text"] = "Toggle animation",
      ["callback"] = function()
        grid:toggleAnimation()
      end
    }
  }

  menu = Menu:new(grid.x + grid.width, 0, options)
end

function love.mousepressed(x, y, button)
  if button == 1 then
    if x > grid.x and x < grid.x + grid.width and y > grid.y and y < grid.y + grid.width then
      local column = math.floor((x - grid.x) / grid.cellSize) + 1
      local row = math.floor((y - grid.y) / grid.cellSize) + 1

      grid.cells[column][row].isAlive = not grid.cells[column][row].isAlive
    end

    if x > menu.x and x < menu.x + menu.width and y > menu.y and y < menu.y + menu.height then
      for k, button in pairs(menu.buttons) do
        if x > button.x and x < button.x + button.width and y > button.y and y < button.y + button.height then
          button.callback()
          break
        end
      end
    end
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  elseif key == "s" or key == "space" then
    grid:step()
  elseif key == "r" then
    grid:reset()
  elseif key == "t" then
    grid:toggleAnimation()
  end
end

function love.update(dt)
  if grid.isAnimating then
    grid:update(dt)
  end

  local x, y = love.mouse:getPosition()
  if x > menu.x and x < menu.x + menu.width and y > menu.y and y < menu.y + menu.height then
    for k, button in pairs(menu.buttons) do
      if x > button.x and x < button.x + button.width and y > button.y and y < button.y + button.height then
        button:mouseenter()
      else
        button:mouseleave()
      end
    end
  end
end

function love.draw()
  grid:render()

  menu:render()
end
