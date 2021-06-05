push = require 'res/push'
Class = require 'res/class'

require 'Paddle'
require 'Ball'


WINDOW_WIDTH = 1080
WINDOW_HEIGHT = 608

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

VICTORY_THRESHOLD = 5

--[[
  load
  - set title
  - set random seed
  - set the size of the window using the push library to apply the desired resolution
  - set fonts, sounds
  - initialize entities
  - state variables
]]
function love.load()
  love.window.setTitle('Pong')
  math.randomseed(os.time())

  love.graphics.setDefaultFilter('nearest', 'nearest')

  -- push:setupScreen works similarly to setMode, but with two additional arguments in the virtual dimensions
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    -- set resizable to true
    resizable = true,
    vsync = true
  })

  appFont = love.graphics.newFont('res/font.ttf', 8)
  scoreFont = love.graphics.newFont('res/font.ttf', 32)
  -- default font
  love.graphics.setFont(appFont)

  sounds = {
    ['playing'] = love.audio.newSource('res/sounds/playing.wav', 'static'),
    ['paddle_hit'] = love.audio.newSource('res/sounds/paddle_hit.wav', 'static'),
    ['wall_hit'] = love.audio.newSource('res/sounds/wall_hit.wav', 'static'),
    ['score'] = love.audio.newSource('res/sounds/score.wav', 'static'),
    ['victory'] = love.audio.newSource('res/sounds/victory.wav', 'static')
  }

  player1 = Paddle(5, VIRTUAL_HEIGHT / 4, 5, 20)
  player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT * 3 / 4, 5, 20)

  ball = Ball(VIRTUAL_WIDTH / 2 - 3, VIRTUAL_HEIGHT / 2 - 3, 6, 6)

  servingPlayer = 1
  winningPlayer = 0
  gameState = 'waiting'
end

function love.resize(width, height)
  push:resize(width, height)
end

--[[
  keys
  - escape, quit game
  - enter, change state
    playing -> waiting
    waiting -> playing
    serving -> playing
    victory -> playing + reset score
]]
function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  elseif key == 'enter' or key == 'return' then
    if gameState == 'playing' then
      gameState = 'waiting'
      ball:reset()
    elseif gameState == 'victory' then
      gameState = 'playing'
      player1.points = 0
      player2.points = 0

      sounds['playing']:play()
    else
      gameState = 'playing'

      sounds['playing']:play()
    end
  end
end

--[[
  update
  - according to state
    serving -> ball toward serving player
    playing -> update entities, check for collision and points
]]
function love.update(dt)
  if gameState == 'serving' then
    ball.dx = math.random(140, 200)
    if servingPlayer == 1 then
      ball.dx = ball.dx * -1
    end
  elseif gameState == 'playing' then
    ball:update(dt)

    -- collision with paddles
    -- redirect the ball back and change its incline
    if ball:collides(player1) then
      -- play the audio of the ball hitting a paddle
      ball.dx = -ball.dx * 1.1
      ball.x = player1.x + player1.width

      if ball.dy < 0 then
        ball.dy = -math.random(10, 150)
      else
        ball.dy = math.random(10, 150)
      end

      sounds['paddle_hit']:play()
    elseif ball:collides(player2) then
      ball.dx = -ball.dx * 1.1
      ball.x = player2.x - ball.width

      if ball.dy < 0 then
        ball.dy = -math.random(10, 150)
      else
        ball.dy = math.random(10, 150)
      end

      sounds['paddle_hit']:play()
    end

    -- collision with top or bottom edge
    if ball.y <= 0 then
      ball.y = 0
      ball.dy = -ball.dy

      sounds['wall_hit']:play()
    elseif ball.y >= VIRTUAL_HEIGHT - ball.width then
      ball.y = VIRTUAL_HEIGHT - ball.width
      ball.dy = -ball.dy

      sounds['wall_hit']:play()
    end

    -- ball outside the left or right edge 
    if ball.x < 0 then
      player2:score()

      sounds['score']:play()
      if player2.points >= VICTORY_THRESHOLD then
        gameState = 'victory'

        -- winning and serving player for the following round
        winningPlayer = 2
        servingPlayer = 1

        sounds['victory']:play()
      else
        ball:reset()
        servingPlayer = 1
        gameState = 'serving'
      end
    elseif ball.x > VIRTUAL_WIDTH then
      player1:score()

      sounds['score']:play()
      if player1.points >= VICTORY_THRESHOLD then
        gameState = 'victory'

        winningPlayer = 1
        servingPlayer = 2

        sounds['victory']:play()
      else
        ball:reset()
        servingPlayer = 2
        gameState = 'serving'
      end
    end

  -- when winning reset the position of the ball
  elseif gameState == 'victory' then
    ball:reset()
  end

  -- ! dt is already accounted for in the :update function, therefore change dy according to the speed value only
  if love.keyboard.isDown('w') then
    player1.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown('s') then
    player1.dy = PADDLE_SPEED
  -- set dy back to 0, otherwise the :update() function would keep adding or removing values to the vertical coordinate
  else
    player1.dy = 0
  end

  if love.keyboard.isDown('up') then
    player2.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown('down') then
    player2.dy = PADDLE_SPEED
  else
    player2.dy = 0
  end

  -- ! remember to pass delta time as argument
  player1:update(dt)
  player2:update(dt)

end 

--[[
  draw according to state
  push
    - background
    - text
    - entities
  push
]]
function love.draw()
  push:start()

  love.graphics.clear(6/255, 17/255, 23/255, 1)

  love.graphics.setFont(appFont)

  if gameState == 'playing' then
    love.graphics.printf(
      'Press enter to stop',
      0,
      VIRTUAL_HEIGHT / 24,
      VIRTUAL_WIDTH,
      'center'
    )
  else
    love.graphics.printf(
      'Press enter to play',
      0,
      VIRTUAL_HEIGHT / 24,
      VIRTUAL_WIDTH,
      'center'
    )
  end

  
  if gameState == 'serving' then
    love.graphics.printf(
        'Now serving: player ' .. tostring(servingPlayer),
        0,
        VIRTUAL_HEIGHT / 12,
        VIRTUAL_WIDTH,
        'center'
      )
    end

  love.graphics.setFont(scoreFont)
  love.graphics.printf(
    tostring(player1.points),
    VIRTUAL_WIDTH / 4,
    VIRTUAL_HEIGHT / 5,
    VIRTUAL_WIDTH / 4,
    'center'
  )

  love.graphics.printf(
    tostring(player2.points),
    VIRTUAL_WIDTH / 2,
    VIRTUAL_HEIGHT / 5,
    VIRTUAL_WIDTH / 4,
    'center'
  )

  if gameState == 'victory' then
    love.graphics.printf(
        'Winner: player ' .. tostring(winningPlayer),
        0,
        VIRTUAL_HEIGHT * 3 / 4 - 16,
        VIRTUAL_WIDTH,
        'center'
      )
  end

  player1:render()
  player2:render()

  ball:render()

  -- -- display the frame rate through the custom function
  -- displayFPS()

  push:finish()
end


function displayFPS()
  love.graphics.setFont(appFont)
  love.graphics.setColor(0, 1, 0, 1)
  love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end