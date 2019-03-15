-- require Dependencies.lua, injecting all necessary code files
require 'src/Dependencies'

--[[
  love.load()
]]
function love.load()
  -- title
  love.window.setTitle('Snake')

  -- window size
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = false,
    vsync = true
  })

  -- fonts
  gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['normal'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['big'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['humongous'] = love.graphics.newFont('fonts/font.ttf', 48)
  }

  -- random seed to have math.random() truly random
  math.randomseed(os.time())

  -- create a table in which to add the snakes instances
  snakes = {}
  -- immediately add an instance of the snake class specifying the x and y coordinates
  -- the first square is positioned at random in the grid
  local snakeX, snakeY = randomCell()
  local snake = Snake:init({
    x = snakeX,
    y = snakeY,
    color = {
      r = 0.224,
      g = 0.824,
      b = 0.604
    }
  })

  table.insert(snakes, snake)

  -- create a table for the instances of the item class
  items = {}
  -- immediately add an instance to have it rendered/updated on the screen
  -- as with each instance, position it at random in the grid and give it a random color
  local itemX, itemY = randomCell()
  local color = randomColor()
  local item = Item:init({
      x = itemX,
      y = itemY,
      color = color
    })
  table.insert(items, item)


  -- opacity to toggle the visibility of the grid
  gridOpacity = 0

  -- score updated when detecting a collision with the items
  score = 0
end


-- react to a key press on a selection of keys
function love.keypressed(key)
  -- ARROW KEYS
  -- create a table of acceptable keys
  local keys = {
    'up',
    'right',
    'down',
    'left'
  }
  -- loop through the table of acceptable keys
  for k, value in pairs(keys) do
    -- if the key matches one of the values, update the direction of the snake
    -- ! update the direction of only the first instance, identifying the head of the snake


    if key == value then
      -- update the direction of the first instance only (the head of the snake)
      snakes[1].direction = key
    end
  end

  -- if the key matches the escape character, prematurely quit the game
  if key == 'escape' then
    love.event.quit()
  end

  -- when pressing g toggle the opacity of the grid
  if key == 'g' then
    gridOpacity = gridOpacity == 0 and 1 or 0
  end

  -- when pressing t add instances of the item class to the items table
  if key == 't' then
    addItem()
  end
end


--[[
  love.update(dt)
]]
function love.update(dt)
  -- loop through the table items
  for k, item in pairs(items) do
    -- update each item
    item:update(dt)

  -- detect collision between each instance of the snake shape and the item
    if snakes[1]:collides(item) then
      -- update score
      score = score + 50
      -- set inPlay on the item to false, to have it later removed from the table
      item.inPlay = false

      -- NEW INSTANCE of SNAKE
      -- detail the x and y coordinate on the basis of the position and movement of the previous instance
      local previousSnake = snakes[#snakes]
      local snakeX = previousSnake.x
      local snakeY = previousSnake.y

      -- modify the coordinates according to the movement of the previous square and to always have the new square on the back of the previous one
      if previousSnake.dx == 0 then
        -- vertical movement
        snakeY = previousSnake.dy > 0 and snakeY - CELL_SIZE or snakeY + CELL_SIZE
      else
        -- horizontal movement
        snakeX = previousSnake.dx > 0 and snakeX - CELL_SIZE or snakeX + CELL_SIZE
      end

      -- define the instance of the snake
      local snake = Snake:init({
        -- coordinates computed on the basis of the previous square
        x = snakeX,
        y = snakeY,
        -- speed of the previous square
        dx = previousSnake.dx,
        dy = previousSnake.dy,
        threshold = 5,
        -- slightly lighter hue
        color = {
          r = 0.4,
          g = 0.75,
          b = 0.5
        }
      })
      -- include the instance
      table.insert(snakes, snake)

    end -- end of loop detecting collision

    -- if the item has the inPlay flag set to false remove it from the table
    if not item.inPlay then
      -- ! k refers to the index of the item in the table, not an identifier describing the item itself
      table.remove(items, k)
    end
  end -- end of loop through the items

  -- if the table of items is empty add an item
  if #items == 0 then
    addItem()
  end


  -- loop through the table of snakes
  for i = 1, #snakes do
    -- if the hasTurned flag is true
    if snakes[i].hasTurned then
      -- switch hasTurned and direction to false and nil respesctively
      snakes[i].hasTurned = false
      -- ! for all instances except the last give the direction to the instance which follows
      if i < #snakes then
        snakes[i + 1].direction = snakes[i].direction
      end
      snakes[i].direction = nil
    end
  end

  -- update the instances of the snake class
  for t, snake in pairs(snakes) do
    snake:update(dt)
  end
end



--[[
  love.draw()
]]
function love.draw()
  -- background
  love.graphics.clear(0.035, 0.137, 0.298, 1)

  -- grid
  -- display the grid using the opacity defined in the matching variable
  -- creating a grid based on the cell size
  love.graphics.setColor(0.224, 0.824, 0.604, gridOpacity)

  for x = 1, WINDOW_WIDTH / CELL_SIZE do
    for y = 1, WINDOW_HEIGHT / CELL_SIZE do
      love.graphics.rectangle('line', (x - 1) * CELL_SIZE, (y - 1) * CELL_SIZE, CELL_SIZE, CELL_SIZE)
    end
  end
  -- reset the opacity (this would be reset in the item or snake class, but may cause unexpected behaviors otherwise)
  love.graphics.setColor(1, 1, 1, 1)

  -- draw the item(s) **before** the snake, to have the snake on top of them
  for k, item in pairs(items) do
    item:render()
  end

  -- draw the instances of the snake class
  for k, snake in pairs(snakes) do
    snake:render()
  end

  -- include the score in the top left corner
  love.graphics.setFont(gFonts['normal'])
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print('Score: ' .. tostring(score), 8, 8)

end


-- function returning the coordinates of a random cell in the grid made up of CELL_SIZE tiles
-- returing 2 random values
function randomCell()
  return (math.random(WINDOW_WIDTH / CELL_SIZE) - 1) * CELL_SIZE, (math.random(WINDOW_WIDTH / CELL_SIZE) - 1) * CELL_SIZE
end

--[[
  function returning a table of random rgb colors, as in
    {
      r = 1,
      g = 1,
      b = 1
    }

]]
function randomColor()
  local color = {}
  local hexes = {'r', 'g', 'b'}

  -- include a random hex between 0.5 and 1
  for k, hex in pairs(hexes) do
    color[hex] = math.random(50, 100) / 100
  end

  return color
end

-- function adding an instance of the item class in the items table
function addItem()
  local x, y = randomCell()
  local color = randomColor()
  local newItem = Item:init({
    x = x,
    y = y,
    color = color
  })

  table.insert(items, newItem)
end
