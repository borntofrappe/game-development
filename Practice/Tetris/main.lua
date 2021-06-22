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

  gFont = love.graphics.newFont("res/fonts/font.ttf", 8)

  gColors = {
    {["r"] = 0.22, ["g"] = 0.22, ["b"] = 0.16},
    {["r"] = 0.48, ["g"] = 0.44, ["b"] = 0.38},
    {["r"] = 0.71, ["g"] = 0.63, ["b"] = 0.41},
    {["r"] = 0.9, ["g"] = 0.82, ["b"] = 0.61}
  }

  gTexture = love.graphics.newImage("res/graphics/spritesheet.png")

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
