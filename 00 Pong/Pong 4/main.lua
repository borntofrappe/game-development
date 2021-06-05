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

-- constant for the paddles' speed
PADDLE_SPEED = 200

-- on load set the size of the window, using the push library to apply the desired resolution
function love.load()
  -- filter to avoid blur
  love.graphics.setDefaultFilter('nearest', 'nearest')

  -- create a new font through the local ttf file
  appFont = love.graphics.newFont('font.ttf', 8)

  -- create another instance of the font for the score, larger in size
  scoreFont = love.graphics.newFont('font.ttf', 32)

  -- set the font to be used in the application
  love.graphics.setFont(appFont)

  -- initialize variables to keep track of the players scores
  player1Score = 0
  player2Score = 0

  -- initialize variables to keep track of the players vertical position
  player1Y = VIRTUAL_HEIGHT / 4
  player2Y = VIRTUAL_HEIGHT * 3 / 4

  -- push:setupScreen works similarly to setMode, but with two additional arguments in the virtual dimensions
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end

-- function responding to a key being pressed
-- accepting as argument the key being pressed
function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end

-- on update, react to a key being pressed on the selected values (ws for the left paddle, up and down for the right one)
-- dt refers to the delta time, and is used to maintain uniform movement regardless of the game's frame rate
function love.update(dt)
  --[[
    left paddle
      w --> up --> subtract pixel values
      s --> down --> add
  ]]
  -- ! use an if elseif conditional to either move the paddle up or down
  if love.keyboard.isDown('w') then
    player1Y = player1Y - PADDLE_SPEED * dt
  elseif love.keyboard.isDown('s') then
    player1Y = player1Y + PADDLE_SPEED * dt
  end

  -- similar considerations for right paddle, but with different keys
  if love.keyboard.isDown('up') then
    player2Y = player2Y - PADDLE_SPEED * dt
  elseif love.keyboard.isDown('down') then
    player2Y = player2Y + PADDLE_SPEED * dt
  end
end


-- on draw print a string in the middle of the screen
function love.draw()
  -- wrap any drawing logic in between the push:start and push:finish functions
  push:start()

  -- before any other visual, include a solid color as background
  love.graphics.clear(6/255, 17/255, 23/255, 1)

  -- include a simple string of text centered in the first half of the project's height
  -- ! use the virtual dimensions, which are projected to the real ones through the push libraru
  -- ! set the font being used by the printf function before the function itself

  love.graphics.setFont(appFont)
  love.graphics.printf(
    'Playing Pong Here',
    0,
    VIRTUAL_HEIGHT / 16,
    VIRTUAL_WIDTH, -- centered in connection to the screen's width
    'center')

  -- show the score below the game text, with the other font
  -- include two string values, for the individual score of the players
  love.graphics.setFont(scoreFont)

  -- use printf instead of print, to align the scores in the two halves of the screen
  love.graphics.printf(
    tostring(player1Score),
    -- centered in the first half
    0,
    VIRTUAL_HEIGHT / 8,
    VIRTUAL_WIDTH / 2,
    'center'
  )

  love.graphics.printf(
    tostring(player2Score),
    -- centered in the second half
    VIRTUAL_WIDTH / 2,
    VIRTUAL_HEIGHT / 8,
    VIRTUAL_WIDTH / 2,
    'center'
  )


  -- include two rectangles for the paddles
  -- with 5px of padding from the window's edges
  -- using the vertical position dictated by the variables values
  love.graphics.rectangle('fill', 5, player1Y, 5, 20)

  love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)

  -- include a rectangle for the puck
  love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2, 5, 5)

  push:finish()
end