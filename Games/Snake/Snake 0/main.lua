-- constants used across the game
-- the width/ height of the screen are best as a multople of the width/ height of the snake, as the size of the snake is used to build the grid in which the snake ultimately moves
WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
SNAKE_WIDTH = 20
SNAKE_HEIGHT = 20



--[[
  love.load
  - game's title
  - window's size
  - snake properties

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
  snake = {
    x = (math.random(WINDOW_WIDTH / SNAKE_WIDTH) - 1) * SNAKE_WIDTH,
    y = (math.random(WINDOW_HEIGHT / SNAKE_HEIGHT) - 1) * SNAKE_HEIGHT,
    width = SNAKE_WIDTH,
    height = SNAKE_HEIGHT
  }


end

--[[
  love.draw
  - solid background
  - square
]]

function love.draw()
  love.graphics.clear(0.035, 0.137, 0.298, 1)

  love.graphics.setColor(0.224, 0.824, 0.604, 1)
  -- position and resize the square according to the defined variables
  love.graphics.rectangle('fill', snake.x, snake.y, snake.width, snake.height)
end
