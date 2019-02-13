-- require Dependencies.lua, itself injecting all required files and libraries
require 'src/Dependencies'

-- in the load function set the title of the game and initialize global variables
function love.load()

  love.window.setTitle('Breakout')

  -- table for the fonts
  gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['normal'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['big'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['humongous'] = love.graphics.newFont('fonts/font.ttf', 56)
  }

  -- table for the images
  gTextures = {
    ['arrows'] = love.graphics.newImage('graphics/arrows.png'),
    ['background'] = love.graphics.newImage('graphics/background.png'),
    ['blocks'] = love.graphics.newImage('graphics/blocks.png'),
    ['breakout_big'] = love.graphics.newImage('graphics/breakout_big.png'),
    ['breakout'] = love.graphics.newImage('graphics/breakout.png'),
    ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
    ['particle'] = love.graphics.newImage('graphics/particle.png'),
    ['ui'] = love.graphics.newImage('graphics/ui.png')
  }

  -- table for the sounds
  gSounds = {
    ['brick-hit-1'] = love.audio.newSource('sounds/brick-hit-1.wav', 'static'),
    ['brick-hit-2'] = love.audio.newSource('sounds/brick-hit-2.wav', 'static'),
    ['confirm'] = love.audio.newSource('sounds/confirm.wav', 'static'),
    ['high_score'] = love.audio.newSource('sounds/high_score.wav', 'static'),
    ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
    ['no-select'] = love.audio.newSource('sounds/no-select.wav', 'static'),
    ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
    ['pause'] = love.audio.newSource('sounds/pause.wav', 'static'),
    ['recover'] = love.audio.newSource('sounds/recover.wav', 'static'),
    ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
    ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
    ['victory'] = love.audio.newSource('sounds/victory.wav', 'static'),
    ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),

    ['music'] = love.audio.newSource('sounds/music.wav', 'static')
  }

  --[[
    table for the elements of the game
    - the paddles retrieved from breakout.png and through GenerateQuadsPaddles()
  ]]
  gFrames = {
    ['paddles'] = GenerateQuadsPaddles(gTextures['breakout'])
  }

  -- for the pixelated look, use the push library with a particular filter
  love.graphics.setDefaultFilter('nearest', 'nearest')
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = true,
    vsync = true
  })

  -- set up the state machine
  gStateMachine = StateMachine {
    ['start'] = function() return StartState() end,
    ['play'] = function() return PlayState() end
  }

  -- initialize the game to the start state
  gStateMachine:change('start')

  -- create an empty table on the `love.keyboard` object to store a reference the keys being pressed
  love.keyboard.keysPressed = {}
end

-- in the resize function use push:resize() to appropriately change the size of the screen
function love.resize(width, height)
  push:resize(width, height)
end


-- listen for a key press and register the specific key into the keysPressed table, with a value of true
function love.keypressed(key)
 love.keyboard.keysPressed[key] = true
end

-- create a custom function to check whether a specific key is in the keysPressed table with a value of true
function love.keyboard.wasPressed(key)
  return love.keyboard.keysPressed[key]
end

-- in the update function play the music and update the game through the state machine
function love.update(dt)
  -- play the music in a loop
  gSounds['music']:setLooping(true)
  gSounds['music']:play()

  gStateMachine:update(dt)

  -- re initialized the table registering the key being pressed to an empty table
  love.keyboard.keysPressed = {}

end

-- in the draw function include the background scaled to stretch to the screen
-- the rest of the game is rendered through the state machine
function love.draw()
  -- render the content in between the virtualization set up by the push library
  push:start()

  backgroundWidth = gTextures['background']:getWidth()
  backgroundHeight = gTextures['background']:getHeight()

  love.graphics.draw(
    gTextures['background'],
    0, -- x coordinate
    0, -- y coordinate
    0, -- rotation
    VIRTUAL_WIDTH / (backgroundWidth - 1), -- x scale, scaled to fit the screen
    VIRTUAL_HEIGHT / (backgroundHeight - 1) -- y scale, scaled to fit the screen
  )

  gStateMachine:render()

  -- include the frames per second in the top left corner
  displayFPS()

  push:finish()

end


-- create a function to display the frames per second in the top left corner
function displayFPS()
  love.graphics.setFont(gFonts['small'])
  love.graphics.setColor(0, 1, 0, 1)
  love.graphics.print(
    'FPS: ' .. tostring(love.timer.getFPS()),
    8,
    8
  )
end