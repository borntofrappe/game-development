-- require Dependencies.lua, itself referencing the necessary files and libraries
require 'src/Dependencies'

--[[
  load function
  set up the game, in terms of title, resolution, but most importantly global variables and state machine
]]
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
    ['brick-hit-3'] = love.audio.newSource('sounds/brick-hit-3.wav', 'static'),
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
    ['power-up'] = love.audio.newSource('sounds/power-up.wav', 'static'),

    ['music'] = love.audio.newSource('sounds/music.wav', 'static')
  }

  --[[
    table for the elements of the game
    retrieved from the images in gTextures and making use of the GenerateQuads() functions
    functions described in src/Util.lua
    - paddles (different sizes and colors)
    - balls (different colors)
    - bricks (different skins and tiers)
    - locked brik (for powerup #10)
    - hearts (different icons)
    - arrows (different orientation)
    - power ups (different graphics)
  ]]
  gFrames = {
    ['paddles'] = GenerateQuadsPaddles(gTextures['breakout']),
    ['balls'] = GenerateQuadsBalls(gTextures['breakout']),
    ['bricks'] = GenerateQuadsBricks(gTextures['breakout']),
    ['locked'] = GenerateQuadsLockedBrick(gTextures['breakout']),
    ['hearts'] = GenerateQuads(gTextures['hearts'], 10, 9),
    ['arrows'] = GenerateQuads(gTextures['arrows'], 24, 24),
    ['powerups'] = GenerateQuadsPowerups(gTextures['breakout'])
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
    ['play'] = function() return PlayState() end,
    ['pause'] = function() return PauseState() end,
    ['serve'] = function() return ServeState() end,
    ['gameover'] = function() return GameoverState() end,
    ['victory'] = function() return VictoryState() end,
    ['highscore'] = function() return HighScoreState() end,
    ['enterhighscore'] = function() return EnterHighScoreState() end,
    ['paddleselect'] = function() return PaddleSelectState() end
  }

  -- load the high scores and store them in a variable
  highScores = loadHighScores()

  -- initialize the game to the start state
  -- passing to the state the table of high scores
  gStateMachine:change('start', {
    highScores = highScores
  })

  -- set a random seed
  math.randomseed(os.time())

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

  -- set the table registering the key being pressed back to an empty table
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

-- create a function to display the score in the top right corner of the screen
function displayScore(score)
  love.graphics.setFont(gFonts['small'])
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.printf(
    'Score: ' .. tostring(score),
    0,
    8,
    VIRTUAL_WIDTH - 8,
    'right'
  )
end

--[[
  create a function to display heart icons in the top section of the screen, below the score
  arguments:
  - health, current lifes left
  - maxHealth, maximum health value
]]
function displayHealth(health, maxHealth)
  -- spacing each heart by 11px, ending as the score 8px before the edge
  lastX = VIRTUAL_WIDTH - 8

  -- starting from lastX, add as many empty hearts as there are losses (maxHealth - health)
  for i = 1, (maxHealth - health) do
    love.graphics.draw(gTextures['hearts'], gFrames['hearts'][2], lastX - (i * 11), 20)
  end

  -- starting from the losses, add as many filled hearts as there are health points
  for i = (maxHealth - health + 1), maxHealth  do
    love.graphics.draw(gTextures['hearts'], gFrames['hearts'][1], lastX - (i * 11), 20)
  end
end


function loadHighScores()
  -- consider the breakout folder (with Windows 10 found in C/User/AppData/Roaming/LOVE)
  love.filesystem.setIdentity('breakout')

  -- check if the folder does not contain a list of results, in which case create one
  if not love.filesystem.getInfo('breakout.lst') then
    -- create a list with a series of entries
    local highScores = ''
    -- the list is structured with a new line for each name and new line for each score
    for i = 10, 1, -1 do
      highScores = highScores .. 'BTF\n'
      -- include higher scores for the first entries
      highScores = highScores .. tostring(5000 + 1250 * (i - 1)) .. '\n'
    end

    -- write the string to a local file
    love.filesystem.write('breakout.lst', highScores)
  end

  -- breakout.lst exist, whether available in the folder or just created
  -- read the file to create a table with the players' names and scores
  -- initialize a table in which to add the information
  local highScores = {}
  -- initialize counter to target the players one at a time
  local counter = 1
  -- initialize a boolean to consider the name and score of each player in the lst file
  -- the file stores the information one row at a time, alternatively storing the name and score
  local isName = true

  -- populate the table with 10 empty tables
  for i = 1, 10 do
    highScores[i] = {
      name = nil,
      score = nil
    }
  end

  -- read the lst file one row at a time
  for line in love.filesystem.lines('breakout.lst') do
    -- alternatively modify the name and score of each player using isName and counter
    if isName then
      highScores[counter].name = string.sub(line, 1, 3)
    else
      highScores[counter].score = tonumber(line)
      -- go to the next player
      counter = counter + 1
    end

    -- consider the name and score alternatively
    isName = not isName
  end
  -- return the highscores
  return highScores
end