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

-- require the state machine class
require 'StateMachine'

-- require the different states which can be assumed by the game
require 'states/BaseState'
require 'states/TitleScreenState'
require 'states/PlayState'
require 'states/ScoreState'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- store a reference to the images in two local variables
-- using the love.graohics.newImage() function
-- accepting as argument the path to the image
local background = love.graphics.newImage('Resources/background.png')
local ground = love.graphics.newImage('Resources/ground.png')

-- on load set up the screen
function love.load()
  -- set the title of the window
  love.window.setTitle('Flippy Bird')

  -- set the random seed for the random functions included later
  math.randomseed(os.time())

  -- use the font specified in font.ttf
  --[[
    for each typeface
    - use love.graphics.newFont to reference a font file and its size
    - use love.graphics.setFont to detail the newly created font (it gets applied to the text which follows it)
  ]]
  -- create different fonts for the different strings displayed in the game
  smallFont = love.graphics.newFont('Resources/font.ttf', 8)
  normalFont = love.graphics.newFont('Resources/font.ttf', 16)
  bigFont = love.graphics.newFont('Resources/font.ttf', 48)
  -- by default use the normal font
  love.graphics.setFont(normalFont)

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

  -- store a reference to the state machine into a global variable
  -- initialize the state machine with a table referencing for each possible state a function
  -- this function returns the state itself
  gStateMachine = StateMachine {
    ['title'] = function() return TitleScreenState() end,
    ['play'] = function() return PlayState() end,
    ['score'] = function() return ScoreState() end
  }

  -- start out the state machine to show the title state
  gStateMachine:change('title')


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
-- ! include the logic of only those features which are meant to span across all possible states
-- delegate state-specific logic (like the movement of the bird and of the pipes) to the specific state class (like the play state class)
function love.update(dt)
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

  -- update the game through the state machine
  -- starting out, the update refers to the title screen, so it will instantiate the strings of text and will listen for the press event on the enter key
  gStateMachine:update(dt)

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

  -- render the game through the state machine
  -- this will in turn delegate the render to the individual state classes and render the different elements (pipes, text, bird)
  gStateMachine:render()

  -- display the ground 16px from the bottom (the height of the picture)
  love.graphics.draw(ground, -groundOffset, VIRTUAL_HEIGHT - 16)

  push:finish()
end
