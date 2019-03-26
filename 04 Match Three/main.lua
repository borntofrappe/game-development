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

  -- sounds
  gSounds = {
    ['clock'] = love.audio.newSource('sounds/clock.wav', 'static'),
    ['game-over'] = love.audio.newSource('sounds/game-over.wav', 'static'),
    ['match'] = love.audio.newSource('sounds/match.wav', 'static'),
    ['next-level'] = love.audio.newSource('sounds/next-level.wav', 'static'),
    ['select'] = love.audio.newSource('sounds/select.wav', 'static'),

    ['music3'] = love.audio.newSource('sounds/music3.mp3', 'static')
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

  -- table describing the coordinates and variables behind the cursor and its drag and swap feature
  cursor = {
    x = 0,
    y = 0,
    isDown = false
  }
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

-- MOUSEPRESSED
-- in the mousepressed function switch the isDown flag to true
function love.mousepressed(x, y, button)
  -- ! switch to true if the mouse is pressed through the primary button
  if button == 1 then
    cursor.isDown = true
  end
end

-- MOUSERELEASED
-- switch the isDown flag back to false
function love.mousereleased(x, y)
  cursor.isDown = false
end

-- UPDATE
function love.update(dt)
  -- play the soundtrack in a loop
  gSounds['music3']:setLooping(true)
  gSounds['music3']:play()

  -- update backgroundOffset to have the background constantly scroll to the left
  backgroundOffset = (backgroundOffset + BACKGROUND_OFFSET_SPEED * dt) % 512

  -- update the game as per the state machine
  gStateMachine:update(dt)

  -- reset keyPressed to an empty table
  love.keyboard.keyPressed = {}

  -- while the cursor is down update the x and y coordinates
  -- ! use the values through the push library and its :toGame(x, y) method
  if cursor.isDown then
    cursor.x, cursor.y = push:toGame(love.mouse.getX(), love.mouse.getY())
  end
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



