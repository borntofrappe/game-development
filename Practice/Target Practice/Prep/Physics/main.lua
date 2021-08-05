local WINDOW_WIDTH = 540
local WINDOW_HEIGHT = 400

function love.load()
  love.window.setTitle("Physics")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.95, 0.95, 0.95)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
end

function love.draw()
  -- bonne chance
end
