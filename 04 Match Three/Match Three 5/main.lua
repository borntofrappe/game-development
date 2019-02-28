-- require dependencies.lua, itself calling for the necessary resources
require 'src/Dependencies'

-- in the load function set up the screen with the push library
function love.load()
  -- title of the screen
  love.window.setTitle('Match Three')
  -- random seed to have math.random reference different values
  math.randomseed(os.time())

  -- GLOBALS
  -- fonts
  gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['normal'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['big'] = love.graphics.newFont('fonts/font.ttf', 24),
    ['humongous'] = love.graphics.newFont('fonts/font.ttf', 56)
  }

  -- graphics
  gTextures = {
    ['background'] = love.graphics.newImage('graphics/background.png'),
    ['spritesheet'] = love.graphics.newImage('graphics/match3.png')
  }

  -- assets created from the graphics
  gFrames = {
    ['tiles'] = GenerateQuads(gTextures['spritesheet'], 32, 32)
  }

  -- STATE MACHINE
  -- create an instance of the state machine, with the possible states of the game
  gStateMachine = StateMachine {
    ['start'] = function() return StartState() end,
    ['play'] = function() return PlayState() end,
    ['gameover'] = function() return GameoverState() end
  }
  -- immediately reference the start state
  gStateMachine:change('start')


  -- PUSH LIBRARY
  -- virtualization through the push library
  love.graphics.setDefaultFilter('nearest', 'nearest')
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = true,
    vsync = true
  })

  -- variable allowing to have the background scroll
  backgroundOffset = 0

  -- table recording the different keys being pressed
  love.keyboard.keyPressed = {}
end

-- RESIZE
-- in the resize function update the resolution through the push library
function love.resize(width, height)
  push:resize(width, height)
end


-- KEYPRESSES
-- in the keypressed function keep track of the key being pressed in keyPressed
function love.keypressed(key)
  love.keyboard.keyPressed[key] = true
end

-- create a function to check whether a specific key was recorded in the keyPressed table
function love.keyboard.wasPressed(key)
  return love.keyboard.keyPressed[key]
end

-- UPDATE
function love.update(dt)
  -- update backgroundOffset to have the background constantly scroll to the left
  backgroundOffset = (backgroundOffset + BACKGROUND_OFFSET_SPEED * dt) % 512

  -- update the game as per the state machine
  gStateMachine:update(dt)

  -- reset keyPressed to an empty table
  love.keyboard.keyPressed = {}
end

-- DRAW
function love.draw()
  push:start()

  -- include the background before every other graphic
  love.graphics.draw(gTextures['background'], -backgroundOffset, 0)

  -- render the graphics as per the state machine
  gStateMachine:render()

  push:finish()
end