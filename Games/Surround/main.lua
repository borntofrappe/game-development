require "src/Dependencies"

function love.load()
  love.window.setTitle("Surround")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  love.keyboard.keyPressed = {}

  player = Player:new(1, 1)
  player:move()
end

function love.keypressed(key)
  love.keyboard.keyPressed[key] = true

  if key == "escape" then
    love.event.quit()
  end
end

function love.keyboard.wasPressed(key)
  return love.keyboard.keyPressed[key]
end

function love.update(dt)
  player:update(dt)
  love.keyboard.keyPressed = {}
end

function love.draw()
  player:render()
end
