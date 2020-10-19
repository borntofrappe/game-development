require "src/Dependencies"

function love.load()
  love.window.setTitle("Picross")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  level =
    Level(
    {
      ["number"] = 0,
      ["hideHints"] = true
    }
  )
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  elseif key == "space" then
    level = Level()
  end
end

function love.draw()
  love.graphics.clear(0.05, 0.05, 0.05)

  love.graphics.setColor(0.9, 0.9, 0.95)
  love.graphics.setFont(gFonts["normal"])
  love.graphics.printf(level.name, 0, 8, WINDOW_WIDTH, "center")
  love.graphics.printf("Press space to draw another level", 0, WINDOW_HEIGHT - 36, WINDOW_WIDTH, "center")

  love.graphics.translate(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
  level:render()
end
