require "src/Dependencies"

function love.load()
  love.window.setTitle("Side Pocket")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  launcher = Launcher:new()
  pocketed = Pocketed:new({6, 2, 3, 5, 8})
  isLaunching = false
  force = 0
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
  if key == "space" then
    if isLaunching then
      -- launch
      force = FORCE_MULTIPLIER * launcher:getValue() / 100
      launcher:reset()

      isLaunching = false
    else
      isLaunching = true
    end
  end
end

function love.update(dt)
  if isLaunching then
    launcher:update(dt)
  end
end

function love.draw()
  launcher:render()
  pocketed:render()

  love.graphics.printf(force, 0, WINDOW_HEIGHT / 2, WINDOW_WIDTH, "center")
end
