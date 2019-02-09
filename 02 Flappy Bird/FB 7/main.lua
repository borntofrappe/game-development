-- require push, as to render the game with a retro look
push = require 'Resources/push'
--[[
  push works as follows:
  - detail the width and height of the window
  - detail the width of the height of the frame which is then projected to the window through the push library

  - in the load function, use `push:setupScreen()` instead of `setMode`
  - in the draw function, wrap whatever needs to be rendered on the screen in between push:apply('start') and push:apply('end')

  ! if the option of resizable is set to true, remember to account for the change in width/height through the love.resize() function and the push:resize call
]]

-- require class, to work with classes and specifically the bird class
Class = require 'Resources/class'

-- require the bird class
require 'Bird'
-- require the pipe class
require 'Pipe'
-- require the pipe pair class
require 'PipePair'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- store a reference to the images in two local variables
-- using the love.graohics.newImage() function
-- accepting as argument the path to the image
local background = love.graphics.newImage('Resources/background.png')
local ground = love.graphics.newImage('Resources/ground.png')

-- create a local variable for the instance of the bird class
local bird = Bird()

-- create a table in which to insert each pipe pair shown on screen
local pipePairs = {}

-- create a variable counting the time to show the pipes at an arbitrary interval
local timerPipes = 0
-- set the interval to spawn the pipes every so often
local intervalPipes = 2.5
-- create a variable keeping track of the vertical coordinate of the previous gap
-- subtract the height of the pipe, as the pipe is later flipped upside down, to effectively reference the top of the screen
-- math.random(80) + 20 then references a distance from the top
-- ! PIPE_HEIGHT is a variable made available in the pipe class
local lastY = -PIPE_HEIGHT + math.random(80) + 20

-- initialize a variable to let the game unfold/stop the game from scrolling
local scrolling = true

-- on load set up the screen
function love.load()
  -- set the title of the window
  love.window.setTitle('Flappy Bird')

  -- set the random seed for the random functions included later
  math.randomseed(os.time())

  -- use the font specified in font.ttf
  --[[
    for each typeface
    - use love.graphics.newFont to reference a font file and its size
    - use love.graphics.setFont to detail the newly created font (it gets applied to the text which follows it)
  ]]
  gameFont = love.graphics.newFont('Resources/font.ttf', 32)
  love.graphics.setFont(gameFont)

  -- create variables for the horizontal offset of the images
  -- to give the imprssion of infinite scroll
  backgroundOffset = 0
  groundOffset = 0

  -- faster movement for the object closer to the player's point of view
  BACKGROUND_OFFSET_SPEED = 15
  GROUND_OFFSET_SPEED = 60

  -- looping point allowing to show always the same stretch of image
  -- and give the illusion of infinite scroll with a finite image
  BACKGROUND_LOOPING_POINT = 512
  GROUND_LOOPING_POINT = 512

  -- add a table in which to keep track of user input
  love.keyboard.keyPressed = {}


  -- apply the nearest nearest filter to avoid blurry shapes
  love.graphics.setDefaultFilter('nearest', 'nearest')
  -- width and height through the push library
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullScren = false,
    resizable = true,
    vsync = true
  })
end

-- on resize, account for the new width and height through the pusj library
function love.resize(width, height)
  push:resize(width, height)
end

-- on keypress (love.keypressed(key)), react to a press on arbitrary values
--[[
  - when pressing q terminate the game (love.event.quit())
  - when pressing the space bar, make the bird jump by applying a negative dy value

]]
function love.keypressed(key)
  -- update the keyPressed table with the key being pressed
  love.keyboard.keyPressed[key] = true

  if key == 'q' then
    love.event.quit()
  end
end

-- create a custom function which checks whether a key has been pressed (and is therefore registered in the table)
function love.keyboard.wasPressed(key)
  return love.keyboard.keyPressed[key]
end

-- on update increment the offset to give the illusion of movement
-- increment also the vertical movement of the bird through the dy field and call the :update(dt) function
function love.update(dt)
  -- let the game unfold only if the scrollling variable is set to true
  if scrolling then
    --[[
        retrieve the offset by computing the remainder of the following division
        total offset / looping point
      this guarantees that even when the total offset goes past the looping point, the value accounts only for the offset up to the looping point itself

      for instance, and assuming a looping point 200
      offset 50 -> 50 % 200 = 50
      offset 230 --> 230 % 200 = 30
    ]]
    backgroundOffset = (backgroundOffset + BACKGROUND_OFFSET_SPEED * dt) % BACKGROUND_LOOPING_POINT

    -- similar offsetting for the ground image, but using the appropriate variables
    groundOffset = (groundOffset + GROUND_OFFSET_SPEED * dt) % GROUND_LOOPING_POINT

    -- for the pipes, increment the timer variable
    timerPipes = timerPipes + dt
    -- when reaching rouhgly intervalPipes seconds, insert a pipe and set the timer variable back to 0
    if timerPipes > intervalPipes then
      -- define the vertical coordinate by clamping the value in a selected range
      -- ! to each value the negative - PIPE_HEIGHT is included because the asset is ultimately flipped upside down
      -- think of -PIPE_HEIGHT + 10 as 10 from the top
      -- clamp between 10 from the top and the smaller between [-20,20] around the previous coordinate and an arbitrary value from the bottom (equal to the height of the pipe and gap)
      local y = math.max(-PIPE_HEIGHT + 10, math.min(lastY + math.random(-20, 20), VIRTUAL_HEIGHT - GAP_HEIGHT - PIPE_HEIGHT))

      -- update lastY with the current value
      lastY = y

      -- insert an instance of the pipe pair class with the specified vertical coordinate
      table.insert(pipePairs, PipePair(y))
      -- set the timer back to 0 to have it go through the process of adding a pair of pipes, once more
      timerPipes = 0
    end

    -- loop through the table's items and update the position of each pipe
    -- the pairs() function allows to identify the key-value pairs
    for key, pair in pairs(pipePairs) do
      pair:update(dt)

      -- consider the individual pipes in the pair
      for l, pipe in pairs(pair.pipes) do
        -- if the bird collisdes with one of the pipes set the scrooling boolean to false
        if bird:collides(pipe) then
          scrolling = false
        end
      end

      -- check if the pair has a flag of true, and if so remove the pair from the table
      if pair.remove == true then
        table.remove(pipePairs, key)
      end
    end

    if(bird.y < VIRTUAL_HEIGHT - bird.height - 16) then
      bird:update(dt)
    end

  end

  -- re initialized the table registering the key being pressed to an empty table
  love.keyboard.keyPressed = {}
end

-- on draw, render the elements in the push virtual frame of reference
function love.draw()
  -- ! instead of using push:applt('start') and the counterpart for end
  -- use push:start() and push:finish() instead
  -- push:apply('start')
  push:start()

  -- include the image through love.graphics.draw()
  -- accepting as argument the drawable (local image) and the coordinates (x, y)
  -- ! use the offset for the horizontal coordinate
  -- ! negative values, moving the images to the left
  love.graphics.draw(background, -backgroundOffset, 0)

  -- show the pipes before the ground, to have them layered behind said asset
  for key, pair in pairs(pipePairs) do
    pair:render()
  end

  -- display the ground 16px from the bottom (the height of the picture)
  love.graphics.draw(ground, -groundOffset, VIRTUAL_HEIGHT - 16)

  -- include the bird through the :render function
  bird:render()

  -- display a string in the middle of the screen
  love.graphics.printf(
    'With a bit of leeway',
    0,
    VIRTUAL_HEIGHT / 8 - 16,
    VIRTUAL_WIDTH,
    'center'
  )

  push:finish()
end
