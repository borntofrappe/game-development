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

  -- boolean describing whether an highlight is set
  highlighted = false
  -- highlighted tile
  highlightedTile = board[1][1]

  -- selected tile
  selectedTile = board[math.random(8)][math.random(8)]

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

-- in the update function handle the swap, changing the selection and highlight before actually swapping the tiles in the board
function love.update(dt)
  -- listen for a key press on the arrow keys, at which point update the reference of the selectedTile to the adjacent tile
  -- ! update the position in the [1-8] range, clamping the values to 1 and 8 respectively
  if love.keyboard.wasPressed('up') then
    selectedTile = board[math.max(1, selectedTile.gridY - 1)][selectedTile.gridX]
  end

  if love.keyboard.wasPressed('right') then
    selectedTile = board[selectedTile.gridY][math.min(8, selectedTile.gridX + 1)]

  end

  if love.keyboard.wasPressed('down') then
    selectedTile = board[math.min(8, selectedTile.gridY + 1)][selectedTile.gridX]
  end

  if love.keyboard.wasPressed('left') then
    selectedTile = board[selectedTile.gridY][math.max(1, selectedTile.gridX - 1)]
  end

  -- listen for a key press on the enter key
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    if highlighted then
      -- consider the selected and highlighted tile
      local tile1 = selectedTile
      local tile2 = highlightedTile

      -- proceed to swap only when the selected and highlighted tiles prove to be adjacent
      if math.abs((tile1.gridX - tile2.gridX) + (tile1.gridY - tile2.gridY)) == 1 then

        -- create temporary variables in which to store one side's coordinates
        local tempX, tempY = tile2.x, tile2.y
        local tempgridX, tempgridY = tile2.gridX, tile2.gridY
        -- create a temporary variable in which to store the other side's tile
        local tempTile = tile1

        -- swap the tiles in the board
        board[tile1.gridY][tile1.gridX] = tile2
        board[tile2.gridY][tile2.gridX] = tempTile

        -- swap the tiles on the screen moving to the coordinate each tile needs to assume after the swap
        Timer.tween(0.2, {
          -- using the temporary values for the tile being modified
          [tile2] = {x = tile1.x, y = tile1.y},
          [tile1] = {x = tempX, y = tempY}
        })
        -- immediately updat gridX and gridY, as the two don't reflect on the UI
        tile2.gridX = tile1.gridX
        tile2.gridY = tile1.gridY
        tile1.gridX = tempgridX
        tile1.gridY = tempgridY

        -- change the selected tile to have the outline placed on the swapped, destination tile
        selectedTile = tile2
      end

      -- always set highlighted to false, regardless of an actual swap occurring
      highlighted = false

    else
      -- update highlightedTile with the coordinate of the selectedTile
      highlightedTile = board[selectedTile.gridY][selectedTile.gridX]
      -- visualize the highlight through the semi-transparent filled rectangle
      highlighted = true

    end
  end

  -- listen for a key press on the escape key, at which point quit the application
  if love.keyboard.wasPressed('escape') then
    love.event.quit()
  end

  -- reset keyPressed to an empty table
  love.keyboard.keyPressed = {}

  -- update the timer
  Timer.update(dt)
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
        -- x and y describe the position on the screen
        x = (x - 1) * 32,
        y = (y - 1) * 32,
        -- gridX and gridY describe the position in the 8x8 grid
        gridX = x,
        gridY = y,

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

  -- draw the highlight through a semi-transparent, filled rectangle
  -- conditional on a tile being highlighted
  if highlighted then
    love.graphics.setColor(1, 1, 1, 0.4)
    love.graphics.rectangle('fill', highlightedTile.x + offsetX, highlightedTile.y + offsetY, 32, 32, 4)
    -- reset the opacity
    love.graphics.setColor(1, 1, 1, 1)
  end

  -- draw the selected tile through the outline of a rectangle
  love.graphics.setColor(1, 0, 0.3, 1)
  love.graphics.setLineWidth(4)
  love.graphics.rectangle('line', selectedTile.x + offsetX, selectedTile.y + offsetY, 32, 32, 4)

  -- reset the color
  love.graphics.setColor(1, 1, 1, 1)

end