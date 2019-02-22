-- require dependencies.lua, itself calling for the necessary resources
require 'src/Dependencies'

-- in the load function set up the screen with the push library
function love.load()
  -- title of the screen
  love.window.setTitle('Time keeps passing by')

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

  -- maximum amount of time the shapes can take to change the x coordinate
  TIMER_MAX = 5

  -- variable update the dt value
  timer = 0

  -- variable to describe the last coordinate
  endX = VIRTUAL_WIDTH - 25

  -- table in which to describe the different shapes
  shapes = {}

  -- add shapes describing their coordinates and rate of change
  for i = 0, 250 do
    table.insert(shapes, {
      x = 0, -- starting on the left edge of the screen
      y = math.random(0, VIRTUAL_HEIGHT - 25), -- starting at a random height
      rate = math.random() + math.random(TIMER_MAX - 1) -- taking a random period of time to transition to the right edge (up to TIMER_MAX)
      -- [0-1] range + [1-9 range], to have a random floating number
    })
  end

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

-- in the update function update the position of the shape using dt and a constant for the speed
function love.update(dt)
  -- update the timer and as long as it is less than TIMER_MAX update the horizontal coordinate of each shape
  if timer <= TIMER_MAX then
    timer = timer + dt

    -- loop through the table and update the coordinate
    for k, shape in pairs(shapes) do
      shape.x = math.min(endX, endX * (timer / shape.rate))
    end
  end

  -- listen for a key press on the escape key, at which point quit the application
  if love.keyboard.wasPressed('escape') then
    love.event.quit()
  end

  -- reset keyPressed to an empty table
  love.keyboard.keyPressed = {}
end

-- in the draw function render the current time in the top left corner and a shape according to an x coordinate updated in the update function
function love.draw()
  push:start()

  love.graphics.setColor(1,1,1,1)
  love.graphics.setFont(gFonts['normal'])


  love.graphics.print(
    tostring(timer),
    8,
    8
  )

  -- render the different shapes
  for k, shape in pairs(shapes) do
    love.graphics.rectangle('fill', shape.x, shape.y, 25, 25)

    -- as long as the change in coordinates occur, change the color of the shapes at random
    if timer <= TIMER_MAX then
      love.graphics.setColor(math.random(),math.random(),math.random(),1)
    end
  end

  love.graphics.setColor(1,1,1,1)

  push:finish()
end