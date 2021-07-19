-- require "Ball"
require "Player"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 400

local player

function love.load()
  math.randomseed(os.time())
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.window.setTitle("Escape")
  love.graphics.setBackgroundColor(0.32, 0.58, 0.38)

  player = Player:new()
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "up" or key == "right" or key == "down" or key == "left" then
    player:push(key)
  end
end

function love.update(dt)
  player:update(dt)
end

function love.draw()
  player:render()
end
