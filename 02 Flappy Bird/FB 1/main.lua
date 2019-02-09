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

  -- create variables for the horizontal offset of the images
  -- to give the imprssion of infinite scroll
  backgroundOffset = 0
  groundOffset = 0

  -- faster movement for the object closer to the player's point of view
  BACKGROUND_OFFSET_SPEED = 10
  GROUND_OFFSET_SPEED = 30

  -- looping point allowing to show always the same stretch of image
  -- and give the illusion of infinite scroll with a finite image
  BACKGROUND_LOOPING_POINT = 413
  GROUND_LOOPING_POINT = 413


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

-- on update increment the offset to give the illusion of movement
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
  -- display the ground 16px from the bottom (the height of the picture)
  love.graphics.draw(ground, -groundOffset, VIRTUAL_HEIGHT - 16)

  -- display a string in the middle of the screen
  love.graphics.printf(
    'I spy with my little eye',
    0,
    VIRTUAL_HEIGHT / 8 - 16,
    VIRTUAL_WIDTH,
    'center'
  )

  love.graphics.printf(
    'A tree!',
    0,
    VIRTUAL_HEIGHT / 4 - 16,
    VIRTUAL_WIDTH,
    'center'
  )

  push:finish()
end
