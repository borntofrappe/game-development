require "src/Dependencies"

function love.load()
  love.window.setTitle("Picross")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.draw()
  love.graphics.clear(0.05, 0.05, 0.05)

  love.graphics.setColor(0.9, 0.9, 0.95)
  love.graphics.setFont(gFonts["normal"])
  love.graphics.printf(
    "There are " .. #LEVELS .. " levels waiting to be programmed.",
    0,
    WINDOW_HEIGHT / 2 - 12,
    WINDOW_WIDTH,
    "center"
  )
end
