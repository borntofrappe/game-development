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

  -- push:setupScreen works similarly to setMode, but with two additional arguments in the virtual dimensions
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = false,
    vsync = true
  })

  -- initialize variables to keep track of the players scores
  player1Score = 0
  player2Score = 0

  -- create the paddles through the Paddle class
  player1 = Paddle(5, VIRTUAL_HEIGHT / 4, 5, 20)
  player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT * 3 / 4, 5, 20)

  -- create the ball through Ball class
  ball = Ball(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2, 6, 6)


  -- initialize a variable to update the game's state
  gameState = 'waiting'

end

-- function responding to a key being pressed
-- accepting as argument the key being pressed
function love.keypressed(key)
  -- when pressing q close the program
  if key == 'q' then
    love.event.quit()
  -- when pressing enter toggle the game, toggling gameState between 'waiting' and 'playing'
  elseif key == 'enter' or key == 'return' then
    if gameState == 'waiting' then
      gameState = 'playing'
    else
      gameState = 'waiting'
      -- when stopping the game, set the ball back in the middle screen
      -- through the ball:reset function
      ball:reset()
    end -- end of if .. else statement

  end -- end of if .. elseif statement
end -- end of function


-- on update, react to a key being pressed on the selected values (ws for the left paddle, up and down for the right one)
-- dt refers to the delta time, and is used to maintain uniform movement regardless of the game's frame rate
function love.update(dt)
  --[[ PADDLES ]] --
  -- change the dy coordinate of the classes and later call the :update function to use this value and change the vertical coordinate
  -- ! dt is already accounted for in the :update function, therefore change dy according to the speed value only
  if love.keyboard.isDown('w') then
    player1.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown('s') then
    player1.dy = PADDLE_SPEED
  --! the update function is run at each frame, so you need to provide a default case for those instances in which neither key is being pressed
  -- set dy back to 0, otherwise the :update() function would keep adding/removing values to the vertical coordinate
  else
    player1.dy = 0
  end

  -- similar considerations for right paddle, but with different keys
  if love.keyboard.isDown('up') then
    player2.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown('down') then
    player2.dy = PADDLE_SPEED
  else
    player2.dy = 0
  end

  --[[
    if the game is ongoing,
    1. check if the ball collides with either of the paddles, and change the direction accordingly
    1. check the vertical coordinate of the ball, to have it bounce if it hits the top or bottom edge of the screen
  ]]

  if gameState == 'playing' then
    -- if colliding flip the horizontal direction and update the horizontal movement with a new random angle (but always the same trajectory)
    -- ! avoid overlaps by immediately seeting the horizontal coordinates pas the paddles
    if ball:collides(player1) then
      ball.dx = -ball.dx * 1.03
      ball.x = player1.x + player1.width

      if ball.dy < 0 then
        ball.dy = -math.random(10, 150)
      else
        ball.dy = math.random(10, 150)
      end

    elseif ball:collides(player2) then
      ball.dx = -ball.dx * 1.03
      ball.x = player2.x - ball.width

      if ball.dy < 0 then
        ball.dy = -math.random(10, 150)
      else
        ball.dy = math.random(10, 150)
      end
    end -- end of if .. else if statement


    -- when reaching the bottom edge immediately set the ball back to 0 and set the direction as opposite
    if ball.y <= 0 then
      ball.y = 0
      ball.dy = -ball.dy
    end

    -- when reaching the top edge, immediately set the ball back to the height of the window minus the size of the ball and again set the direction as opposite
    if ball.y >= VIRTUAL_HEIGHT - ball.width then
      ball.y = VIRTUAL_HEIGHT - ball.width
      ball.dy = -ball.dy
    end
  end


  --[[ BALL ]] --
  -- update the position of the ball
  -- ! update the position only when the gameState is set to play
  -- update the position through the :update function
  if gameState == 'playing' then
    ball:update(dt)
  end


  -- call the :update function changing the vertical coordinate of the paddles
  -- ! remember to pass delta time as argument
  player1:update(dt)
  player2:update(dt)

end


-- on draw print a string in the middle of the screen
function love.draw()
  -- wrap any drawing logic in between the push:apply('start') and push:apply('end') functions
  push:apply('start')

  -- before any other visual, include a solid color as background
  love.graphics.clear(6/255, 17/255, 23/255, 1)

  -- include a simple string of text centered in the first half of the project's height
  -- ! use the virtual dimensions, which are projected to the real ones through the push libraru
  -- ! set the font being used by the printf function before the function itself
  love.graphics.setFont(appFont)
  -- ! based on the state, show a different string value
  if gameState == 'waiting' then
    love.graphics.printf(
      'Press enter to play',
      0,
      VIRTUAL_HEIGHT / 16,
      VIRTUAL_WIDTH, -- centered in connection to the screen's width
      'center'
    )
  else
    love.graphics.printf(
      'Press enter to stop',
      0,
      VIRTUAL_HEIGHT / 16,
      VIRTUAL_WIDTH, -- centered in connection to the screen's width
      'center'
    )
  end

  -- show the score below the game text, with the other font
  -- include two string values, for the individual score of the players
  love.graphics.setFont(scoreFont)

  -- use printf instead of print, to align the scores in the two halves of the screen
  love.graphics.printf(
    tostring(player1Score),
    -- include the score(s) closer to the center of the screen than the outer edges
    VIRTUAL_WIDTH / 4,
    VIRTUAL_HEIGHT / 5,
    VIRTUAL_WIDTH / 4,
    'center'
  )

  love.graphics.printf(
    tostring(player2Score),
    VIRTUAL_WIDTH / 2,
    VIRTUAL_HEIGHT / 5,
    VIRTUAL_WIDTH / 4,
    'center'
  )

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