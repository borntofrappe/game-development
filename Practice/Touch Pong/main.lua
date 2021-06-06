Class = require 'res/class'

require 'Ball'
require 'Paddle'

WINDOW_WIDTH = 380
WINDOW_HEIGHT = 500
PADDLE_SPEED = 100

function love.load() 
  love.window.setTitle('Touch Pong')
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.16, 0.14, 0.33)

  fontTitle = love.graphics.newFont('res/font-title.ttf', 42)
  font = love.graphics.newFont('res/font-instruction.ttf', 16)
  fontLarge = love.graphics.newFont('res/font-instruction.ttf', 24)

  ball = Ball(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 10)

  player1 = Paddle(WINDOW_WIDTH / 2, 0, 30)
  player2 = Paddle(WINDOW_WIDTH / 2, WINDOW_HEIGHT, 30)

  gameState = 'waiting'
  countdown = 3
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end

function love.mousepressed(x, y, button)
  if button == 1 then
    if gameState == 'waiting' then
      if y < WINDOW_HEIGHT / 2 then
        player1.isReady = true
      else
        player2.isReady = true
      end
      if player1.isReady and player2.isReady then 
        gameState = 'countdown'
      end
    end
  end
end

function love.mousereleased(x, y, button)
  if button == 1 then
    if gameState == 'playing' then
      if y < WINDOW_HEIGHT / 2 then
        player1.dx = 0
      else
        player2.dx = 0
      end
    end
  end
end

function love.update(dt)
  if gameState == 'countdown' then
    countdown = countdown - dt 
    if countdown <= 0 then 
      gameState = 'playing'
    end
  elseif gameState == 'playing' then
    ball:update(dt)
    player1:update(dt)
    player2:update(dt)

    if love.mouse.isDown(1) then
      local x, y = love.mouse:getPosition()
      if y < WINDOW_HEIGHT / 2 then
        if x < WINDOW_WIDTH / 2 then 
          player1.dx = PADDLE_SPEED * -1
        else
          player1.dx = PADDLE_SPEED
        end
      else
        if x < WINDOW_WIDTH / 2 then 
          player2.dx = PADDLE_SPEED * -1
        else
          player2.dx = PADDLE_SPEED
        end
      end
    end
  end
end

function love.draw()
  player1:render()
  player2:render()
  ball:render()
  
  love.graphics.translate(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
  love.graphics.setColor(0.15, 0.89, 0.89)
  love.graphics.line(-WINDOW_WIDTH / 2, 0, -24, 0)
  love.graphics.line(24, 0, WINDOW_WIDTH / 2, 0)
  love.graphics.circle('line', 0, 0, 24)
  
  if gameState == 'waiting' then 
    love.graphics.setColor(0.8, 0.93, 0.88, 1)
    love.graphics.setFont(fontTitle)
    love.graphics.printf(player2.isReady and 'Ready' or 'Touch Pong', -WINDOW_WIDTH / 2, WINDOW_HEIGHT / 4 - fontTitle:getHeight() / 2, WINDOW_WIDTH, 'center')
    love.graphics.rotate(math.pi)
    love.graphics.printf(player1.isReady and 'Ready' or 'Touch Pong', -WINDOW_WIDTH / 2, WINDOW_HEIGHT / 4 - fontTitle:getHeight() / 2, WINDOW_WIDTH, 'center')
  elseif gameState == 'countdown' then 
    love.graphics.setColor(0.8, 0.93, 0.88, 1)
    love.graphics.setFont(fontTitle)
    love.graphics.printf(math.floor(countdown) + 1, -WINDOW_WIDTH / 2, WINDOW_HEIGHT / 4 - fontTitle:getHeight() / 2, WINDOW_WIDTH, 'center')
    love.graphics.rotate(math.pi)
    love.graphics.printf(math.floor(countdown) + 1, -WINDOW_WIDTH / 2, WINDOW_HEIGHT / 4 - fontTitle:getHeight() / 2, WINDOW_WIDTH, 'center')
  end
end