-- require the push library
push = require "push"

-- require the class library
Class = require "class"

-- require the Paddle and Ball classes
require "Paddle"
require "Ball"

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
  love.graphics.setDefaultFilter("nearest", "nearest")

  -- set the title on the window
  love.window.setTitle("Pong")

  -- based on the current os time, set the seed for the random number generator, for math.random
  math.randomseed(os.time())

  -- create a new font through the local ttf file
  appFont = love.graphics.newFont("font.ttf", 8)

  -- create another instance of the font for the score, larger in size
  scoreFont = love.graphics.newFont("font.ttf", 32)

  -- set the font to be used in the application
  love.graphics.setFont(appFont)

  -- push:setupScreen works similarly to setMode, but with two additional arguments in the virtual dimensions
  push:setupScreen(
    VIRTUAL_WIDTH,
    VIRTUAL_HEIGHT,
    WINDOW_WIDTH,
    WINDOW_HEIGHT,
    {
      fullscreen = false,
      resizable = false,
      vsync = true
    }
  )

  -- create the paddles through the Paddle class
  player1 = Paddle(5, VIRTUAL_HEIGHT / 4, 5, 20)
  player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT * 3 / 4, 5, 20)

  -- create the ball through Ball class
  ball = Ball(VIRTUAL_WIDTH / 2 - 3, VIRTUAL_HEIGHT / 2 - 3, 6, 6)

  -- create a variable to keep track of the serving player
  servingPlayer = 1
  -- create a variable to keep track of the winning player
  winningPlayer = 0

  -- initialize a variable to update the game's state
  gameState = "waiting"
end

-- function responding to a key being pressed
-- accepting as argument the key being pressed
function love.keypressed(key)
  if key == "escape" then
    --[[
    when pressing enter change the state according to the following logic
    playing --> waiting
    otherwise --> playing
    ! if victory, set also the score back to 0
  ]]
    love.event.quit()
  elseif key == "enter" or key == "return" then
    if gameState == "playing" then
      gameState = "waiting"
      ball:reset()
    elseif gameState == "victory" then
      gameState = "playing"
      player1.points = 0
      player2.points = 0
    else
      gameState = "playing"
    end -- end of if .. else statement
  end -- end of if .. elseif statement
end -- end of function

-- on update, react to the keys being pressed and the game state
function love.update(dt)
  -- if serving modify the horizontal movement of the ball to direct it toward the serving player
  if gameState == "serving" then
    --[[
    if playing, update the game with the following logic
    - update the position of the ball according to the ball:update() function
    - check for a collision with the paddles
    - check for a collision with the top and bottom edges of the window
    - check for a point being scored
  ]]
    if servingPlayer == 1 then
      ball.dx = -math.random(140, 200)
    else
      ball.dx = math.random(140, 200)
    end
  elseif gameState == "playing" then
    -- if winning reset the position of the ball
    -- update the position of the ball
    ball:update(dt)

    -- collision with paddles
    -- redirect the ball back and change its incline

    -- collision player1
    if ball:collides(player1) then
      -- collision player2
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
    end -- end of if .. else if statement for the collision with paddles

    -- collision with top or bottom edge
    -- when reaching one of the edges immediately set the ball back outside of the edges' scope and switch the direction
    if ball.y <= 0 then
      ball.y = 0
      ball.dy = -ball.dy
    elseif ball.y >= VIRTUAL_HEIGHT - ball.width then
      ball.y = VIRTUAL_HEIGHT - ball.width
      ball.dy = -ball.dy
    end

    -- scoring a point (ball goes past the left or right edge)
    -- when passing past the edges of the window, update the score for the respective player and re-center the ball to its original position
    -- ! check if the scoring player has reached an arbitrary milestone, in which case set the game state to victory
    -- otherwise update the state to serving
    if ball.x < 0 then
      player2:score()
      if player2.points >= 5 then
        gameState = "victory"
        -- describe also the winning and serving player (for the following round)
        winningPlayer = 2
        servingPlayer = 1
      else
        ball:reset()
        servingPlayer = 1
        gameState = "serving"
      end
    elseif ball.x > VIRTUAL_WIDTH then
      player1:score()
      if player1.points >= 5 then
        gameState = "victory"
        winningPlayer = 1
        servingPlayer = 2
      else
        ball:reset()
        servingPlayer = 2
        gameState = "serving"
      end
    end
  elseif gameState == "victory" then
    ball:reset()
  end -- end of if..else if statement for the gameState

  -- change the dy coordinate of the classes and later call the :update function to use this value and change the vertical coordinate
  -- ! dt is already accounted for in the :update function, therefore change dy according to the speed value only
  if love.keyboard.isDown("w") then
    player1.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown("s") then
    --! the update function is run at each frame, so you need to provide a default case for those instances in which neither key is being pressed
    -- set dy back to 0, otherwise the :update() function would keep adding/removing values to the vertical coordinate
    player1.dy = PADDLE_SPEED
  else
    player1.dy = 0
  end

  -- similar considerations for right paddle, but with different keys
  if love.keyboard.isDown("up") then
    player2.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown("down") then
    player2.dy = PADDLE_SPEED
  else
    player2.dy = 0
  end

  -- call the :update function changing the vertical coordinate of the paddles
  -- ! remember to pass delta time as argument
  player1:update(dt)
  player2:update(dt)
end -- end of update function

-- on draw display the strings and the rectangles making up the game
function love.draw()
  -- wrap any drawing logic in between the push:start and push:finish functions
  push:start()

  -- before any other visual, include a solid color as background
  love.graphics.clear(6 / 255, 17 / 255, 23 / 255, 1)

  -- include a simple string of text centered in the first half of the project's height
  -- ! use the virtual dimensions, which are projected to the real ones through the push library
  -- ! set the font being used by the printf function before the function itself
  love.graphics.setFont(appFont)

  -- ! based on the state, show a different string value
  if gameState == "playing" then
    love.graphics.printf(
      "Press enter to stop",
      0,
      VIRTUAL_HEIGHT / 24,
      VIRTUAL_WIDTH, -- centered in connection to the screen's width
      "center"
    )
  else
    love.graphics.printf(
      "Press enter to play",
      0,
      VIRTUAL_HEIGHT / 24,
      VIRTUAL_WIDTH, -- centered in connection to the screen's width
      "center"
    )
  end

  -- below the general statement, highlight the serving player, but only if the gameState is serving
  if gameState == "serving" then
    love.graphics.printf(
      "Now serving: player " .. tostring(servingPlayer),
      0,
      VIRTUAL_HEIGHT / 12,
      VIRTUAL_WIDTH, -- centered in connection to the screen's width
      "center"
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
    "center"
  )

  love.graphics.printf(tostring(player2.points), VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 5, VIRTUAL_WIDTH / 4, "center")

  -- using the font of the score, describe the winning side if a victory is being registered
  if gameState == "victory" then
    love.graphics.printf(
      "Winner: player " .. tostring(winningPlayer),
      0,
      VIRTUAL_HEIGHT * 3 / 4 - 16,
      VIRTUAL_WIDTH, -- centered in connection to the screen's width
      "center"
    )
  end

  -- render the paddles through the :render function
  player1:render()
  player2:render()

  -- render the ball through the :render function
  ball:render()

  -- display the frame rate through the custom function
  displayFPS()

  push:finish()
end

-- create a function to add the frame rate in the top left corner
function displayFPS()
  -- set a font and color
  love.graphics.setFont(appFont)
  love.graphics.setColor(0, 1, 0, 1)
  -- display the frame rate using Love2D native method
  love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
end
