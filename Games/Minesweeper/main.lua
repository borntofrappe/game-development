require "src/Dependencies"

function love.load()
  love.window.setTitle("Minesweeper")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(
    gColors["background-light"].r,
    gColors["background-light"].g,
    gColors["background-light"].b
  )

  math.randomseed(os.time())

  grid = Grid:new()
  grid:addMines()
  grid:addHints()

  timer = 0
  isPlaying = false
  isGameOver = false
end

function love.mousepressed(x, y, button)
  if isGameOver then
    isGameOver = false
    isPlaying = true
    timer = 0
    grid = Grid:new()
    grid:addMines()
    grid:addHints()
  else
    local column, row = pointToCell(x, y)
    if column then
      if not isPlaying then
        isPlaying = true
      end
      if grid.cells[column][row].hasMine then
        grid:revealAll()
        isPlaying = false
        isGameOver = true
      else
        grid:reveal(column, row)
      end
    end
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
  if isPlaying then
    timer = timer + dt
  end
end

function love.draw()
  love.graphics.setColor(gColors["background-dark"].r, gColors["background-dark"].g, gColors["background-dark"].b)
  love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, MENU_HEIGHT)

  love.graphics.setFont(gFonts["normal"])
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(
    gTextures["flag"],
    WINDOW_WIDTH / 2 - 24 - gFonts["normal"]:getWidth(MINES) - gTextures["flag"]:getWidth(),
    MENU_HEIGHT / 2 - gTextures["flag"]:getHeight() / 2
  )
  love.graphics.printf(MINES, -20, MENU_HEIGHT / 2 - gFonts["normal"]:getHeight() / 2, WINDOW_WIDTH / 2 + 2, "right")

  love.graphics.draw(
    gTextures["stopwatch"],
    WINDOW_WIDTH / 2 + 20,
    MENU_HEIGHT / 2 - gTextures["stopwatch"]:getHeight() / 2
  )
  love.graphics.print(
    formatTimer(timer),
    WINDOW_WIDTH / 2 + 24 + gTextures["stopwatch"]:getWidth(),
    MENU_HEIGHT / 2 - gFonts["normal"]:getHeight() / 2 + 2
  )

  love.graphics.translate(PADDING_X, MENU_HEIGHT + PADDING_Y)

  grid:render()
end

function pointToCell(x, y)
  if x < PADDING_X or x > WINDOW_WIDTH - PADDING_X or y < MENU_HEIGHT + PADDING_Y or y > WINDOW_HEIGHT - PADDING_Y then
    return false
  else
    local column = math.floor((x - PADDING_X) / CELL_SIZE) + 1
    local row = math.floor((y - PADDING_Y - MENU_HEIGHT) / CELL_SIZE) + 1
    return column, row
  end
end

function formatTimer(timer)
  return string.format("%03d", timer)
end
