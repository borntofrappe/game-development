-- require Dependencies.lua, injecting all necessary code files
require 'src/Dependencies'

--[[
  love.load
  - game's title
  - window's size
  - snake instance
  - item instance
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

  item = Item:init({
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
end



--[[
  love.update(dt)
  - update the appearance of the item
  - update the position of the snake
]]
function love.update(dt)
  item:update(dt)
  snake:update(dt)

  -- detect a collision with the item

  if snake:collides(item) and item.inPlay then
    item.inPlay = false
    score = score + 50
  end
end



--[[
  love.draw
  - solid background

  - grid to show the movement of the square

  - square(s) for the item(s)

  - square for the snake
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
  item:render()

  snake:render()

  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print('Score: ' .. tostring(score), 8, 8)

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

