WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500

function love.load()
  love.window.setTitle("Buzzing bee")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  bee = {
    ["img"] = love.graphics.newImage("bee.png"),
    ["x"] = 0,
    ["y"] = 0
  }

  bee.heigth = bee.img:getHeight()
  bee.width = bee.img:getWidth()
  offset = 0
  offsetIncrement = 0.01
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
  bee.x = love.math.noise(offset) * WINDOW_WIDTH
  bee.y = love.math.noise(offset + 1000) * WINDOW_HEIGHT

  offset = offset + offsetIncrement
end

function love.draw()
  love.graphics.draw(bee.img, bee.x, bee.y / 2, 0, 1, 1, bee.width / 2, bee.heigth / 2)
end
