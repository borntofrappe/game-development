-- require dependencies.lua, itself calling for the necessary resources
require 'src/Dependencies'

-- in the load function set up the screen with the push library
function love.load()
  -- title of the screen
  love.window.setTitle('Match Three 0')
  -- random seed to have math.random reference different values
  math.randomseed(os.time())

  -- table for the fonts
  gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['normal'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['big'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['humongous'] = love.graphics.newFont('fonts/font.ttf', 56)
  }

  -- table for the graphics
  gTextures = {
    ['background'] = love.graphics.newImage('graphics/background.png'),
    ['spritesheet'] = love.graphics.newImage('graphics/match3.png')
  }

  -- table for the assets created on the basis of the graphics
  gFrames = {
    ['tiles'] = GenerateQuads(gTextures['spritesheet'], 32, 32)
  }

  -- variable updated to have the background always scrolling
  backgroundOffset = 0

  -- create an instance of the board class
  -- argument offsetX and offsetY, describing the position of the board on the screen
  board = Board((512-256) / 2, (288-256) / 2)

  -- virtualization through the push library
  love.graphics.setDefaultFilter('nearest', 'nearest')
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = true,
    vsync = true
  })

  -- table in which to store the last recorded key press
  love.keyboard.keyPressed = {}
end

-- in the resize function update the resolution through the push library
function love.resize(width, height)
  push:resize(width, height)
end

-- in the keypressed function keep track of the key being pressed in keyPressed
function love.keypressed(key)
  love.keyboard.keyPressed[key] = true
end

-- create a function to check whether a specific key was recorded in the keyPressed table
function love.keyboard.wasPressed(key)
  return love.keyboard.keyPressed[key]
end

-- in the update function handle the board and the position of its tiles
function love.update(dt)
  -- update the board
  board:update(dt)

  -- listen for a key press on the escape key, at which point quit the application
  if love.keyboard.wasPressed('escape') then
    love.event.quit()
  end

  -- reset keyPressed to an empty table
  love.keyboard.keyPressed = {}

  -- update backgroundOffset to have the background constantly scroll to the left
  -- 512 being half the screen's width
  backgroundOffset = (backgroundOffset - dt * BACKGROUND_SPEED) % (-512)
end


-- in the draw function render the backgrond and the board
function love.draw()
  push:start()

  -- include the background before every other graphic
  love.graphics.draw(gTextures['background'], backgroundOffset, 0)

  -- render the board
  board:render()

  push:finish()
end



