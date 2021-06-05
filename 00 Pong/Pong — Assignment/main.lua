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
  - AI variables
]]
function love.load()
  love.window.setTitle('Pong')
  math.randomseed(os.time())

  love.graphics.setDefaultFilter('nearest', 'nearest')

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = true,
    vsync = true
  })

  appFont = love.graphics.newFont('res/font.ttf', 8)
  scoreFont = love.graphics.newFont('res/font.ttf', 32)

  love.graphics.setFont(appFont)

  sounds = {
    ['playing'] = love.audio.newSource('res/sounds/playing.wav', 'static'),
    ['paddle_hit'] = love.audio.newSource('res/sounds/paddle_hit.wav', 'static'),
    ['wall_hit'] = love.audio.newSource('res/sounds/wall_hit.wav', 'static'),
    ['score'] = love.audio.newSource('res/sounds/score.wav', 'static'),
    ['victory'] = love.audio.newSource('res/sounds/victory.wav', 'static')
  }

  computer = Paddle(5, VIRTUAL_HEIGHT / 2, 5, 20)
  player = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT  / 2, 5, 20)

  ball = Ball(VIRTUAL_WIDTH / 2 - 3, VIRTUAL_HEIGHT / 2 - 3, 6, 6)

  servingSide = 1
  winningSide = 0
  gameState = 'waiting'

  --[[
    AI
    the idea is to 
    1. move the paddle toward ai['y']
    2. compute ai['y'] when the ball crosses ai['x'] or bounces against the top or bottom edge

    ai['looksAhead'] to avoid computing ai['y'] continuously
  ]]
  ai = {
    ['x'] = math.random(VIRTUAL_WIDTH / 2, VIRTUAL_WIDTH * 3 / 4),
    ['y'] = VIRTUAL_HEIGHT / 2,
    ['looksAhead'] = false
  }
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
      computer.points = 0
      player.points = 0
      ai['looksAhead'] = true

      sounds['playing']:play()
    else
      gameState = 'playing'
      ai['looksAhead'] = true

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
    if servingSide == 1 then
      ball.dx = ball.dx * -1
    end
  elseif gameState == 'playing' then
    ball:update(dt)

    -- collision with paddles
    if ball:collides(computer) then
      ai['looksAhead'] = true

      ball.dx = -ball.dx * 1.1
      ball.x = computer.x + computer.width
      
      if ball.dy < 0 then
        ball.dy = -math.random(10, 150)
      else
        ball.dy = math.random(10, 150)
      end

      sounds['paddle_hit']:play()
    elseif ball:collides(player) then
      ball.dx = -ball.dx * 1.1
      ball.x = player.x - ball.width

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
      ai['looksAhead'] = true

      sounds['wall_hit']:play()
    elseif ball.y >= VIRTUAL_HEIGHT - ball.width then
      ball.y = VIRTUAL_HEIGHT - ball.width
      ball.dy = -ball.dy
      ai['looksAhead'] = true

      sounds['wall_hit']:play()
    end

    -- ball outside the left or right edge 
    if ball.x < 0 then
      player:score()

      sounds['score']:play()
      if player.points >= VICTORY_THRESHOLD then
        gameState = 'victory'

        winningSide = 2
        servingSide = 1

        sounds['victory']:play()
      else
        ball:reset()
        servingSide = 1
        gameState = 'serving'
      end
    elseif ball.x > VIRTUAL_WIDTH then
      computer:score()

      sounds['score']:play()
      if computer.points >= VICTORY_THRESHOLD then
        gameState = 'victory'
        winningSide = 1
        servingSide = 2

        sounds['victory']:play()
      else
        ball:reset()
        servingSide = 2
        gameState = 'serving'
      end
    end

  elseif gameState == 'victory' then
    ball:reset()
  end 

  if love.keyboard.isDown('up') then
    player.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown('down') then
    player.dy = PADDLE_SPEED
  else
    player.dy = 0
  end

  if ai['looksAhead'] and ball.dx < 0 and ball.x < ai['x'] then 
    ai['looksAhead'] = false
    ai['x'] = math.random(VIRTUAL_WIDTH / 2, VIRTUAL_WIDTH * 3 / 4)

    -- where the ball will land as speed * time + starting y
    ai['y'] = ball.dy * ball.x / math.abs(ball.dx) + ball.y
  end

  if ball.x < ai['x'] then
    if computer.y > ai['y'] then
      computer.dy = -PADDLE_SPEED
    elseif computer.y + computer.height < ai['y'] then
      computer.dy = PADDLE_SPEED
    else
      computer.dy = 0
    end
  end

  computer:update(dt)
  player:update(dt)
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
        'Now serving: ' .. tostring(servingSide == 1 and 'computer' or 'player'),
        0,
        VIRTUAL_HEIGHT / 12,
        VIRTUAL_WIDTH, -- centered in connection to the screen's width
        'center'
      )
    end

  love.graphics.setFont(scoreFont)

  love.graphics.printf(
    tostring(computer.points),
    VIRTUAL_WIDTH / 4,
    VIRTUAL_HEIGHT / 5,
    VIRTUAL_WIDTH / 4,
    'center'
  )

  love.graphics.printf(
    tostring(player.points),
    VIRTUAL_WIDTH / 2,
    VIRTUAL_HEIGHT / 5,
    VIRTUAL_WIDTH / 4,
    'center'
  )

  if gameState == 'victory' then
    love.graphics.printf(
        'Winner: ' .. tostring(winningSide == 1 and 'computer' or 'player'),
        0,
        VIRTUAL_HEIGHT * 3 / 4 - 16,
        VIRTUAL_WIDTH,
        'center'
      )
  end

  computer:render()
  player:render()

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