-- constants (three 100 tiles centered in the 500 container)
WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
TILE_SIZE = 100

-- Tile class
require 'Tile'

-- in love.load set up the window
function love.load()
  love.window.setTitle('D&S Feature Study')

  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = false,
    vsync = true
  })

  -- create a table of Tile instances
  tiles = {}
  -- add 9 tiles to the table
  -- three rows
  for y = 1, 3 do
    table.insert(tiles, {})
    -- three columns
    for x = 1, 3 do
      local tile = Tile:init({
        x = TILE_SIZE * x,
        y = TILE_SIZE * y,
        -- different color to distinguish between tiles
        color = {
          r = 0.3 * x,
          g = 0.3 * y,
          b = 0.1 * x * y
        }
      })
      table.insert(tiles[y], tile)
    end
  end

  -- detail a table in which to include the coordinates of the cursor
  cursor = {
    x = 0,
    y = 0
  }
  -- boolelan in which to detail whetehr the cursor is down on the screen or not
  cursorDown = false
  -- variable describing the selected tile
  selectedTile = nil

end

-- ! not relevant to the drag feature
-- when pressing escape quit the game early
function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end

  -- ! testing swap
  -- when pressing s swap two arbitrary tiles
  if key == 's' then
    swapTiles(tiles[1][1], tiles[1][2])
  end
end

-- through love.mousepressed set the cursorDown boolean to true
function love.mousepressed(x, y, button)
  -- true when the cursor is registered through its primary button
  if button == 1 then
    cursorDown = true
  end
end

-- in love.mousereleased switch cursorDown back to false
function love.mousereleased()
  cursorDown = false
  -- set the .isSelected flag on each tile to false, removing the selection
  for k, row in pairs(tiles) do
    for t, tile in pairs(row) do
      tile.isSelected = false
    end
  end
  -- set selectedTile back to nil
  selectedTile = nil
end


-- in love.update(dt) update the application, the cursor coordinates and the tiles if need be
function love.update(dt)
  -- update the coordinates as long as the mouse is down on the screen
  if cursorDown then
    cursor.x = love.mouse.getX()
    cursor.y = love.mouse.getY()

    -- update the tiles
    for k, row in pairs(tiles) do
      for t, tile in pairs(row) do
        tile:update(dt)

        -- analyse the tile with a flag of .isSelected
        -- ! the application needs to ensure there is only one at a time
        if tile.isSelected then
          -- consider the tile described in the selectedTile variable
          -- if nil (initial value and following a mousereleased), set it up to match the tile with the selected flag
          if not selectedTile then
            selectedTile = tile

          -- if different from the tile with the selected flag, implement the swap
          elseif selectedTile ~= tile then
            swapTiles(selectedTile, tile)
            tile.isSelected = false
          end -- evaluating selectedTile end

        end -- tile.isSelected end
      end -- tile for loop end
    end -- row for loop end
  end -- cursorDown end
end -- love.update end

-- in love.draw include the grid made up in the tiles table
function love.draw()
  for k, row in pairs(tiles) do
    for t, tile in pairs(row) do
      tile:render()
    end
  end
end


-- function swapping two tiles
function swapTiles(tile1, tile2)
  -- swap the tiles in the grid
  tile1, tile2 = tile2, tile1
  -- swap the tiles coordinates to have the grid visually updated
  tile1.x, tile2.x = tile2.x, tile1.x
  tile1.y, tile2.y = tile2.y, tile1.y
end