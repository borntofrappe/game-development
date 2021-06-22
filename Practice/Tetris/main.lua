require "src/Dependencies"

function love.load()
  love.window.setTitle("Tetris")

  love.graphics.setDefaultFilter("nearest", "nearest")
  push:setupScreen(
    VIRTUAL_WIDTH,
    VIRTUAL_HEIGHT,
    WINDOW_WIDTH,
    WINDOW_HEIGHT,
    {
      fullscreen = false,
      resizable = true,
      vsync = true
    }
  )

  love.graphics.setFont(gFont)

  gFrames = GenerateQuads(gTexture, CELL_SIZE, CELL_SIZE)

  grid = Grid:new()
  info = Info:new()
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.resize(width, height)
  push:resize(width, height)
end

function love.update(dt)
end

function love.draw()
  push:start()

  love.graphics.setColor(gColors[1].r, gColors[1].g, gColors[1].b)
  love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

  grid:render()
  info:render()

  push:finish()
end
