-- require the push library
push = require 'Resources/push'

-- require the class library
Class = require 'Resources/class'

-- require the Paddle and Ball classes
require 'Paddle'
require 'Ball'

--[[
global variables for the screen size
actual and virtual
the virtual measures refer to the resolution of the screen and are used by the push library to 'project' so to speak the pixelated look to the regular sizes
]]
WINDOW_WIDTH = 1080
WINDOW_HEIGHT = 608

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- global variable for the paddles' speed
PADDLE_SPEED = 200

-- on load set the size of the window, using the push library to apply the desired resolution
function love.load()
  -- filter to avoid blur
  love.graphics.setDefaultFilter('nearest', 'nearest')

  -- set the title on the window
  love.window.setTitle('Pong')

  -- based on the current os time, set the seed for the random number generator, for math.random
  math.randomseed(os.time())

  -- create a new font through the local ttf file
  appFont = love.graphics.newFont('Resources/font.ttf', 8)

  -- create another instance of the font for the score, larger in size
  scoreFont = love.graphics.newFont('Resources/font.ttf', 32)

  -- set the font to be used in the application
  love.graphics.setFont(appFont)

  -- set the audio files to be used in the application
  sounds = {
    ['playing'] = love.audio.newSource('Resources/sounds/playing.wav', 'static'),
    ['paddle_hit'] = love.audio.newSource('Resources/sounds/paddle_hit.wav', 'static'),
    ['wall_hit'] = love.audio.newSource('Resources/sounds/wall_hit.wav', 'static'),
    ['score'] = love.audio.newSource('Resources/sounds/score.wav', 'static'),
    ['victory'] = love.audio.newSource('Resources/sounds/victory.wav', 'static')
  }

  -- push:setupScreen works similarly to setMode, but with two additional arguments in the virtual dimensions
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    -- set resizable to true
    resizable = true,
    vsync = true
  })

  -- create the paddles through the Paddle class
  player1 = Paddle(5, VIRTUAL_HEIGHT / 4, 5, 20)
  player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT * 3 / 4, 5, 20)

  -- create the ball through Ball class
  ball = Ball(VIRTUAL_WIDTH / 2 - 3, VIRTUAL_HEIGHT / 2 - 3, 6, 6)

  -- create a variable to keep track of the serving player
  servingPlayer = 1
  -- create a variable to keep track of the winning player
  winningPlayer = 0

  --[[
    variables to update the position of the paddle without user input
    - startingY (the vertical coordinate of the ball in the middle of the screen)
    - startingDY (the vertical speed of the ball in the middle of the screen)
    the idea is to the paddle move only when the ball resides in the matching half
    - time (to compute the time it takes to go from the center of the screen to the edge of the pall)
    - computing (a boolean to compute the time only as the ball reaches the center of the screen or when hitting a wall)
  ]]
  startingY = 0
  startingDY = 0
  time = 0
  computing  = true

  -- initialize a variable to update the game's state
  gameState = 'waiting'

end

-- function updating the size of the push projection as the window gets resized
function love.resize(width, height)
  push:resize(width, height)
end

-- function responding to a key being pressed
-- accepting as argument the key being pressed
function love.keypressed(key)
  -- when pressing q close the program
  if key == 'q' then
    love.event.quit()
  --[[
    when pressing enter change the state according to the following logic
    playing --> waiting
    otherwise --> playing
    ! if victory, set also the score back to 0
  ]]
  elseif key == 'enter' or key == 'return' then
    if gameState == 'playing' then
      gameState = 'waiting'
      ball:reset()
    elseif gameState == 'victory' then
      gameState = 'playing'
      player1.points = 0
      player2.points = 0
      -- play the sound for the ball leaving the center of the screem
      sounds['playing']:play()
    else
      gameState = 'playing'
      -- play the sound for the ball leaving the center of the screem
      sounds['playing']:play()
      -- set computing back to true to have player1 directly consider the ball
      computing = true

    end -- end of if .. else statement

  end -- end of if .. elseif statement
