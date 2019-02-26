-- require dependencies.lua, itself calling for the necessary resources
require 'src/Dependencies'

-- in the load function set up the screen with the push library
function love.load()
  -- title of the screen
  love.window.setTitle('Chain Chain Chain')

  -- table for the fonts
  gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['normal'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['big'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['humongous'] = love.graphics.newFont('fonts/font.ttf', 56)
  }

  -- virtualization through the push library
  love.graphics.setDefaultFilter('nearest', 'nearest')
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = true,
    vsync = true
  })
  -- table in which to store the last recorded key press
  love.keyboard.keyPressed = {}

  -- maximum amount of time the shapes can take to complete each transition
  TIMER_MAX = 1

  -- size of the shape
  size = 25

  -- table describing the possible destinations of the shape
  -- targeting the four corners of the screen (considering the width and height of the shape itself)
  destinations = {
    [1] = {
      x = VIRTUAL_WIDTH - size,
      y = 0
    },
    [2] = {
      x = VIRTUAL_WIDTH - size,
      y = VIRTUAL_HEIGHT - size
    },
    [3] = {
      x = 0,
      y = VIRTUAL_HEIGHT - size
    },
    [4] = {
      x = 0,
      y = 0
    }
  }

  -- add a boolean to each destination determining if the shape has reached the coordinates
  -- the idea is to switch the value to true when the shape reaches each set of coordinates and change the coordinates one set at a time
  for k, destination in pairs(destinations) do
    destination.reached = false
  end

  -- variable accumulating the value of dt
  timer = 0

  -- variables describing the coordinates of the shape
  shapeX = 0
  shapeY = 0

  -- variables updated through dt
  -- as we move in different directions, we need to describe the starting point from which to update shapeX and shapeY
  baseX, baseY = shapeX, shapeY
end

-- in the resize function update the resolution through the push library
function love.resize(width, height)
  push:resize(width, height)
end

-- in the keypressed function keep track of the key being pressed in keyPressed
function love.keypressed(key)
  love.keyboard.keyPressed[key] = true
end

-- create a function to check whether a specific key was recorded in the keyPressed table
function love.keyboard.wasPressed(key)
  return love.keyboard.keyPressed[key]
end

-- in the update function update the position of the shape using dt, baseX, baseY and the table of destinations
function love.update(dt)
  -- update timer with dt to be the smallest between the incremented timer and the defined constant
  timer = math.min(timer + dt, TIMER_MAX)

  -- loop through the table of destinations
  -- ! use `ipairs` to go through the table in order (as opposed to `pairs`)
  for k, destination in ipairs(destinations) do
    -- if the destination is not reached
    if not destination.reached then
      --[[
        move the shape from its current position up to destination.x and destiation.y
        (destination.x - baseX) * timer / TIMER_MAX describes the change in coordinate
        baseX the starting point (which at first is 0, then VIRTUAL_WIDTH - size), updated every time the shape needs to change direction

        same reasoning for destination.y and baseY
      ]]

      shapeX, shapeY =
        baseX + (destination.x - baseX) * timer / TIMER_MAX,
        baseY + (destination.y - baseY) * timer / TIMER_MAX

      -- when reaching the destination reset the timer and set the boolean to true, to move toward the next destination
      if timer == TIMER_MAX then
        timer = 0
        destination.reached = true
        -- set baseX and baseY to refer to the acquired set of coordinates
        baseX, baseY = destination.x, destination.y
      end

      -- terminate the for loop to avoid having the logic run for more than one destination
      break
    end
  end

  -- listen for a key press on the escape key, at which point quit the application
  if love.keyboard.wasPressed('escape') then
    love.event.quit()
  end

  -- reset keyPressed to an empty table
  love.keyboard.keyPressed = {}
end

-- in the draw function render the current time in the top left corner and a shape according to the coordinates updated in the update function
function love.draw()
  push:start()

  love.graphics.setColor(1,1,1,1)
  love.graphics.rectangle('fill', shapeX, shapeY, size, size)


  love.graphics.setColor(0.15,1,0.55,1)
  love.graphics.setFont(gFonts['normal'])
  love.graphics.print(tostring(timer), 8, 8)

  push:finish()
end