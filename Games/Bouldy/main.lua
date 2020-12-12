require "src/Dependencies"

function love.load()
  love.window.setTitle("Bouldy")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.17, 0.17, 0.17)

  maze = Maze:new(WINDOW_WIDTH - PADDING * 2, WINDOW_HEIGHT - MARGIN_TOP - PADDING * 2)
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
    maze = Maze:new(WINDOW_WIDTH - PADDING * 2, WINDOW_HEIGHT - MARGIN_TOP - PADDING * 2)
  end
end

function love.draw()
  love.graphics.setColor(gColors["light"].r, gColors["light"].g, gColors["light"].b)
  love.graphics.translate(PADDING, PADDING)
  love.graphics.setFont(gFonts["normal"])
  love.graphics.print("Bouldy", 0, 0)

  love.graphics.translate(0, MARGIN_TOP)
  maze:render()
end