end -- end of function


-- on update, react to the keys being pressed and the game state
function love.update(dt)
  -- if serving modify the horizontal movement of the ball to direct it toward the serving player
  if gameState == 'serving' then
    if servingPlayer == 1 then
      ball.dx = -math.random(140, 200)
    else
      ball.dx = math.random(140, 200)
    end
  --[[
    if playing, update the game with the following logic
    - update the position of the ball according to the ball:update() function
    - check for a collision with the paddles
    - check for a collision with the top and bottom edges of the window
    - check for a point being scored
  ]]
  elseif gameState == 'playing' then
    -- update the position of the ball
    ball:update(dt)

    -- collision with paddles
    -- redirect the ball back and change its incline

    -- collision player1
    if ball:collides(player1) then
      -- play the audio of the ball hitting a paddle
      sounds['paddle_hit']:play()
      ball.dx = -ball.dx * 1.1
      ball.x = player1.x + player1.width

      if ball.dy < 0 then
        ball.dy = -math.random(10, 150)
      else
        ball.dy = math.random(10, 150)
      end

    -- collision player2
    elseif ball:collides(player2) then
      -- play the audio of the ball hitting a paddle
      sounds['paddle_hit']:play()
      ball.dx = -ball.dx * 1.1
      ball.x = player2.x - ball.width

      if ball.dy < 0 then
        ball.dy = -math.random(10, 150)
      else
        ball.dy = math.random(10, 150)
      end

    end -- end of if .. else if statement for the collision with paddles

    -- collision with top or bottom edge
    -- when reaching one of the edges immediately set the ball back outside of the edges' scope and switch the direction
    if ball.y <= 0 then
      -- play the audio of the ball hitting a wall
      sounds['wall_hit']:play()
      ball.y = 0
      ball.dy = -ball.dy
    elseif ball.y >= VIRTUAL_HEIGHT - ball.width then
      -- play the audio of the ball hitting a wall
      sounds['wall_hit']:play()
      ball.y = VIRTUAL_HEIGHT - ball.width
      ball.dy = -ball.dy
    end

    -- scoring a point (ball goes past the left or right edge)
    -- when passing past the edges of the window, update the score for the respective player and re-center the ball to its original position
    -- ! check if the scoring player has reached an arbitrary milestone, in which case set the game state to victory
    -- otherwise update the state to serving
    if ball.x < 0 then
      -- play the audio for a point being scored
      sounds['score']:play()
      player2:score()
      if player2.points >= 10 then
        gameState = 'victory'
        -- play the sound file for a victorious outcome
        sounds['victory']:play()
        -- describe also the winning and serving player (for the following round)
        winningPlayer = 2
        servingPlayer = 1
      else
        ball:reset()
        servingPlayer = 1
        gameState = 'serving'
      end
    elseif ball.x > VIRTUAL_WIDTH then
      -- play the audio for a point being scored
      sounds['score']:play()
      player1:score()
      if player1.points >= 10 then
        gameState = 'victory'
        -- play the sound file for a victorious outcome
        sounds['victory']:play()
        winningPlayer = 1
        servingPlayer = 2
      else
        ball:reset()
        servingPlayer = 2
        gameState = 'serving'
      end
    end

  -- if winning reset the position of the ball
  elseif gameState == 'victory' then
    ball:reset()
  end -- end of if..else if statement for the gameState


  -- change the coordinate of the paddle on the right following user input, and through the up and down keys
  if love.keyboard.isDown('up') then
    player2.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown('down') then
    player2.dy = PADDLE_SPEED
  else
    player2.dy = 0
  end

  -- instead of changing player1 following user input, change it on its own according to dx and dy
  -- when the ball falls within the half of player1
  if  ball.x < VIRTUAL_WIDTH / 2 then
    -- compute where the ball will land on the basis of the coordinates and the speed of the ball
    -- ! as the coordinates change, use the boolean to compute the values only once, and avoid continuously updating the value
    if computing then
      -- set computing to false, avoiding additional computations
      -- ! set it back to true when hitting a corner or when player2 scores
      computing = false

      -- vertical coordinate in the center
      startingY = ball.y
      -- vertical speed in the center
      startingDY = ball.dy

      -- compute the time, as space / speed
      time = ball.x / math.abs(ball.dx)
      -- compute where the ball will land, as speed * time + starting space
      finalY = ball.dy * time + startingY
    end

    -- if hitting a wall (opposite signs for the original vertical speed and the new one)
    if startingDY * ball.dy < 0 then
      -- set computing to true to find once more finalY
      computing = true
    end

    -- finalY is finally where the ball will end
    -- change the position of the paddle by modifyig the speed, toward the found coordinates
    -- player1:update() takes care of clamping the paddle to the edges of the screen
    if player1.y > finalY then
      player1.dy = -PADDLE_SPEED
    elseif player1.y + player1.height < finalY then
      player1.dy = PADDLE_SPEED
    else
      player1.dy = 0
    end

  -- if the ball is in the right section set computing back to true, to compute startY once more on the way back
  else
    computing = true
  end


  -- call the :update function changing the vertical coordinate of the paddles
  -- ! remember to pass delta time as argument
  player1:update(dt)
  player2:update(dt)

