Class = require 'res/class'

require 'Ball'
require 'Paddle'

WINDOW_WIDTH = 380
WINDOW_HEIGHT = 500
PADDLE_SPEED = 250
BALL_SPEED_MIN_X = 30
BALL_SPEED_MAX_X = 100
BALL_SPEED_MIN_Y = 120
BALL_SPEED_MAX_Y = 200
COUNTDOWN = 3

function love.load() 
  love.window.setTitle('Touch Pong')
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.16, 0.14, 0.33)

  font = love.graphics.newFont('res/font.ttf', 42)
  love.graphics.setFont(font)

  ball = Ball(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 10)

  player1 = Paddle(WINDOW_WIDTH / 2, 0, 24)
  player2 = Paddle(WINDOW_WIDTH / 2, WINDOW_HEIGHT, 24)

  gameState = 'waiting'
  countdown = COUNTDOWN
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
    elseif gameState == 'gameover' then 
      gameState = 'waiting'
      player1:reset()
      player2:reset()
    end
  end
end

function love.mousereleased(x, y, button)
  if button == 1 then
    if y < WINDOW_HEIGHT / 2 then
      player1.dx = 0
    else
      player2.dx = 0
    end
  end
end

function love.update(dt)
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

  if gameState == 'countdown' then
    countdown = countdown - dt 
    if countdown <= 0 then 
      gameState = 'playing'
      countdown = COUNTDOWN
    end
  elseif gameState == 'playing' then
    ball:update(dt)

    if ball.dy < 0 and ball:collides(player1) then 
      ball:bounce(player1)
    end
    if ball.dy > 0 and ball:collides(player2) then
      ball:bounce(player2)
    end
    
    if ball.y < -ball.r then 
      ball:reset()
      player2:score()
      if player2:hasWon() then 
        gameState = 'gameover'
      else
        player1:getReady()
        player2:getReady()
        gameState = 'waiting'
      end
    elseif ball.y > WINDOW_HEIGHT + ball.r then
      ball:reset()
      player1:score()
      if player1:hasWon() then 
        gameState = 'gameover'
      else
        player1:getReady()
        player2:getReady()
        gameState = 'waiting'
      end
    end
  end
end

function love.draw()
  love.graphics.setColor(0.15, 0.89, 0.89)
  love.graphics.line(0, WINDOW_HEIGHT / 2, WINDOW_WIDTH / 2 - 24, WINDOW_HEIGHT / 2)
  love.graphics.line(WINDOW_WIDTH / 2 + 24, WINDOW_HEIGHT / 2, WINDOW_WIDTH, WINDOW_HEIGHT / 2)
  love.graphics.circle('line', WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 24)

  player1:render()
  player2:render()
  ball:render()
  
  love.graphics.setColor(0.15, 0.89, 0.89)
  love.graphics.translate(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
  if gameState == 'waiting' then 
    love.graphics.printf(player2.isReady and 'Ready' or 'Touch Pong', -WINDOW_WIDTH / 2, WINDOW_HEIGHT / 4 - font:getHeight() / 2, WINDOW_WIDTH, 'center')
    love.graphics.rotate(math.pi)
    love.graphics.printf(player1.isReady and 'Ready' or 'Touch Pong', -WINDOW_WIDTH / 2, WINDOW_HEIGHT / 4 - font:getHeight() / 2, WINDOW_WIDTH, 'center')
  elseif gameState == 'countdown' then 
    love.graphics.printf(math.floor(countdown) + 1, -WINDOW_WIDTH / 2, WINDOW_HEIGHT / 4 - font:getHeight() / 2, WINDOW_WIDTH, 'center')
    love.graphics.rotate(math.pi)
    love.graphics.printf(math.floor(countdown) + 1, -WINDOW_WIDTH / 2, WINDOW_HEIGHT / 4 - font:getHeight() / 2, WINDOW_WIDTH, 'center')
  elseif gameState == 'gameover' then
    love.graphics.printf(player2:hasWon() and 'Congrats!' or 'Too bad...', -WINDOW_WIDTH / 2, WINDOW_HEIGHT / 4 - font:getHeight() / 2, WINDOW_WIDTH, 'center')
    love.graphics.rotate(math.pi)
    love.graphics.printf(player1:hasWon() and 'Congrats!' or 'Too bad...', -WINDOW_WIDTH / 2, WINDOW_HEIGHT / 4 - font:getHeight() / 2, WINDOW_WIDTH, 'center')
  end
end