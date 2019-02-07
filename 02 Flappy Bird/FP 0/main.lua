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
  love.window.setTitle('Flappy Bird')

  -- use the font specified in font.ttf
  --[[
    for each typeface
    - use love.graphics.newFont to reference a font file and its size
    - use love.graphics.setFont to detail the newly created font (it gets applied to the text which follows it)
  ]]
  gameFont = love.graphics.newFont('Resources/font.ttf', 32)
  love.graphics.setFont(gameFont)


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

]]
function love.keypressed(key)
  if key == 'q' then
    love.event.quit()
  end
end

-- on draw, render the elements in the push virtual frame of reference
function love.draw()
  -- ! instead of using push:applt('start') and the counterpart for end
  -- use push:start() and push:finish() instead
  -- push:apply('start')
  push:start()

  -- include the image through love.graphics.draw()
  -- accepting as argument the drawable (local image) and the coordinates (x, y)
  love.graphics.draw(background, 0, 0)
  -- display the ground 16px from the bottom (the height of the picture)
  love.graphics.draw(ground, 0, VIRTUAL_HEIGHT - 16)

  -- display a string in the middle of the screen
  love.graphics.printf(
    'Press enter to play',
    0,
    VIRTUAL_HEIGHT / 8 - 16,
    VIRTUAL_WIDTH,
    'center'
  )


  push:finish()
end
