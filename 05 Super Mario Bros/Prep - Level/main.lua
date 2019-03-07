-- require Dependencies.lua, itself requiring every resource needed for the project
require 'src/Dependencies'

-- in the load function set up the game's title and screen
function love.load()
  love.window.setTitle('Level Generation')

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
    ['topsheet'] = love.graphics.newImage('graphics/tile_tops.png'),
    ['backgrounds'] = love.graphics.newImage('graphics/backgrounds.png'),
    ['character'] = love.graphics.newImage('graphics/character.png')

  }

  -- assets created from the graphics
  gFrames = {
    ['tiles'] = GenerateTiles(gTextures['tilesheet']),
    ['tops'] = GenerateTops(gTextures['topsheet']),
    ['background'] = GenerateQuads(gTextures['backgrounds'], BACKGROUND_WIDTH, BACKGROUND_HEIGHT),
    ['character'] = GenerateQuads(gTextures['character'], CHARACTER_WIDTH, CHARACTER_HEIGHT)
  }


  -- initialize two variables referring to a random value in the tiles and tops tables
  tileGround = math.random(#gFrames['tiles'])
  tileTop = math.random(#gFrames['tops'])

  -- create a table in which to describe the tiles
  tiles = generateLevel()

  -- include a variable for the horizontal scroll of the camera
  cameraScroll = 0

  idleAnimation = Animation {
    frames = {1},
    interval = 1
  }
  movingAnimation = Animation {
    frames = {10, 11},
    interval = 0.1
  }
  jumpingAnimation = Animation {
    frames = {3},
    interval = 1
  }
  fallingAnimation = Animation {
    frames = {9},
    interval = 1.5
  }
  squattingAnimation = Animation {
    frames = {4},
    interval = 1.5
  }

  -- include a variable to describe the animation and direction
  -- this to have the character animated and pointing at the direction dictated through player input
  currentAnimation = idleAnimation
  currentDirection = 'right'

  --[[
  describe a table for the values needed to draw and move the character
  - x and y describing where the character ought to be positioned
  - dy describing the change in the vertical coordinate
  ]]
  gCharacter = {
    -- horizontally centered
    ['x'] = (VIRTUAL_WIDTH / 4) - (CHARACTER_WIDTH / 2),
    -- vertically right atop the ground tiles
    ['y'] = (MAP_SKY - 1) * TILE_SIZE - CHARACTER_HEIGHT,
    ['dy'] = 0
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
  -- update the dy offset of the character according to gravity
  -- dy being a negative value and gravity being a positive one means dy is slowly becoming positive and directing the character downwards
  gCharacter.dy = gCharacter.dy + GRAVITY
  -- update the vertical coordinate according to dy
  gCharacter.y = gCharacter.y + gCharacter.dy * dt

  -- set gCharacter.dy back to 0 when reaching the initial y coordinate
  if gCharacter.y >= (MAP_SKY - 1) * TILE_SIZE - CHARACTER_HEIGHT then
    gCharacter.y = (MAP_SKY - 1) * TILE_SIZE - CHARACTER_HEIGHT
    gCharacter.dy = 0

    -- set the default animation to the idle state
    currentAnimation = idleAnimation
  end

  if gCharacter.dy > 0 then
    currentAnimation = fallingAnimation
  end

  -- when the escape key is pressed quit the game early
  if love.keyboard.wasPressed('escape') then
    love.event.quit()
  end

  -- react to a key press on the up key
  -- ! only if delta y is equal to 0
  if love.keyboard.wasPressed('up') and gCharacter.dy == 0 then
    -- set dy to the amount specified in the constants file (a negative value pushing the character upwards)
    gCharacter.dy = CHARACTER_JUMP_SPEED
    currentAnimation = jumpingAnimation
  end

  -- react to the left and right keys being continuously pressed
  if love.keyboard.isDown('left') then
    -- update the position of the character
    -- ! clamp the coordinate to 0 to have the character stop when it reaches the left edge of the screen
    gCharacter.x = math.max(0, gCharacter.x - CHARACTER_SCROLL_SPEED * dt)
    currentDirection = 'left'
    if gCharacter.dy == 0 then
      currentAnimation = movingAnimation
    end
  end

  if love.keyboard.isDown('right') then
  -- update the position of the character
    gCharacter.x = gCharacter.x + CHARACTER_SCROLL_SPEED * dt
    currentDirection = 'right'
    if gCharacter.dy == 0 then
      currentAnimation = movingAnimation
    end
  end

  -- react to the bottom key being continuously pressed
  if love.keyboard.isDown('down') then
    currentAnimation = squattingAnimation
  end



  -- when the r key is pressed refresh the grid to have a new set of tiles and tops
  if love.keyboard.wasPressed('r') then
    -- select an index for the tile and top from the respective table of quads
    tileGroundRandom = math.random(#gFrames['tiles'])
    tileTopRandom = math.random(#gFrames['tops'])
    -- update the .id of each tile which references a ground tile
    for y = 1, MAP_HEIGHT do
      for x = 1, MAP_WIDTH * 2 do
        -- the conditional is set into place to avoid updating the sky tiles
        if tiles[y][x].id == tileGround then
          tiles[y][x].id = tileGroundRandom
        end
      end
    end
    -- update the reference to the variable referencing the types of tile and top
    tileGround = tileGroundRandom
    tileTop = tileTopRandom
  end

  -- update the position of the camera to have the character always perfectly centered on the screen
  -- ! clamp the scroll to 0 to never show past the left edge of the screen
  cameraScroll = math.max(0, gCharacter.x - (VIRTUAL_WIDTH / 2) + CHARACTER_WIDTH / 2)

  -- update the animation
  currentAnimation:update(dt)

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

  -- include an overlay to darken the background
  love.graphics.setColor(0, 0, 0, 0.75)
  love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

  -- include a simple string in the top left corner
  love.graphics.setFont(gFonts['big'])
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print('Level Generation', 8, 8)


  love.graphics.setFont(gFonts['small'])
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print('Press r to change colors', 8, 32)


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

      if tile.topper then
        love.graphics.draw(
          gTextures['topsheet'],
          gFrames['tops'][tileTop],
          (x - 1) * TILE_SIZE,
          (y - 1) * TILE_SIZE
        )
      end

    end
  end


  -- include the character atop the ground tiles
  love.graphics.draw(
    gTextures['character'],
    gFrames['character'][currentAnimation:getCurrentFrame()],
    -- use math.floor to avoid blur while moving the character
    currentDirection == 'right' and math.floor(gCharacter.x) or math.floor(gCharacter.x + CHARACTER_WIDTH),
    math.floor(gCharacter.y),
    0, -- rotation
    currentDirection == 'right' and 1 or -1, -- x scale
    1 -- y scale
  )

  push:finish()
end


-- function describing the levels through specific id(s) and flags
function generateLevel()
  -- initialize an empty table
  local tiles = {}
  -- populate the table with as many items as there are cells
  for y = 1, MAP_HEIGHT do
    -- one table for each column
    table.insert(tiles, {})
    for x = 1, MAP_WIDTH * 2 do
      -- one table for each cell
      -- ! detailing the actual values required for the rendering of different tiles
      table.insert(tiles[y], {
        id = y < MAP_SKY and TILE_SKY or tileGround,
        -- include a boolean describing the top of the tiles after the sky's own tiles
        topper = y == MAP_SKY and true or false
      })

    end
  end

  -- return the overarching table
  return tiles
end