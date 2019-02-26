-- require dependencies.lua, itself calling for the necessary resources
require 'src/Dependencies'

-- in the load function set up the screen with the push library
function love.load()
  -- title of the screen
  love.window.setTitle('Swap swap swap')
  -- random seed to have math.random reference different values
  math.randomseed(os.time())

  -- table for the fonts
  gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['normal'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['big'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['humongous'] = love.graphics.newFont('fonts/font.ttf', 56)
  }

  -- image making up the grid
  tileSprite = love.graphics.newImage('graphics/match3.png')
  -- table describing the tiles from the image
  tileQuads = GenerateQuads(tileSprite, 32, 32)

  -- table making up the grid
  board = generateBoard()

  -- board made up for the game

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

-- in the update function update the position of the shape using dt, baseX, baseY and the table of destinations
function love.update(dt)

  -- listen for a key press on the escape key, at which point quit the application
  if love.keyboard.wasPressed('escape') then
    love.event.quit()
  end

  -- reset keyPressed to an empty table
  love.keyboard.keyPressed = {}
end

-- in the draw function loop through the drawBoard() function
function love.draw()
  push:start()

  -- in the draw board function specify where the board ought to be displayed
  -- the screen is 512 by 288
  -- the grid is 256 by 256
  -- to center it position it at (512-256) / 2 and (288-256) / 2
  drawBoard((512-256) / 2, (288-256) / 2)

  push:finish()
end


-- function generating an 8x8 table made up of 1 table for each row, itself made up of 1 table for each column
function generateBoard()
  -- create a table storing the tables themselves storing the different tiles
  tiles = {}
  -- 8 rows (which change in their y coordinate)
  for y = 1, 8 do
    -- include a table
    table.insert(tiles, {})

    -- 8 columns (which change in their x coordinate)
    for x = 1, 8 do
      -- in the table created for the row include tables responsible for the tiles' coordinates and a random value for the tiles' shapes
      table.insert(tiles[y], {
        x = (x - 1) * 32, -- 32px wide, starting at 0, then incrementing by 32 for each successive tile
        y = (y - 1) * 32,

        -- random integer used to identify a random quad from the quad table
        tile = math.random(#tileQuads)
      })
    end
  end

  -- return the table of tiles
  return tiles
end

-- function drawing one cell with the tables' values
function drawBoard(offsetX, offsetY)
  -- loop through the rows
  for y = 1, 8 do
    -- loop through the tiles
    for x = 1, 8 do
      -- retrieve the specific tile to avoid repeating it in the draw function
      local tile = board[y][x]

      -- draw the tile using the coordinate and index specified in the table
      -- add the offset to move the grid in the screen
      love.graphics.draw(tileSprite, tileQuads[tile.tile], tile.x + offsetX, tile.y + offsetY)
    end
  end

  -- return the table of tiles
  return tiles
end