end -- end of update function


-- on draw display the strings and the rectangles making up the game
function love.draw()
  -- wrap any drawing logic in between the push:apply('start') and push:apply('end') functions
  push:apply('start')

  -- before any other visual, include a solid color as background
  love.graphics.clear(6/255, 17/255, 23/255, 1)

  -- include a simple string of text centered in the first half of the project's height
  -- ! use the virtual dimensions, which are projected to the real ones through the push library
  -- ! set the font being used by the printf function before the function itself
  love.graphics.setFont(appFont)

  -- ! based on the state, show a different string value
  if gameState == 'playing' then
    love.graphics.printf(
      'Press enter to stop',
      0,
      VIRTUAL_HEIGHT / 24,
      VIRTUAL_WIDTH, -- centered in connection to the screen's width
      'center'
    )
  else
    love.graphics.printf(
      'Press enter to play',
      0,
      VIRTUAL_HEIGHT / 24,
      VIRTUAL_WIDTH, -- centered in connection to the screen's width
      'center'
    )
  end

  -- below the general statement, highlight the serving player, but only if the gameState is serving
  if gameState == 'serving' then
    love.graphics.printf(
        'Now serving: ' .. tostring(servingPlayer == 1 and 'computer' or 'player'),
        0,
        VIRTUAL_HEIGHT / 12,
        VIRTUAL_WIDTH, -- centered in connection to the screen's width
        'center'
      )
    end

  -- show the score below the game text, with the other font
  -- include two string values, for the individual score of the players
  love.graphics.setFont(scoreFont)

  -- use printf instead of print, to align the scores in the two halves of the screen
  -- use the score tracked in each paddle in the .points field
  love.graphics.printf(
    tostring(player1.points),
    -- include the score(s) closer to the center of the screen than the outer edges
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

  -- using the font of the score, describe the winning side if a victory is being registered
  if gameState == 'victory' then
    love.graphics.printf(
        'Winner: ' .. tostring(winningPlayer == 1 and 'computer' or 'player'),
        0,
        VIRTUAL_HEIGHT * 3 / 4 - 16,
        VIRTUAL_WIDTH, -- centered in connection to the screen's width
        'center'
      )
  end

  -- render the paddles through the :render function
  player1:render()
  player2:render()

  -- render the ball through the :render function
  ball:render()

  -- display the frame rate through the custom function
  displayFPS()

  push:apply('end')
end


-- create a function to add the frame rate in the top left corner
function displayFPS()
  -- set a font and color
  love.graphics.setFont(appFont)
  love.graphics.setColor(0, 1, 0, 1)
  -- display the frame rate using Love2D native method
  love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end