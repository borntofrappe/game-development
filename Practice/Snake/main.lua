require "Snake"

local MARGIN_TOP = 44
local PADDING_Y = 8
local PADDING_X = 8

COLUMNS = 24
ROWS = 16
CELL_SIZE = 20

GRID_WIDTH = CELL_SIZE * COLUMNS
GRID_HEIGHT = CELL_SIZE * ROWS

local WINDOW_WIDTH = GRID_WIDTH + PADDING_X * 2
local WINDOW_HEIGHT = GRID_HEIGHT + MARGIN_TOP + PADDING_Y * 2
local INTERVAL = 0.5

function love.load()
  math.randomseed(os.time())
  love.window.setTitle("Snake")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.51, 0.64, 0.51)
  local font = love.graphics.newFont("res/font.ttf", 38)
  love.graphics.setFont(font)

  --[[
    waiting
    playing
    gameover
  ]]
  state = "waiting"

  --
  snake = Snake:new()
  time = 0
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "p" then
    snake:eat({points = math.random(100)})
  end

  if key == "r" then
    snake:reset()
  end

  if key == "right" or key == "left" or key == "up" or key == "down" then
    snake:turn(key)
  end
end

function love.update(dt)
  time = time + dt
  if time >= INTERVAL then
    time = time % INTERVAL
    snake:update()
  end
end

function love.draw()
  love.graphics.setColor(0.15, 0.15, 0.16)
  love.graphics.print(snake.points, PADDING_X, PADDING_Y)
  love.graphics.setLineWidth(4)
  love.graphics.line(PADDING_X, MARGIN_TOP, WINDOW_WIDTH - PADDING_X, MARGIN_TOP)

  love.graphics.line(
    PADDING_X,
    MARGIN_TOP + PADDING_Y,
    WINDOW_WIDTH - PADDING_X,
    MARGIN_TOP + PADDING_Y,
    WINDOW_WIDTH - PADDING_X,
    WINDOW_HEIGHT - PADDING_Y,
    PADDING_X,
    WINDOW_HEIGHT - PADDING_Y,
    PADDING_X,
    MARGIN_TOP + PADDING_Y
  )

  love.graphics.translate(PADDING_X, MARGIN_TOP + PADDING_Y)
  snake:render()

  -- displayGrid()
end

function displayGrid()
  love.graphics.setColor(0.15, 0.97, 0.46)

  love.graphics.setLineWidth(1)
  for i = 0, COLUMNS + 1 do
    love.graphics.line(CELL_SIZE * i, 0, CELL_SIZE * i, GRID_HEIGHT)
  end

  for i = 0, ROWS + 1 do
    love.graphics.line(0, CELL_SIZE * i, GRID_WIDTH, CELL_SIZE * i)
  end
end
