Class = require 'res/class'

require 'Ball'
require 'Player'

WINDOW_WIDTH = 400
WINDOW_HEIGHT = 500

PADDLE_SPEED = 250
PADDLE_RADIUS = 24

BALL_SPEED_MIN_X = 50
BALL_SPEED_MAX_X = 150
BALL_SPEED_MIN_Y = 150
BALL_SPEED_MAX_Y = 250

COUNTDOWN = 3
VICTORY = 5

function love.load() 
  love.window.setTitle('Touch Pong')
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.16, 0.14, 0.33)

  font = love.graphics.newFont('res/font.ttf', 42)
  love.graphics.setFont(font)

  ball = Ball(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 10)

  player1 = Player(WINDOW_WIDTH / 2, 0)
  player2 = Player(WINDOW_WIDTH / 2, WINDOW_HEIGHT)

  sounds = {
    ["countdown"] = love.audio.newSource('res/sounds/countdown.wav', 'static'),
    ["paddle"] = love.audio.newSource('res/sounds/paddle.wav', 'static'),
    ["score"] = love.audio.newSource('res/sounds/score.wav', 'static'),
    ["gameover"] = love.audio.newSource('res/sounds/gameover.wav', 'static'),
    ["wall"] = love.audio.newSource('res/sounds/wall.wav', 'static'),
  }

  gameState = 'waiting'
  countdown = COUNTDOWN
  time = 0
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
        if not player1:isReady() then 
          sounds['paddle']:play()
        end

        player1:setReady()
      else
        if not player2:isReady() then 
          sounds['paddle']:play()
        end

        player2:setReady()
      end

      if player1:isReady() and player2:isReady() then 
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
      player1:stop()
    else
      player2:stop()
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
        player1:move('left')
      else
        player1:move('right')
      end
    else
      if x < WINDOW_WIDTH / 2 then 
        player2:move('left')
      else
        player2:move('right')
      end
    end
  end

  if gameState == 'countdown' then
    time = time + dt 
    if time > 1 then 
      time = time % 1
      countdown = countdown - 1

      sounds['countdown']:play()
    end
    if countdown == 0 then 
      gameState = 'playing'
      time = 0
      countdown = COUNTDOWN
    end
  elseif gameState == 'playing' then
    ball:update(dt)

    if ball.dy < 0 and ball:collides(player1.paddle) then 
      ball:bounce(player1.paddle)

      sounds['paddle']:play()
    end
    if ball.dy > 0 and ball:collides(player2.paddle) then
      ball:bounce(player2.paddle)

      sounds['paddle']:play()
    end

    if ball.x < ball.r then 
      ball.x = ball.r
      ball.dx = ball.dx  * -1

      sounds['wall']:play()
    end

    if ball.x > WINDOW_WIDTH - ball.r then 
      ball.x = WINDOW_WIDTH - ball.r 
      ball.dx = ball.dx * -1

      sounds['wall']:play()
    end
    
    if ball.y < -ball.r then 
      ball:reset()
      player2:score()

      sounds['score']:play()
      if player2:hasWon() then 
        gameState = 'gameover'

        sounds['gameover']:play()
      else
        player1:setReady(false)
        player2:setReady(false)
        gameState = 'waiting'
      end
    elseif ball.y > WINDOW_HEIGHT + ball.r then
      ball:reset()
      player1:score()

      sounds['score']:play()
      if player1:hasWon() then 
        gameState = 'gameover'

        sounds['gameover']:play()
      else
        player1:setReady(false)
        player2:setReady(false)
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
    love.graphics.printf(player2:isReady() and 'Ready' or 'Touch Pong', -WINDOW_WIDTH / 2, WINDOW_HEIGHT / 4 - font:getHeight() / 2, WINDOW_WIDTH, 'center')
    love.graphics.rotate(math.pi)
    love.graphics.printf(player1:isReady() and 'Ready' or 'Touch Pong', -WINDOW_WIDTH / 2, WINDOW_HEIGHT / 4 - font:getHeight() / 2, WINDOW_WIDTH, 'center')
  elseif gameState == 'countdown' then 
    love.graphics.printf(countdown, -WINDOW_WIDTH / 2, WINDOW_HEIGHT / 4 - font:getHeight() / 2, WINDOW_WIDTH, 'center')
    love.graphics.rotate(math.pi)
    love.graphics.printf(countdown, -WINDOW_WIDTH / 2, WINDOW_HEIGHT / 4 - font:getHeight() / 2, WINDOW_WIDTH, 'center')
  elseif gameState == 'gameover' then
    love.graphics.printf(player2:hasWon() and 'Congrats!' or 'Too bad...', -WINDOW_WIDTH / 2, WINDOW_HEIGHT / 4 - font:getHeight() / 2, WINDOW_WIDTH, 'center')
    love.graphics.rotate(math.pi)
    love.graphics.printf(player1:hasWon() and 'Congrats!' or 'Too bad...', -WINDOW_WIDTH / 2, WINDOW_HEIGHT / 4 - font:getHeight() / 2, WINDOW_WIDTH, 'center')
  end
end