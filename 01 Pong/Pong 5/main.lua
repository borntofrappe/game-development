-- require the push library
push = require 'push'

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

  -- based on the current os time, set the seed for the random number generator, for math.random
  math.randomseed(os.time())

  -- create a new font through the local ttf file
  appFont = love.graphics.newFont('font.ttf', 8)

  -- create another instance of the font for the score, larger in size
  scoreFont = love.graphics.newFont('font.ttf', 32)

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

  -- initialize variables to keep track of the players vertical position
  player1Y = VIRTUAL_HEIGHT / 4
  player2Y = VIRTUAL_HEIGHT * 3 / 4

  -- initialize variables for the ball, it position and later its direction as it moves on the screen
  -- -3 to offset for half the width/height of the rectangle
  ballX = VIRTUAL_WIDTH / 2 - 3
  ballY = VIRTUAL_HEIGHT / 2 - 3

  -- random direction, horizontally left or right, vertical in a defined range
  ballDX = math.random(2) == 1 and 100 or -100
  ballDY = math.random(-50, 50)

  -- initialize a variable to update the game's state
  gameState = 'waiting'

end

-- function responding to a key being pressed
-- accepting as argument the key being pressed
function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  -- when pressing enter toggle the game, toggling gameState between 'waiting' and 'playing'
  elseif key == 'enter' or key == 'return' then
    if gameState == 'waiting' then
      gameState = 'playing'
    else
      gameState = 'waiting'
      -- when stopping the game, set the ball back in the middle screen
      ballX = VIRTUAL_WIDTH / 2 - 3
      ballY = VIRTUAL_HEIGHT / 2 - 3
      -- to avoid having the ball move in the same direction, set the DX and DY varibles to a new random value
      ballDX = math.random(2) == 1 and 100 or -100
      ballDY = math.random(-50, 50)

    end -- end of if .. else statement

  end -- end of if .. elseif statement
end -- end of function

-- on update, react to a key being pressed on the selected values (ws for the left paddle, up and down for the right one)
-- dt refers to the delta time, and is used to maintain uniform movement regardless of the game's frame rate
function love.update(dt)
  --[[ PADDLES ]] --
  --[[
    left paddle
      w --> up --> subtract pixel values
      s --> down --> add
  ]]
  -- ! use an if elseif conditional to either move the paddle up or down
  -- ! to avoid values smaller than 0 or greater than the window's height, clamp the values to the specified [0, height] range
  if love.keyboard.isDown('w') then
    -- going upwards, set the position to be the greater between 0 and the change introduced with the keys
    player1Y = math.max(0, player1Y - PADDLE_SPEED * dt)
  elseif love.keyboard.isDown('s') then
    -- going downward, set the position to be the less between the height of the window and the change introduced with the keys
    -- ! height of the window to which you need to subtract the height of the paddle (otherwise the rectangle would clamp, just below the visible area)
    player1Y = math.min(VIRTUAL_HEIGHT - 20, player1Y + PADDLE_SPEED * dt)
  end

  -- similar considerations for right paddle, but with different keys
  if love.keyboard.isDown('up') then
    player2Y = math.max(0, player2Y - PADDLE_SPEED * dt)
  elseif love.keyboard.isDown('down') then
    player2Y = math.min(VIRTUAL_HEIGHT - 20, player2Y + PADDLE_SPEED * dt)
  end


  --[[ BALL ]] --
  -- update the position of the ball
  -- ! update the position only when the gameState is set to play
  if gameState == 'playing' then
    ballX = ballX + ballDX * dt
    ballY = ballY + ballDY * dt
  end

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

  -- include two rectangles for the paddles
  -- with 5px of padding from the window's edges
  -- using the vertical position dictated by the variables values
  love.graphics.rectangle('fill', 5, player1Y, 5, 20)

  love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)

  -- include a rectangle for the puck
  -- a circle could be very well be drawn with the circle function, as follows
  -- love.graphics.circle('fill', VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2, 4)
  love.graphics.rectangle('fill', ballX, ballY, 6 , 6)

  push:apply('end')
end