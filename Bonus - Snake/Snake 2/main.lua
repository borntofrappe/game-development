-- require Dependencies.lua, injecting all necessary code files
require 'src/Dependencies'

--[[
  love.load
  - game's title
  - window's size
  - snake instance
  - opacity for the grid
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
  - update the position of the snake
]]
function love.update(dt)
  snake:update(dt)
end



--[[
  love.draw
  - solid background
  - grid to show the movement of the square
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

  snake:render()
end



-- function returning the coordinates of a random cell in the grid made up of CELL_SIZE tiles
function randomCell()
  return (math.random(WINDOW_WIDTH / CELL_SIZE) - 1) * CELL_SIZE
end
