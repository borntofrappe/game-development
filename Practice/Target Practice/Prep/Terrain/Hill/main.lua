WINDOW_WIDTH = 540
WINDOW_HEIGHT = 400

require "Terrain"

function love.load()
  love.window.setTitle("Terrain - Hill")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0, 0.08, 0.15)

  gTerrain = Terrain:new()
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "return" then
    gTerrain = Terrain:new()
  end
end

function love.mousepressed(x, y, button)
  if button == 1 then
    gTerrain = Terrain:new()
  end
end

function love.draw()
  gTerrain:render()
end
