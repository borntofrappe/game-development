-- require Dependencies.lua, itself requiring every resource needed for the project
require 'src/Dependencies'

-- in the load function set up the game's title and screen
function love.load()
  love.window.setTitle('Tilemaps')

  -- GLOBALS
  -- font
  gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['normal'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['big'] = love.graphics.newFont('fonts/font.ttf', 24),
    ['humongous'] = love.graphics.newFont('fonts/font.ttf', 56)
  }

  -- graphics
  -- tiles and backgrounds
  gTextures = {
    ['tilesheet'] = love.graphics.newImage('graphics/tiles.png'),
    ['backgrounds'] = love.graphics.newImage('graphics/backgrounds.png'),
  }

  -- assets created from the graphics
  -- the tiles from tiles.png (each 16x16 in size)
  -- the background from backgrounds.png (256x128 each)
  gFrames = {
    ['tiles'] = GenerateQuads(gTextures['tilesheet'], 16, 16),
    ['background'] = GenerateQuads(gTextures['backgrounds'], 256, 128)
  }

  -- PUSH
  -- virtualization set up through the push library
  love.graphics.setDefaultFilter('nearest', 'nearest')
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = true,
    vsync = true
  })

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
  -- reset keyPressed to an empty table
  love.keyboard.keyPressed = {}
end

-- DRAW
function love.draw()
  push:start()

  -- include one of the three possible backgrounds
  love.graphics.draw(
    gTextures['backgrounds'],
    gFrames['background'][2],
    0, -- x origin
    0, -- y origin
    0, -- rotation
    VIRTUAL_WIDTH / 256, -- x scale
    VIRTUAL_HEIGHT / 128 -- y scale
  )

  -- include the tiles
  love.graphics.draw(
    gTextures['tilesheet'],
    gFrames['tiles'][1],
    0,
    0
  )


  -- include a simple string in the top left corner
  love.graphics.setFont(gFonts['big'])
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print('Tilemaps', 8, 8)

  push:finish()
end



