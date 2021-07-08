require "src/Dependencies"

local spaceship = Spaceship:new()

function love.load()
  love.window.setTitle("Hover to Cover")
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

  love.graphics.setBackgroundColor(0.05, 0.05, 0.1)
end

function love.resize(width, height)
  push:resize(width, height)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
  spaceship:update(dt)

  if love.keyboard.isDown("up") then
    spaceship:thrust()
  end
end

function love.draw()
  push:start()

  spaceship:render()

  push:finish()
end
