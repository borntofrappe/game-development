require "src/Dependencies"

function love.load()
  love.window.setTitle("Minesweeper")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(
    gColors["background-light"].r,
    gColors["background-light"].g,
    gColors["background-light"].b
  )

  grid = Grid:new()
  love.mouse.buttonPressed = {}
end

function love.mousepressed(x, y, button)
  love.mouse.buttonPressed[button] = true
end

function love.mouse.wasPressed(button)
  local button = button or 1
  return love.mouse.buttonPressed[button]
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  elseif key == "r" then
    grid = Grid:new()
  end
end

function love.update(dt)
  grid:update(dt)

  love.mouse.buttonPressed = {}
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
    "000",
    WINDOW_WIDTH / 2 + 24 + gTextures["stopwatch"]:getWidth(),
    MENU_HEIGHT / 2 - gFonts["normal"]:getHeight() / 2 + 2
  )

  love.graphics.translate(PADDING_X, MENU_HEIGHT + PADDING_Y)

  grid:render()
end
