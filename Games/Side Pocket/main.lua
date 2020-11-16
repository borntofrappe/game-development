require "src/Dependencies"

function love.load()
  love.window.setTitle("Side Pocket")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  launcher = Launcher:new()

  isLaunching = false
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
  if key == "space" then
    if isLaunching then
      -- launch
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
end
