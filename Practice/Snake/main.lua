WINDOW_WIDTH = 500
WINDOW_HEIGHT = 400

SNAKE_SIZE = 10
FOOD_SIZE = 10
COLUMNS = 30
ROWS = 10

function love.load()
  love.window.setTitle("Snake")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.51, 0.64, 0.51)
  local font = love.graphics.newFont("res/font.ttf", 38)
  love.graphics.setFont(font)

  score = 0
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
end

function love.draw()
  love.graphics.setColor(0.15, 0.15, 0.16)
  love.graphics.print(score, 8, 8)
  love.graphics.setLineWidth(4)
  love.graphics.line(8, 50, WINDOW_WIDTH - 8, 50)

  love.graphics.line(8, 66, WINDOW_WIDTH - 8, 66, WINDOW_WIDTH - 8, WINDOW_HEIGHT - 8, 8, WINDOW_HEIGHT - 8, 8, 66)
end
