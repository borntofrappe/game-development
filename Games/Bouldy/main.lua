require "src/Dependencies"

function love.load()
  love.window.setTitle("Bouldy")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.17, 0.17, 0.17)

  maze = Maze:new()

  progressBar =
    ProgressBar:new(
    WINDOW_WIDTH - WINDOW_PADDING - gFonts["normal"]:getWidth("Charge!"),
    WINDOW_PADDING,
    gFonts["normal"]:getWidth("Charge!"),
    gFonts["normal"]:getHeight()
  )
end

function love.mousepressed(x, y, button)
  if button == 1 then
    maze = Maze:new()
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "r" then
    maze = Maze:new()
  end
end

function love.draw()
  love.graphics.setColor(gColors["light"].r, gColors["light"].g, gColors["light"].b)

  love.graphics.setFont(gFonts["normal"])
  love.graphics.print("Bouldy...charge!", WINDOW_PADDING, WINDOW_PADDING)

  progressBar:render()

  love.graphics.translate(WINDOW_PADDING, WINDOW_PADDING + WINDOW_MARGIN_TOP)
  maze:render()
end
