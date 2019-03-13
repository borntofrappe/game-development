-- require Dependencies.lua, injecting all necessary code files
require 'src/Dependencies'

--[[
  love.load
  - game's title
  - window's size
  - snake instance
  - table of item instances
  - table of appendage instances
  - opacity for the grid
  - score
]]
function love.load()
  love.window.setTitle('Snake')

  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = false,
    vsync = true
  })

  gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['normal'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['big'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['humongous'] = love.graphics.newFont('fonts/font.ttf', 48)
  }
  -- random seed to have math.random() truly random
  math.randomseed(os.time())

  -- create an instance of the snake class specifying the x and y coordinates
  snake = Snake:init({x = randomCell(), y = randomCell()})

  -- create a table for the instances of the item class
  items = {}
  -- immediately add an instance to have it rendered/updated on the screen
  local item = Item:init({
      x = randomCell(),
      y = randomCell(),
      color = randomColor()
    })
  table.insert(items, item)


  -- create a table for the instances of the appendage class
  appendages = {}

  -- opacity to toggle the visibility of the grid
  gridOpacity = 0

  -- score = 0
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
    if key == value then
      snake.direction = key
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
  - update the appearance of the itemss
  - update the position of the snake
]]
function love.update(dt)
  -- loop through the table items
  for k, item in pairs(items) do
    -- update each item
    item:update(dt)

    -- detect collision between snake and the single item
    -- update the score and set the flag inPlay to false
    if snake:collides(item) then
      item.inPlay = false
      -- score = score + 50

      -- appendage
      -- initialize the variables describing the coordinates of the appendage
      local appendageX = snake.x
      local appendageY = snake.y

      -- modify the coordinates according to the movement of the snake and to always have the appendage spawn the opposite side the snake hits the item
      -- ! use the number of appendages to determine the distance from the snake's head
      if snake.dx == 0 then
        -- vertical movement
        appendageY = snake.dy > 0 and appendageY - snake.height * (#appendages + 1) or appendageY + snake.height * (#appendages + 1)
      else
        -- horizontal movement
        appendageX = snake.dx > 0 and appendageX - snake.width * (#appendages + 1) or appendageX + snake.width * (#appendages + 1)
      end

      local appendage = Appendage:init({
          x = appendageX,
          y = appendageY,
          dx = snake.dx,
          dy = snake.dy,
          -- include the number of cells the appendage needs to cross before turning
          turns = #appendages + 1
        })
      table.insert(appendages, appendage)
    end

    -- if the item has the boolean inPlay set to false remove it from the table
    if not item.inPlay then
      -- ! k refers to the index of the item in the table, not an identifier describing the item itself
      table.remove(items, k)
    end
  end

  -- if the table of items is empty (which can occur given that every item is eventually hidden from view with the inPlay boolean)
  -- add an item
  if #items == 0 then
    addItem()
  end

  -- update the instance(s) of the Appendage class
  -- pass the direction taken by the snake to update the direction of the appendage(s) if need be
  for k, appendage in pairs(appendages) do
    appendage:update(dt, snake.dx, snake.dy)
  end

  -- update the snake
  snake:update(dt)
end



--[[
  love.draw
  - solid background
  - grid to show the movement of the square
  - circle(s) for the item(s)
  - square(s) for the appendages
  - square for the snake
  - score
]]
function love.draw()
  love.graphics.clear(0.035, 0.137, 0.298, 1)

  -- use the opacity defined in the variable
  love.graphics.setColor(0.224, 0.824, 0.604, gridOpacity)
  -- include the stroke of a rectangle for each cell of the grid
  for x = 1, WINDOW_WIDTH / SNAKE_WIDTH do
    for y = 1, WINDOW_HEIGHT / SNAKE_HEIGHT do
      love.graphics.rectangle('line', (x - 1) * SNAKE_WIDTH, (y - 1) * SNAKE_HEIGHT, SNAKE_WIDTH, SNAKE_HEIGHT)
    end
  end
  -- reset the opacity (this would be reset in the item or snake class, but may cause unexpected behaviors otherwise)
  love.graphics.setColor(1, 1, 1, 1)

  -- draw the item(s) **before** the snake, to have the snake on top of them
  for k, item in pairs(items) do
    item:render()
  end

  -- the order between the appendages and the snake is less relevant, but have the snake above the other shapes
  for k, appendage in pairs(appendages) do
    appendage:render()
  end

  snake:render()

  -- love.graphics.setFont(gFonts['normal'])
  -- love.graphics.setColor(1, 1, 1, 1)
  -- love.graphics.print('Score: ' .. tostring(score), 8, 8)

end




-- function returning the coordinates of a random cell in the grid made up of CELL_SIZE tiles
function randomCell()
  return (math.random(WINDOW_WIDTH / CELL_SIZE) - 1) * CELL_SIZE
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
  local newItem = Item:init({
    x = randomCell(),
    y = randomCell(),
    color = randomColor()
  })

  table.insert(items, newItem)
end
