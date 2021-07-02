require "src/Dependencies"

local grid = Grid:new()
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

  -- debugging
  if key == "r" then
    grid = Grid:new()
  end
end

function love.mousepressed(x, y, button)
  if button == 1 then
    if state == "playing" then
      if x > PADDING_X and x < WINDOW_WIDTH - PADDING_X and y > PADDING_Y and y < WINDOW_HEIGHT - PADDING_Y then
        local column = math.floor((x - PADDING_X) / CELL_SIZE) + 1
        local row = math.floor((y - PADDING_Y) / CELL_SIZE) + 1

        local hasMine = grid:reveal(column, row)
        if hasMine then
          state = "gameover"
        end
      end
    elseif state == "gameover" then
      grid = Grid:new()
      state = "playing"
    end
  end
end

function love.draw()
  love.graphics.translate(PADDING_X, PADDING_Y)
  grid:render()
end
