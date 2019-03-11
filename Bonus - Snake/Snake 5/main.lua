-- require Dependencies.lua, injecting all necessary code files
require 'src/Dependencies'

--[[
  love.load
  - game's title
  - window's size
  - snake instance
  - table of items instances
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

  -- random seed to have math.random() truly random
  math.randomseed(os.time())

  -- create an instance of the snake class specifying the x and y coordinates
  snake = Snake:init({x = randomCell(), y = randomCell()})

  -- create an table for the instance of the item class
  items = {}
  -- immediately add an instance to have it rendered/updated on the screen
  local item = Item:init({
      x = randomCell(),
      y = randomCell(),
      color = randomColor()
    })
  table.insert(items, item)

  -- opacity to toggle the visibility of the grid
  gridOpacity = 0

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
      score = score + 50
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


  snake:update(dt)
end



--[[
  love.draw
  - solid background
  - grid to show the movement of the square
  - circle(s) for the item(s)
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

  snake:render()

  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print('Score: ' .. tostring(score), 8, 8)

  -- silly string to verify the removal of items from the table bearing the same name
  love.graphics.print('Items in table: ' .. tostring(#items), 8, 28)
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