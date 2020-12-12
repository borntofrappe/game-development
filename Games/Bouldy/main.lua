require "src/Dependencies"

function love.load()
  love.window.setTitle("Bouldy")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.17, 0.17, 0.17)

  maze = Maze:new(WINDOW_WIDTH - PADDING * 2, WINDOW_HEIGHT - MARGIN_TOP - PADDING * 2)
  progressBar =
    ProgressBar:new(
    WINDOW_WIDTH - PADDING - gFonts["normal"]:getWidth("Charge!"),
    PADDING,
    gFonts["normal"]:getWidth("Charge!"),
    gFonts["normal"]:getHeight()
  )
end

function love.mousepressed(x, y, button)
  if button == 1 then
    maze = Maze:new(WINDOW_WIDTH - PADDING * 2, WINDOW_HEIGHT - MARGIN_TOP - PADDING * 2)
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "r" then
    maze = Maze:new(WINDOW_WIDTH - PADDING * 2, WINDOW_HEIGHT - MARGIN_TOP - PADDING)
  end
end

function love.draw()
  love.graphics.setColor(gColors["light"].r, gColors["light"].g, gColors["light"].b)

  love.graphics.setFont(gFonts["normal"])
  love.graphics.print("Bouldy...charge!", PADDING, PADDING)

  progressBar:render()

  love.graphics.translate(PADDING, PADDING + MARGIN_TOP)
  maze:render()
end
