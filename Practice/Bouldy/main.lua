require "src/Dependencies"

function love.load()
  love.window.setTitle(TITLE)

  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.17, 0.17, 0.17)

  gFonts = {
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 16)
  }

  PROGRESSBAR_HEIGHT = WINDOW_MARGIN_TOP - WINDOW_PADDING
  PROGRESSBAR_WIDTH = (WINDOW_WIDTH - WINDOW_PADDING * 2 - gFonts.normal:getWidth("\t" .. TITLE .. "\t")) / 2
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
end

function love.draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(gFonts.normal)
  love.graphics.printf(TITLE, 0, WINDOW_MARGIN_TOP - gFonts.normal:getHeight() + 1, WINDOW_WIDTH, "center")

  love.graphics.setLineWidth(2)
  love.graphics.rectangle("line", WINDOW_PADDING, WINDOW_PADDING, PROGRESSBAR_WIDTH, PROGRESSBAR_HEIGHT)
  love.graphics.rectangle(
    "line",
    WINDOW_WIDTH - WINDOW_PADDING - PROGRESSBAR_WIDTH,
    WINDOW_PADDING,
    PROGRESSBAR_WIDTH,
    PROGRESSBAR_HEIGHT
  )

  love.graphics.translate(WINDOW_PADDING, WINDOW_PADDING + WINDOW_MARGIN_TOP)
  love.graphics.rectangle("line", 0, 0, MAZE_SIZE, MAZE_SIZE)
end
