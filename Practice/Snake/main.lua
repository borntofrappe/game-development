require "Snake"
require "Food"

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
local INTERVAL = 0.2

function love.load()
  math.randomseed(os.time())
  love.window.setTitle("Snake")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.51, 0.64, 0.51)

  font = love.graphics.newFont("res/font.ttf", 38)
  fontSmall = love.graphics.newFont("res/font.ttf", 22)
  love.graphics.setFont(font)

  --[[
    waiting
    playing
    gameover
  ]]
  state = "waiting"

  --
  snake = Snake:new()
  food = Food:new()
  time = 0
end

function love.keypressed(key)
  if key == "escape" then
    if state == "waiting" or state == "gameover" then
      love.event.quit()
    elseif state == "playing" then
      state = "waiting"
    end
  end

  if key == "return" then
    if state == "gameover" then
      snake:reset()
      food = Food:new()
      state = "waiting"
    end
  end

  if key == "right" or key == "left" or key == "up" or key == "down" then
    if state == "waiting" then
      state = "playing"
    end
    snake:turn(key)
  end
end

function love.update(dt)
  if state == "playing" then
    time = time + dt
    if time >= INTERVAL then
      time = time % INTERVAL

      if snake:eatsItself() then
        state = "gameover"
      else
        snake:update()

        if snake:collides(food) then
          snake:eat(food)
          food = Food:new()
        end
      end
    end
  end
end

function love.draw()
  love.graphics.setColor(0.15, 0.15, 0.16)
  love.graphics.setFont(font)
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
  food:render()
  snake:render()

  if state == "waiting" or state == "gameover" then
    love.graphics.setColor(0.15, 0.15, 0.16, 0.2)
    love.graphics.rectangle("fill", 0, 0, GRID_WIDTH, GRID_HEIGHT)
    love.graphics.setColor(0.15, 0.15, 0.16)
    love.graphics.setFont(font)
    love.graphics.printf(
      state == "waiting" and "Snake" or "Gameover",
      0,
      GRID_HEIGHT / 2 - font:getHeight(),
      GRID_WIDTH,
      "center"
    )
    love.graphics.setFont(fontSmall)
    love.graphics.printf(
      state == "waiting" and "Move with arrow keys" or "Press enter to continue",
      0,
      GRID_HEIGHT / 2,
      GRID_WIDTH,
      "center"
    )
  end

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
