WINDOW_WIDTH = 380
WINDOW_HEIGHT = 500

function love.load() 
  love.window.setTitle('Touch Pong')
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.16, 0.14, 0.33)

  fontTitle = love.graphics.newFont('res/font-title.ttf', 42)
  font = love.graphics.newFont('res/font-instruction.ttf', 16)
  fontLarge = love.graphics.newFont('res/font-instruction.ttf', 24)

  startText = string.upper('Start')
  startHeight = font:getHeight() * 1.5
  startWidth = font:getWidth(startText) * 1.35
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end

function love.update(dt)

end

function love.draw()
  -- glow white
  -- light blue
  
  love.graphics.setColor(0.8, 0.93, 0.88)
  
   
  love.graphics.setColor(0.15, 0.89, 0.89, 0.25)
  love.graphics.circle('fill', WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 15, 20)
  love.graphics.setColor(0.8, 0.93, 0.88, 1)
  love.graphics.circle('fill', WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 12, 20)

  love.graphics.setColor(0.15, 0.89, 0.89)
  love.graphics.line(0, WINDOW_HEIGHT / 2, WINDOW_WIDTH / 2 - 24, WINDOW_HEIGHT / 2)
  love.graphics.line(WINDOW_WIDTH / 2 + 24, WINDOW_HEIGHT / 2, WINDOW_WIDTH, WINDOW_HEIGHT / 2)
  love.graphics.circle('line', WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 24)

  love.graphics.circle('line', WINDOW_WIDTH / 2, 0, 36)
  love.graphics.setColor(0.8, 0.93, 0.88, 1)
  love.graphics.circle('fill', WINDOW_WIDTH / 2, 0, 12, 18)

  love.graphics.setColor(0.15, 0.89, 0.89)
  love.graphics.circle('line', WINDOW_WIDTH / 2, WINDOW_HEIGHT, 36)
  love.graphics.setColor(0.8, 0.93, 0.88, 1)
  love.graphics.circle('fill', WINDOW_WIDTH / 2, WINDOW_HEIGHT, 12, 18)

  love.graphics.translate(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
  love.graphics.setColor(0.8, 0.93, 0.88, 1)
  love.graphics.setFont(fontTitle)
  love.graphics.printf('Touch Pong', -WINDOW_WIDTH / 2, WINDOW_HEIGHT / 4 - fontTitle:getHeight() / 2, WINDOW_WIDTH, 'center')
  love.graphics.rotate(math.pi)
  love.graphics.printf('Touch Pong', -WINDOW_WIDTH / 2, WINDOW_HEIGHT / 4 - fontTitle:getHeight() / 2, WINDOW_WIDTH, 'center')
end