require "src/Dependencies"

local grid = Grid:new()
local menu = Menu:new()
local state = "playing"

function love.load()
  love.window.setTitle("Minesweeper")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(
    COLORS["background-light"].r,
    COLORS["background-light"].g,
    COLORS["background-light"].b
  )
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.mousepressed(x, y, button)
  if button == 1 then
    if state == "playing" then
      if x > PADDING_X and x < WINDOW_WIDTH - PADDING_X then
        if y < MENU_HEIGHT then
          menu.isFlagSelected = not menu.isFlagSelected
        elseif y > PADDING_Y + MENU_HEIGHT and y < WINDOW_HEIGHT - PADDING_Y then
          if not menu.isUpdating then
            menu.isUpdating = true
          end

          local column = math.floor((x - PADDING_X) / CELL_SIZE) + 1
          local row = math.floor((y - PADDING_Y - MENU_HEIGHT) / CELL_SIZE) + 1

          if menu.isFlagSelected then
            grid:toggleFlag(column, row)
          else
            local hasMine = grid:reveal(column, row)
            if hasMine then
              state = "gameover"
            end
          end
        end
      end
    elseif state == "gameover" then
      grid = Grid:new()
      menu:reset()
      state = "playing"
    end
  end
end

function love.update(dt)
  if state == "playing" and menu.isUpdating then
    menu:update(dt)
  end
end

function love.draw()
  menu:render()
  love.graphics.translate(PADDING_X, PADDING_Y + MENU_HEIGHT)
  grid:render()
end
