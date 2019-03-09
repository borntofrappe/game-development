-- constants used across the game
-- the width/ height of the screen are best as a multople of the width/ height of the snake, as the size of the snake is used to build the grid in which the snake ultimately moves
WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
SNAKE_WIDTH = 20
SNAKE_HEIGHT = 20
SNAKE_SPEED = 2



--[[
  love.load
  - game's title
  - window's size
  - snake properties
  - table populated with arrow keys

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


  -- position the snake randomly in the screen, but always at a multiple of 10
  -- at 0, 10, 20 and so forth up to but not including the window's width or height
  -- initially have the square static on the screen
  snake = {
    x = (math.random(WINDOW_WIDTH / SNAKE_WIDTH) - 1) * SNAKE_WIDTH,
    y = (math.random(WINDOW_HEIGHT / SNAKE_HEIGHT) - 1) * SNAKE_HEIGHT,
    dx = 0,
    dy = 0,
    width = SNAKE_WIDTH,
    height = SNAKE_HEIGHT
  }

  -- table in which to add the arrow keys
  arrowKeys = {}

  -- opacity to toggle the visibility of the grid
  gridOpacity = 0
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
    -- if the key matches one of the values, add the key to the prescribed table
    if key == value then
      table.insert(arrowKeys, key)
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
  - update x and y
  - check the arrowKeys table for a direction
]]
function love.update(dt)

  -- update the position of the square
  snake.x = snake.x + snake.dx
  snake.y = snake.y + snake.dy

  -- update the position of the square when reaching a track in the grid
  if snake.x % SNAKE_WIDTH == 0 and snake.y % SNAKE_HEIGHT == 0 then
    -- look at the arrowKeys table, specifically if it includes more than one item
    if #arrowKeys > 0 then
      -- retrieve the last item from the table
      local key = arrowKeys[#arrowKeys]
      -- change dx and dy according to the actual value of the last key
      if key == 'up' then
        snake.dy = -SNAKE_SPEED
        snake.dx = 0
      elseif key == 'down' then
        snake.dy = SNAKE_SPEED
        snake.dx = 0
      elseif key == 'right' then
        snake.dy = 0
        snake.dx = SNAKE_SPEED
      elseif key == 'left' then
        snake.dy = 0
        snake.dx = -SNAKE_SPEED
      end
      -- empty the table
      arrowKeys = {}
    end
  end


  -- if the square exceeds the boundaties of the screen, have it spawn the opposite way from which it came
  if snake.x < 0 - snake.width then
    snake.x = WINDOW_WIDTH
  end

  if snake.x > WINDOW_WIDTH then
    snake.x = 0 - snake.width
  end

  if snake.y < 0 - snake.height then
    snake.y = WINDOW_HEIGHT
  end

  if snake.y > WINDOW_HEIGHT then
    snake.y = 0 - snake.height
  end

end


--[[
  love.draw
  - solid background

  - grid to show the movement of the square

  - square
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

  love.graphics.setColor(0.224, 0.824, 0.604, 1)
  -- position and resize the square according to the defined variables
  love.graphics.rectangle('fill', snake.x, snake.y, snake.width, snake.height)
end
