-- require Dependencies.lua, itself requiring every resource needed for the project
require 'src/Dependencies'

-- in the load function set up the game's title and screen
function love.load()
  love.window.setTitle('Character')

  -- GLOBALS
  -- font
  gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['normal'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['big'] = love.graphics.newFont('fonts/font.ttf', 24),
    ['humongous'] = love.graphics.newFont('fonts/font.ttf', 56)
  }

  -- graphics
  gTextures = {
    ['tilesheet'] = love.graphics.newImage('graphics/tiles.png'),
    ['backgrounds'] = love.graphics.newImage('graphics/backgrounds.png'),
    ['character'] = love.graphics.newImage('graphics/character.png'),
  }

  -- assets created from the graphics
  gFrames = {
    ['tiles'] = GenerateQuads(gTextures['tilesheet'], TILE_SIZE, TILE_SIZE),
    ['background'] = GenerateQuads(gTextures['backgrounds'], BACKGROUND_WIDTH, BACKGROUND_HEIGHT),
    ['character'] = GenerateQuads(gTextures['character'], CHARACTER_WIDTH, CHARACTER_HEIGHT)
  }

  -- create a table in which to describe the tiles
  tiles = {}
  for y = 1, MAP_HEIGHT do
    -- insert a table for each row
    table.insert(tiles, {})
    -- insert one table describing an id for each cell
    for x = 1, MAP_WIDTH * 2 do
      table.insert(tiles[y], {
        -- include the ground tiles after as many rows as described by the MAP_SKY constant
        id = y < MAP_SKY and TILE_SKY or TILE_GROUND
      })
    end
  end

  -- include a variable for the horizontal scroll of the camera
  cameraScroll = 0

  --[[
  describe a table for the values needed to draw and move the character
  - x and y describing where the character ought to be positioned
  - stance to change the quad being drawn
  - direction to allow for the character to move to the left
  - offset to set the character in place when the direction is swapped
  ]]
  gCharacter = {
    -- horizontally centered
    ['x'] = (VIRTUAL_WIDTH / 2) - (CHARACTER_WIDTH / 2),
    -- vertically right atop the ground tiles
    ['y'] = (MAP_SKY - 1) * TILE_SIZE - CHARACTER_HEIGHT,
    ['stance'] = 1,
    ['direction'] = 1,
    ['offset'] = 0
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
  characterStance = 1

  -- when the escape key is pressed quit the game early
  if love.keyboard.wasPressed('escape') then
    love.event.quit()
  end

  if love.keyboard.isDown('left') then
    -- uodate the position of the character
    -- ! clamp the coordinate to 0 to have the character stop when it reaches the left edge of the screen
    gCharacter.x = math.max(0, gCharacter.x - CHARACTER_SCROLL_SPEED * dt)
    -- update the stance to have the character visually looking to the left
    gCharacter.stance = 2
    gCharacter.direction = -1
    gCharacter.offset = CHARACTER_WIDTH

  end

  if love.keyboard.isDown('right') then
    -- uodate the position of the character
    gCharacter.x = gCharacter.x + CHARACTER_SCROLL_SPEED * dt
    -- update the stance to have the character visually looking to the left
    gCharacter.stance = 2
    gCharacter.direction = 1
    gCharacter.offset = 0
  end

  if love.keyboard.isDown('up') then
    gCharacter.stance = 3
  end

  if love.keyboard.isDown('down') then
    gCharacter.stance = 4
  end

  -- update the position of the camera to have the character always perfectly centered on the screen
  -- ! clamp the scroll to 0 to never show past the left edge of the screen
  cameraScroll = math.max(0, gCharacter.x - (VIRTUAL_WIDTH / 2) + CHARACTER_WIDTH / 2)

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
    VIRTUAL_WIDTH / BACKGROUND_WIDTH, -- x scale
    VIRTUAL_HEIGHT / BACKGROUND_HEIGHT -- y scale
  )


  -- include a simple string in the top left corner
  love.graphics.setFont(gFonts['big'])
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print('Character', 8, 8)


  -- translate the camera using love.graphics.translate() and the cameraScroll variable
  love.graphics.translate(-math.floor(cameraScroll), 0)

  --[[
    include the tiles looping through the tiles table
  ]]
  for y = 1, MAP_HEIGHT do
    for x = 1, MAP_WIDTH * 2 do
      local tile = tiles[y][x]

      love.graphics.draw(
        gTextures['tilesheet'],
        gFrames['tiles'][tile.id],
        (x - 1) * TILE_SIZE,
        (y - 1) * TILE_SIZE
      )

    end
  end


  -- include the character atop the ground tiles
  love.graphics.draw(
    gTextures['character'],
    gFrames['character'][gCharacter.stance],
    -- use math.floor to avoid blur while moving the character
    math.floor(gCharacter.x + gCharacter.offset),
    math.floor(gCharacter.y),
    0,
    gCharacter.direction,
    1
  )

  push:finish()
end



